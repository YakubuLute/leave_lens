# 🍃 Leaf Lens

Leaf Lens is a mobile app that checks plant leaves for disease. You take or upload a photo of a leaf, and the app tells you whether it's **healthy** or **unhealthy**. If it's unhealthy, the app names the **disease** and explains **how to treat it**.

> **Status: planning.** The Flutter project has been created, but no features are built yet. The full architecture and roadmap are in [docs/PLAN.md](docs/PLAN.md).

---

## What it will do

- 📷 **Scan a leaf** with the camera, or pick a photo from the gallery.
- ✅ **Report health**: healthy, diseased, not a leaf, or uncertain.
- 🦠 **Name the disease and the crop**, with a confidence score. For example: *Tomato – Late blight, 93%*.
- 💊 **Give treatment guidance**: immediate steps, organic and chemical options, and how to prevent it next time.
- 📶 **Work offline** for common crops and diseases.
- 🕘 **Keep a history** of past scans.

## How it works

Leaf Lens uses a **hybrid ML approach**:

1. **On-device model.** A small TensorFlow Lite model runs on the phone. It's based on MobileNetV2 or EfficientNet-Lite and trained on the PlantVillage dataset of 38 classes across 14 crops. It's fast, works offline and costs nothing per scan. Treatment advice comes from a database bundled with the app.
2. **Cloud fallback.** If the on-device model isn't confident, or the plant is one it doesn't know, and the phone is online, the photo goes to a small backend. The backend asks a vision model (Claude) for a structured diagnosis.
3. **Shared result format.** Both paths return the same `Diagnosis` format, so the result screen looks the same either way.

```
Photo ─▶ On-device TFLite ──confident──▶ Result + bundled treatment
                 │
                 └─low confidence / unknown crop─▶ Backend ─▶ Claude vision ─▶ Result
```

See [docs/PLAN.md](docs/PLAN.md) for the decision rule, the result format, and why the project went hybrid.

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter (Dart): `image_picker`, `tflite_flutter`, `flutter_riverpod`, `go_router` |
| On-device ML | TensorFlow Lite (MobileNetV2 / EfficientNet-Lite0, 224×224) |
| Model training | Python + TensorFlow/Keras. Datasets: PlantVillage, plus PlantDoc for real field photos |
| Backend | Python FastAPI proxy to the Claude API (keeps the API key off the phone) |

## Project structure

The structure below is the plan. Most of these folders don't exist yet.

```
leaf_lense/
├── lib/            # Flutter app (screens, services, domain models)
├── assets/         # leaf_model.tflite, labels.txt, treatments.json
├── ml/             # Model training, export and evaluation scripts
├── backend/        # FastAPI diagnosis proxy
├── docs/PLAN.md    # Architecture and roadmap
├── android/ ios/   # Platform projects
└── test/
```

## Getting started

**Prerequisites:**
- Flutter SDK with Dart `^3.13.4`, with `flutter` on your `PATH`.
- Xcode for iOS, or Android Studio for Android.

**Run the app:**

```bash
flutter pub get
```

```bash
flutter run
```

Setup steps for model training (`ml/`) and the backend (`backend/`) will be added as those parts are built.

## Roadmap

| Phase | Deliverable |
|---|---|
| 0 | Project setup: structure, packages, theme, permissions |
| 1 | Full scan flow in the app, using a stubbed diagnosis service |
| 2 | Train and evaluate the TFLite model |
| 3 | On-device inference and treatment database |
| 4 | Cloud fallback: backend and Claude integration |
| 5 | Scan history and polish |
| 6 | Testing and beta release |

Open questions, such as which crops to support, where to host the backend, and which languages to offer, are tracked in [docs/PLAN.md §5](docs/PLAN.md).

## Disclaimer

Leaf Lens gives **guidance only**. Check with a local agricultural extension officer or agronomist before applying any chemical treatment. Pesticide rules and the products available differ from country to country.
