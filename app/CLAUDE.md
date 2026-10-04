# CLAUDE.md: Flutter app

Rules for the Leaf Lens **Flutter app** in `app/`. Run all commands below from this folder.

The repo-wide rules in the [root CLAUDE.md](../CLAUDE.md) also apply. That file covers planning before implementation, the shared contract and git.

---

## 1. Design system

Leaf Lens has its own design system with an **earthy** look: cream surfaces, olive primary colour, terracotta accent and warm neutrals. It must **not** look like stock Material or Google.

Material stays underneath for the plumbing: accessibility, text input, and the screens that packages show. Screens never use raw Material styling.

### Location

```
lib/design_system/
  tokens/
    leaf_palette.dart       # raw hex values — internal, not exported
    leaf_colors.dart        # semantic colour roles (light + dark) + status colours
    leaf_status.dart        # LeafStatus enum (healthy, diseased, uncertain, notALeaf)
    leaf_typography.dart    # Inter type scale
    leaf_spacing.dart       # spacing scale (4-pt grid)
    leaf_radii.dart         # corner radii
    leaf_shadows.dart       # elevation (mostly none; borders preferred)
    leaf_motion.dart        # durations, curves, reduced-motion helper
  theme/
    leaf_theme.dart         # builds ThemeData (light/dark) from tokens
    leaf_component_themes.dart # Material component overrides
    leaf_context.dart       # context.leafColors / context.leafText
    leaf_page_transitions_builder.dart
    leaf_font_licenses.dart # registers the bundled Inter and Phosphor licences
  icons/
    leaf_icons.dart         # semantic icon names → bundled Phosphor font
  components/
    leaf_pressable.dart     # internal: press, focus ring, semantics — not exported
    leaf_scaffold.dart, leaf_app_bar.dart, leaf_gap.dart,
    leaf_button.dart, leaf_icon_button.dart, leaf_card.dart, …
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
   - Builds tap behaviour on `LeafPressable`, so press feedback, focus rings and semantics stay consistent.
   - Has a widget test.
4. **Status colours are reserved.** `healthy`, `diseased` and `uncertain` are only for diagnosis status. Always pair them with a text label and an icon, never colour alone. Destructive actions and form errors use the separate `danger` role.
5. **Readable outdoors.** People use the app in sunlight, so keep text contrast at WCAG AA or better and avoid tiny or light-grey text.
6. **The theme is the single source of truth.** `leaf_theme.dart` overrides Material defaults: no ripple splash, no surface tint, flat elevation with borders, custom fonts and shapes. That way, any Material widgets a package shows still match the app.
7. **Change tokens, not call sites.** To change the look, update the tokens or the theme. Don't patch individual screens.
8. **Showcase.** Keep a debug-only `DesignSystemGallery` screen that renders every component in each of its variants. Update it whenever you add or change a component.

---

## 2. Architecture and modular code

Organise code **by feature**, with clear layers. See [docs/PLAN.md](../docs/PLAN.md) §2.1.

```
lib/
  main.dart
  app/            # App widget, router, top-level providers
  design_system/  # see §1
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

## 3. Code best practices

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
- **Contract tests.** When the Dart `Diagnosis` model is created (Phase 1), its tests must parse every file in `../contracts/fixtures/`. See the [contract rules](../CLAUDE.md#3-shared-contract).
- A bug fix comes with a test that reproduces the bug.

### Performance
- Keep heavy work off the UI thread: run image preprocessing and inference in an isolate (`Isolate.run` / `compute`).
- Resize images before inference or upload.
- Avoid rebuilding large widget trees. Use `select` in Riverpod and keep state as local as possible.

---

## 4. Commands

Run from `app/`:

```bash
flutter pub get          # install dependencies
flutter analyze          # static analysis — must be clean
dart format .            # format
flutter test             # run tests (includes goldens)
flutter run              # run on a device/simulator
```

**Golden tests** (screenshots of key components) are tagged `golden`. They're rendered on macOS and skipped in CI (`--exclude-tags golden`), because Linux renders text slightly differently. After an intentional visual change, regenerate them on macOS and check the new images before committing:

```bash
flutter test --tags golden --update-goldens
```

**Icons** come from the Phosphor font bundled in `assets/fonts/`. To add one, add a `const IconData` with its codepoint to `LeafIcons`, never an icon package.

The Flutter SDK is at `~/Documents/develop/flutter` and is on `PATH` through `~/.zshrc`. If `flutter` isn't found in a non-interactive shell, call `~/Documents/develop/flutter/bin/flutter` directly. Never skip verification.

Every commit that touches `app/` must pass `flutter analyze` and `flutter test`.
