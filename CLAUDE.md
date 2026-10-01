# CLAUDE.md

Instructions for Claude, and for any contributor, working on **Leaf Lens**. It's a Flutter app that diagnoses leaf health from a photo. If a leaf is unhealthy, the app names the disease and explains how to treat it.

- Product context: [README.md](README.md)
- Architecture and roadmap: [docs/PLAN.md](docs/PLAN.md). Read it before starting any feature.

---

## 1. Plan before you implement

**No implementation starts without an agreed plan.** This applies to every feature, refactor or non-trivial fix.

1. **Understand.** Read the relevant parts of `docs/PLAN.md`, the existing code and the design system. Ask about anything unclear before you assume.
2. **Write the plan.** Small tasks get a short plan in chat. Larger features get a doc at `docs/plans/<feature>.md`. Either way, cover:
   - **Goal:** what the user will see and be able to do.
   - **Files:** which ones you'll create and which you'll change.
   - **Design:** which design system components it uses, and any new components or tokens it needs.
   - **Data and state:** models, providers and services involved.
   - **Edge cases:** errors, offline, empty states, loading, and permission denied.
   - **Tests:** what you'll test and how.
   - **Open questions.**
3. **Get approval.** Wait for the user to confirm the plan before you write code.
4. **Implement in small steps.** Each step should leave the app in a working state.
5. **Verify.** Run `flutter analyze` and `flutter test`. Then summarise what changed and anything you deferred.

If the work turns out to be different from the plan, **stop and update the plan** instead of drifting quietly.

---

## 2. Design system

Leaf Lens has its own design system with an **earthy** look: cream surfaces, olive primary colour, terracotta accent and warm neutrals. It must **not** look like stock Material or Google.

Material stays underneath for the plumbing: accessibility, text input, and the screens that packages show. Screens never use raw Material styling.

### Location

```
lib/design_system/
  tokens/
    leaf_colors.dart        # palette + semantic colours (healthy, diseased, uncertain…)
    leaf_typography.dart    # type scale, font families
    leaf_spacing.dart       # spacing scale (4-pt grid)
    leaf_radii.dart         # corner radii
    leaf_shadows.dart       # elevation (mostly none; borders preferred)
    leaf_motion.dart        # durations and curves
  theme/
    leaf_theme.dart         # builds ThemeData (light/dark) from tokens
    leaf_theme_extension.dart # ThemeExtension carrying custom tokens
  components/
    leaf_button.dart, leaf_card.dart, status_badge.dart, scan_button.dart, …
  design_system.dart        # barrel export — the only import features use
```

### Rules

1. **Only tokens.** Never hard-code colours, font sizes, spacing, radii or durations in feature code. Use the tokens, for example `context.leafColors.primary` and `LeafSpacing.md`. A raw `Color(0x…)`, `EdgeInsets.all(13)` or `fontSize: 15` outside `tokens/` is a bug.
2. **Components first.** Screens are built from `Leaf*` components. Don't use `ElevatedButton`, `Card`, `Chip` and similar widgets directly in features. If no component fits, add one to the design system. Don't style a one-off inline.
3. **New components need a reason.** Add one only when the pattern appears, or will appear, in two or more places, or when it's a signature element like the result card or scan button. Each component:
   - Lives in its own file in `components/`.
   - Is a `StatelessWidget` where possible, with `const` constructors.
   - Exposes a small, typed API: variants as `enum`s, not loose booleans.
   - Reads all styling from the theme and tokens.
   - Supports light and dark mode and handles disabled and loading states.
   - Has a semantic label for accessibility and touch targets of at least 48×48.
   - Has a widget test.
4. **Status colours are reserved.** `healthy`, `diseased` and `uncertain` are only for diagnosis status. Always pair them with a text label and an icon, never colour alone.
5. **Readable outdoors.** People use the app in sunlight, so keep text contrast at WCAG AA or better and avoid tiny or light-grey text.
6. **The theme is the single source of truth.** `leaf_theme.dart` overrides Material defaults: no ripple splash, no surface tint, flat elevation with borders, custom fonts and shapes. That way, any Material widgets a package shows still match the app.
7. **Change tokens, not call sites.** To change the look, update the tokens or the theme. Don't patch individual screens.
8. **Showcase.** Keep a debug-only `DesignSystemGallery` screen that renders every component in each of its variants. Update it whenever you add or change a component.

