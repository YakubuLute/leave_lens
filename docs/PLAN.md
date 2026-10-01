# Leaf Lens: Architecture & Roadmap

Leaf Lens is a Flutter app. You take or upload a photo of a leaf, and it tells you whether the leaf is healthy. If it isn't, it names the disease and explains how to treat it.

**Approach: hybrid.** A small on-device model runs first. It's fast, works offline and costs nothing per scan. When that model isn't confident, or the plant is one it doesn't know, the app asks a cloud vision model (Claude) through a small backend.

---

## 1. How a scan works

```
 ┌──────────────┐    ┌──────────────────┐   confident (≥ threshold)   ┌───────────────────┐
 │ Camera /     │───▶│ On-device TFLite │────────────────────────────▶│ Result screen     │
 │ Gallery      │    │ classifier       │                             │ + treatment from  │
 └──────────────┘    └────────┬─────────┘                             │ bundled database  │
                              │ low confidence / unsupported crop     └───────────────────┘
                              ▼                                                ▲
                     ┌──────────────────┐   HTTPS   ┌──────────────────┐       │
                     │ Online?          │──────────▶│ Backend proxy    │───────┘
                     │ (else: show best │           │ → Claude vision  │  structured JSON
                     │  guess + warning)│           └──────────────────┘
                     └──────────────────┘
```

1. The user picks or takes a photo. The app crops it to a square and resizes it to the model's input size, 224×224.
2. **On-device step:** the TFLite model returns probabilities for each class, such as `Tomato___Late_blight` or `Tomato___healthy`.
3. **Decision rule:** if the top probability is at least `T` (start at 0.80, then tune it on validation data), use that result. Pull symptoms and treatment for that class from `treatments.json`.
4. **Fallback:** if the result is below `T`, or the user marks the plant as one the model doesn't support, and the phone is online, send the image to the backend. The backend asks Claude for a strict JSON diagnosis.
5. **Offline and unsure:** show the best guess, clearly marked "Low confidence", and offer to re-check when the phone is back online.
6. Save the scan to local history.

### Why hybrid
| | On-device only | Cloud only | **Hybrid** |
|---|---|---|---|
| Works offline | ✅ | ❌ | ✅ for common cases |
| Cost per scan | free | paid | paid only for the uncertain ones |
| Plants covered | ~14 crops | any | any |
| Rejects photos that aren't leaves | poor | good | good, once it falls back |

**Known weakness of the on-device model:** a classifier always picks one of its classes. Show it a photo of a shoe and it may say "Apple scab". Mitigations:
- Add a `not_a_leaf` / background class during training. PlantVillage includes a background set.
- Use the confidence threshold and fall back to the cloud model, which can answer "not a leaf".

---

## 2. Components

### 2.1 Flutter app (`lib/`)

```
lib/
  main.dart
  app/
    app.dart                   # MaterialApp wired to LeafTheme
    router.dart                # go_router routes
  design_system/               # tokens, theme, Leaf* components (see CLAUDE.md §2)
  core/                        # errors, result types, config, utils
  domain/
    diagnosis.dart             # Diagnosis model (shared schema, see §3)
    diagnosis_service.dart     # abstract interface: Future<Diagnosis> diagnose(File)
  services/
    tflite_classifier.dart     # on-device inference
    cloud_diagnosis_client.dart# calls backend
    hybrid_diagnosis_service.dart # decision rule from §1
    treatment_repository.dart  # loads assets/data/treatments.json
    history_repository.dart    # local persistence
  features/
    scan/
      presentation/            # home, preview, result screens
      application/             # Riverpod providers / notifiers
    history/
      presentation/
      application/
assets/
  models/leaf_model.tflite
  models/labels.txt
  data/treatments.json
```

**Packages:**
| Need | Package |
|---|---|
| Pick/take photo | `image_picker` |
| Crop | `image_cropper` (optional) |
| Preprocess pixels | `image` |
| TFLite inference | `tflite_flutter` |
| HTTP | `dio` or `http` |
| Connectivity check | `connectivity_plus` |
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| History storage | `drift` (SQLite), or `hive_ce` for something simpler |

All three diagnosis services share the `DiagnosisService` interface. That lets the UI run against a stub on day one, and lets each service be tested on its own.

**Platform setup:**
- iOS `Info.plist`: add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`.
- Android: camera permission is handled by `image_picker`. `minSdk` must be at least 21 for `tflite_flutter`.

### 2.2 ML training pipeline (`ml/`), in Python

```
ml/
  requirements.txt     # tensorflow, tensorflow-datasets, numpy, matplotlib
  train.py             # transfer learning + fine-tuning
  export_tflite.py     # float16 / int8 quantisation
  evaluate.py          # confusion matrix, per-class accuracy, threshold tuning
  labels.txt
```

- **Data:** PlantVillage. It has ~54k images across 38 classes and 14 crops, and is available as `tfds.load("plant_village")` or on Kaggle.
  - Add **PlantDoc**, a smaller set of real field photos, for fine-tuning and testing. PlantVillage photos are shot in the lab on plain backgrounds, and accuracy drops a lot on real field photos.
  - If your users grow crops PlantVillage lacks, such as **cassava** or **cocoa**, add a dataset for them. The Makerere/Kaggle *Cassava Leaf Disease* dataset is one example. Otherwise those crops always go to the cloud.
- **Model:** MobileNetV2 or EfficientNet-Lite0 pretrained on ImageNet, with 224×224 input.
  1. Freeze the base and train only the head for ~5 epochs.
  2. Unfreeze the top layers and fine-tune at a low learning rate.
- **Augmentation:** random flip, rotation, brightness/contrast changes, random crop, and background clutter so lab images look more like field photos.
- **Export:** TFLite with float16 quantisation, which gives a file of about 5–10 MB. Use int8 if size matters.
- **Pick the threshold** `T` on a held-out field-photo set, not on PlantVillage. Choose the value where on-device accuracy above `T` is at least 95%.
- **Target to aim for:** above 95% top-1 on the PlantVillage test split. Report the PlantDoc number separately, because that's the realistic one.

### 2.3 Backend proxy (`backend/`)

The Claude API key **must not ship inside the app**, so the app calls a thin service of our own instead.

- **Stack:** Python **FastAPI**, matching the ML tooling, deployed to Cloud Run, Fly.io or Railway.
- **Endpoint:** `POST /v1/diagnose`. It takes a multipart image plus an optional `crop_hint`, and returns `Diagnosis` JSON (§3).
- **Calling Claude:**
  - Send the image as base64 with a system prompt that sets the agronomy role and asks for the JSON schema.
  - Use tool use or structured output so the reply always parses.
  - Model: start with `claude-haiku-4-5` for cost. Move to `claude-sonnet-5-5` if accuracy on hard cases isn't good enough.
- **Protection:**
  - Use Firebase App Check (or Play Integrity / App Attest) so only the real app can call the backend.
  - Rate-limit per device.
  - Cap image size at about 1 MB; the app resizes before upload.
- **Privacy:** don't store images by default. Logging images for retraining should be opt-in.

---

## 3. Shared `Diagnosis` schema

On-device and cloud results look the same to the UI:

```json
{
  "status": "healthy | diseased | not_a_leaf | uncertain",
  "crop": "Tomato",
  "disease": "Late blight",
  "pathogen": "Phytophthora infestans",
  "confidence": 0.93,
  "severity": "mild | moderate | severe | null",
  "source": "on_device | cloud",
  "symptoms": ["Dark, water-soaked lesions", "White mould on leaf underside"],
  "treatment": {
    "immediate": ["Remove and destroy infected leaves"],
    "organic": ["Copper-based fungicide"],
    "chemical": ["Chlorothalonil or mancozeb, following label directions"],
    "prevention": ["Water at the base", "Space plants for airflow", "Rotate crops"]
  },
  "disclaimer": "Guidance only — confirm with a local extension officer before applying chemicals."
}
```

`treatments.json` is keyed by model label. Each entry has the fields above minus `status`, `confidence` and `source`. **Have an agronomist or an agricultural extension resource review this content.** Pesticide rules and product availability differ by country.

---

## 4. Roadmap

| Phase | Deliverable | Done when |
|---|---|---|
| **0. Setup** | Folder structure, packages, **design system** (tokens, theme, core components, gallery), permissions | App builds on iOS + Android |
| **1. UI with a stub** | Home → pick image → preview → result screen, backed by a `FakeDiagnosisService` | Full flow works end-to-end with mock data |
| **2. Train model** | `ml/` scripts, trained `.tflite`, `labels.txt`, evaluation report | Above 95% on PlantVillage test; field-photo accuracy measured; `T` chosen |
| **3. On-device inference** | `TfliteClassifier` + `treatments.json` for all 38 classes | Real offline diagnoses in the app, under 300 ms on a mid-range phone |
| **4. Cloud fallback** | FastAPI backend, Claude integration, `HybridDiagnosisService`, App Check | Low-confidence or unknown-plant photos get a cloud answer; offline still works |
| **5. History & polish** | Scan history, empty and error states, loading animation, "re-check online" | Usable by testers |
| **6. Test & release** | Unit tests (services, decision rule), widget tests, beta through TestFlight / Play internal testing | Store-ready build |

**Suggested order:** do phases 1 and 2 in parallel, because model training can run while the UI is being built.

---

## 5. Open decisions

1. **Target crops.** Is PlantVillage's set enough (tomato, potato, maize, pepper, apple, grape and others)? Or do we need local crops such as cassava or cocoa from day one?
2. **Backend host:** Cloud Run, Fly.io or Railway. Should we use Firebase across the board (App Check, Analytics, Crashlytics)?
3. **Accounts.** Is history kept on the device only (simplest), or synced to the cloud, which needs sign-in?
4. **Languages.** English only, or also local languages for treatment text?
5. **Feedback loop.** Should users be able to mark a diagnosis wrong, so we can collect data for retraining?

## 6. Environment notes
- Flutter SDK: `~/Documents/develop/flutter` (3.47.5, Dart 3.13.4). It's on `PATH` through `~/.zshrc`.