---

## 3. Architecture and modular code

Organise code **by feature**, with clear layers. See `docs/PLAN.md` §2.1.

```
lib/
  main.dart
  app/            # App widget, router, top-level providers
  design_system/  # see §2
  core/           # cross-cutting: errors, result types, logging, utils, constants
  domain/         # pure Dart models + abstract interfaces (no Flutter imports)
  services/       # implementations: TFLite, cloud client, repositories
  features/
    <feature>/
      presentation/   # screens + feature-specific widgets
      application/    # Riverpod providers / notifiers (state + orchestration)
```

### Principles

- **Dependencies point one way:** `features → domain ← services`.
  - `domain` imports nothing from Flutter or `services`.
  - Widgets never call TFLite or HTTP directly. They go through a provider that depends on a `domain` interface, for example `DiagnosisService`.
- **Depend on abstractions.** Every service has an abstract interface in `domain/` and gets injected with Riverpod. This lets us swap the stub, TFLite, cloud and hybrid implementations, and makes testing easy.
- **One responsibility per unit.**
  - A file holds one public class or widget.
  - Keep a widget's `build` method short: extract sub-widgets as classes, not helper methods that return widgets.
  - Keep files under about 300 lines, and split them when they grow.
- **No logic in widgets.** Widgets render state and forward events. Business rules belong in the `application` or `domain` layer, for example the confidence threshold or the fallback decision.
- **Features don't import each other.** Shared code moves to `core/`, `domain/` or `design_system/`.
- **Config isn't code.** Keep thresholds, API base URLs and similar values in one config place, never scattered literals. Never commit secrets.

---

## 4. Code best practices

### Dart and Flutter
- Follow [Effective Dart](https://dart.dev/effective-dart) and the configured lints. `flutter analyze` must report **zero** issues.
- Format with `dart format .`.
- Use **sound null safety** properly. Avoid `!` unless a value can't be null, and add a comment explaining why when you do use it.
- Prefer **immutable** data: `final` fields, `const` constructors, `copyWith`. Use `freezed` or `equatable` for models if they're adopted. Don't mix both.
- Use `const` widgets wherever you can.
- Prefer `sealed` classes and exhaustive `switch` statements for state and result types, for example `DiagnosisStatus`.
- Use `async`/`await`, and always handle errors. Never leave a `catch (_) {}` empty.
- Dispose of controllers, streams and interpreters. In particular, close the TFLite `Interpreter`.

### Naming
- Files are `snake_case.dart`. Types are `PascalCase`. Members are `camelCase`.
- Choose descriptive names: `confidenceThreshold`, not `t`.
- Booleans read as questions: `isLoading`, `hasResult`.
- Design system components have a `Leaf` prefix, except for domain-specific names like `StatusBadge` and `ScanButton`.

### Error handling
- Services return typed results or throw typed exceptions defined in `core/errors/`. Never surface raw exception strings in the UI.
- Every async screen state handles **loading, success, empty and error**. The error state comes with a recovery action such as "Try again" or "Open settings".

### Comments and docs
- Write `///` doc comments on public APIs, especially design system components and domain interfaces.
- Comments explain **why**, not what. Remove code that's been commented out.

### Testing
- **Unit tests** for the domain logic and services, for example the hybrid decision rule, preprocessing and parsing.
- **Widget tests** for every design system component and every screen state.
- Put tests in `test/` mirroring the `lib/` structure. Use fakes that implement the domain interfaces instead of mocking internals.
- A bug fix comes with a test that reproduces the bug.

### Performance
- Keep heavy work off the UI thread: run image preprocessing and inference in an isolate (`Isolate.run` / `compute`).
- Resize images before inference or upload.
- Avoid rebuilding large widget trees. Use `select` in Riverpod and keep state as local as possible.

---

## 5. Commands

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis — must be clean
dart format .            # format
flutter test             # run tests
flutter run              # run on a device/simulator
```

`flutter` isn't on the shell `PATH` on this machine yet. If a command fails with "command not found", ask the user for the SDK path instead of skipping verification.

## 6. Git

- Make small commits that each focus on one thing, with imperative messages: "Add StatusBadge component".
- Don't commit generated files, secrets, `.env` files or large model binaries unless we agree to.
- Every commit must pass `flutter analyze` and `flutter test`.
