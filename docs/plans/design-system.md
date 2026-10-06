# Plan: Leaf Lens design system

**Status:** done. All eight steps were completed by 2026-10-06.
**Roadmap phase:** 0 (Setup)
**Rules:** [app/CLAUDE.md §1](../../app/CLAUDE.md)
**Paths:** relative to `app/`

## 1. Goal

Build a small, strict design system with an **earthy** look: warm, natural and calm. It should look nothing like stock Material. Every screen in Leaf Lens will be built only from these tokens and components, so the app looks consistent and the whole look can be changed in one place.

**Definition of done:**
- All tokens are defined, for light and dark mode.
- `LeafTheme` overrides Material's default look, so any Material screen a package shows also matches.
- The v1 components (§6) are built and tested.
- A debug-only gallery shows every component.
- A sample result screen is built only from the design system.
- `flutter analyze` is clean and `flutter test` passes.

## 2. Look and feel

| Principle | In practice |
|---|---|
| **Warm, not clinical** | Cream canvas, warm neutrals, olive primary, terracotta accent. No pure white or pure black. |
| **Flat and tactile** | Hairline borders instead of shadows. Soft corners. A press makes the element shrink slightly (to 0.97 scale) instead of showing a ripple. |
| **Calm confidence** | Generous spacing, and Inter set with strong, tightly spaced headings. |
| **Readable in the field** | All text meets WCAG AA contrast or better. Body text is at least 16 sp. Tap targets are large. |
| **Status is unmistakable** | Healthy, diseased and uncertain each have their own colour, **always** paired with an icon and a text label. |

## 3. Tokens

### 3.1 Colour

Every text pair below has been checked against WCAG 2.1. The ratio column shows the contrast against the background in the third column. AA requires 4.5:1 for body text.

**Light mode**

| Token | Hex | Used on | Contrast |
|---|---|---|---|
| `background` | `#F7F1E6` | Page canvas (cream) | n/a |
| `surface` | `#FFFBF3` | Cards, sheets | n/a |
| `surfaceSunken` | `#EFE6D4` | Input fills, insets | n/a |
| `border` | `#DCCFB4` | Decorative hairlines | n/a |
| `borderStrong` | `#8F7B57` | Control outlines (inputs, chips): `background` / `surface` / `surfaceSunken` | **3.6 / 4.0 / 3.3** (UI boundary AA is 3:1) |
| `textPrimary` | `#3A2E1F` | `background` | **11.7** |
| `textSecondary` | `#6B5B45` | `background` | **5.8** |
| `textMuted` | `#786852` | `background` | **4.8** |
| `primary` (olive) | `#4F6B2F` | `background` | **5.4** |
| `onPrimary` | `#FFFBF3` | `primary` | **5.9** |
| `primaryContainer` | `#E3E8D2` | n/a | n/a |
| `onPrimaryContainer` | `#2C3D18` | `primaryContainer` | **9.4** |
| `accent` (terracotta) | `#A9531F` | `background` | **4.7** |
| `onAccent` | `#FFFBF3` | `accent` | **5.2** |
| `accentContainer` | `#F6E0D2` | n/a | n/a |
| `onAccentContainer` | `#6E3412` | `accentContainer` | **7.6** |

**Status colours.** These are reserved for diagnosis results only. Each status has three tokens:
- `fg`: text and icon colour on the status's tinted background.
- `bg`: the tinted background itself.
- `solid`: the strong version, for meters and filled badges. It is also checked as text on the cream page.

| Status | `fg` | `bg` | `fg` on `bg` | `solid` | `solid` on page | On-solid text |
|---|---|---|---|---|---|---|
| `healthy` (jade, distinct from the olive brand colour) | `#1D5A3F` | `#DDEFE4` | **6.8** | `#2A7454` | **5.0** | `#FFFBF3`: **5.5** |
| `diseased` (brick red) | `#7A1F1A` | `#F6D9D5` | **7.8** | `#A1302A` | **6.3** | `#FFFBF3`: **6.9** |
| `uncertain` (ochre) | `#6B4A0C` | `#F5E7C8` | **6.6** | `#8A5D0E` | **5.1** | `#FFFBF3`: **5.6** |
| `notALeaf` | uses neutral tokens | n/a | n/a | n/a | n/a | n/a |

**Dark mode.** Warm charcoal, not blue-black. Every pair is checked against its own background.

| Token | Hex | Checked against | Contrast |
|---|---|---|---|
| `background` | `#16130F` | n/a | n/a |
| `surface` | `#201C16` | n/a | n/a |
| `surfaceSunken` | `#110E0B` | n/a | n/a |
| `border` | `#3A3328` | n/a | n/a |
| `borderStrong` | `#857760` | `background` / `surface` / `surfaceSunken` | **4.2 / 3.9 / 4.4** |
| `textPrimary` | `#F1E9DA` | `background` | **15.4** |
| `textSecondary` | `#C2B49C` | `background` | **9.1** |
| `textMuted` | `#9A8C75` | `surface` | **5.2** |
| `onPrimary` | `#1E2A10` | `primary` `#A9C47F` | **7.8** |
| `primary` | `#A9C47F` | `background` | **9.6** |
| `onPrimaryContainer` | `#DCE8C6` | `primaryContainer` `#34461F` | **8.0** |
| `accent` | `#E39A6B` | `background` | **8.0** |
| `onAccent` | `#2A1406` | `accent` | **7.6** |
| `onAccentContainer` | `#F6D2BA` | `accentContainer` `#4A2A15` | **9.1** |
| `healthy` `fg` | `#8AD3A9` | `bg` `#173A2A` | **7.2** |
| `diseased` `fg` | `#F4A497` | `bg` `#4A1C17` | **7.2** |
| `uncertain` `fg` | `#EBC67E` | `bg` `#3D2D0E` | **8.2** |
| `healthy` / `diseased` / `uncertain` `solid` | `#5FB98A` / `#E8806E` / `#D9A84E` | `background` | **7.8 / 6.8 / 8.5** |
| On-solid text (all statuses) | `#16130F` | each `solid` | **≥ 6.8** |

The contrast pairs above are enforced by `test/design_system/tokens/leaf_colors_contrast_test.dart`.

### 3.2 Typography

- **Font: Inter** for all text, headings and body alike. It's a clean, very legible sans-serif made for screens.
- The look stays warm through the palette, generous spacing and a tight, confident heading style: heavier weight and slightly negative letter spacing.
- The heading font is its own token (`LeafTypography.headingFamily`). A serif can be brought back later by changing that one line.
- Inter is under the SIL Open Font License. Four static weights (400/500/600/700) from Inter v4.1 are **bundled in `assets/fonts/`**, not fetched at runtime, because the app must work offline. The licence ships as `assets/fonts/OFL.txt` and is registered with Flutter's `LicenseRegistry`.

| Token | Size / line height (sp) | Weight | Letter spacing | Use |
|---|---|---|---|---|
| `display` | 32 / 40 | 700 | −0.6 | Hero headings, the result's disease name |
| `headline` | 24 / 32 | 700 | −0.4 | Screen titles |
| `title` | 20 / 28 | 600 | −0.2 | Card titles, sections |
| `titleSmall` | 17 / 24 | 600 | 0 | List titles, emphasis |
| `body` | 16 / 24 | 400 | 0 | Default text |
| `bodySmall` | 14 / 20 | 400 | 0 | Secondary text |
| `label` | 15 / 20 | 600 | 0 | Buttons, tabs, badges |
| `caption` | 12 / 16 | 500 | +0.2 | Metadata only. Never for essential information. |

Layouts must still work at **200% system text scale**, with no clipped text.

### 3.3 Spacing (4 pt grid)

| Token | Value |
|---|---|
| `xxs` | 4 |
| `xs` | 8 |
| `sm` | 12 |
| `md` | 16 |
| `lg` | 20 |
| `xl` | 24 |
| `xxl` | 32 |
| `xxxl` | 48 |

The screen side margin is `lg` (20). The gap between cards is `md`, and padding inside cards is `md`–`lg`.

### 3.4 Radii

| Token | Value | Use |
|---|---|---|
| `sm` | 8 | Badges, small chips |
| `md` | 12 | Buttons, inputs, list tiles |
| `lg` | 16 | Cards |
| `xl` | 24 | Bottom sheets, image frames |
| `full` | 999 | Pills, avatars, scan button |

### 3.5 Elevation

- **Default: none.** Surfaces are separated by `border` hairlines and colour differences.
- **`floating`**: one warm-tinted shadow, `#3A2E1F` at 12% opacity, offset (0, 8), blur 24. It's only for the scan button, bottom sheets and toasts.

### 3.6 Motion

- Durations: `fast` 120 ms (press feedback), `base` 200 ms (state changes), `slow` 320 ms (page transitions and reveals).
- Curves: `easeOutCubic` as the standard, and `easeOutBack` for the result reveal.
- Respect reduced motion: when `MediaQuery.disableAnimations` is on, skip animations entirely.

### 3.7 Icons

Material Icons are the most recognisably "Google" element, so we replace them with **Phosphor Icons** (`phosphor_flutter`), which are rounded and friendly.
- Use the regular weight, and the duotone weight for illustrations and empty states.
- Features never reference an icon package directly. They go through a `LeafIcons` class, so the icon set can be swapped in one file.

## 4. Theme architecture

```
lib/design_system/
  tokens/
    leaf_palette.dart          # raw hex values (private to the design system)
    leaf_colors.dart           # semantic colour set (light + dark), ThemeExtension
    leaf_status.dart           # LeafStatus enum (healthy, diseased, uncertain, notALeaf)
    leaf_typography.dart       # text styles, ThemeExtension
    leaf_spacing.dart          # static consts
    leaf_radii.dart            # static consts
    leaf_shadows.dart          # static consts
    leaf_motion.dart           # static consts
  theme/
    leaf_theme.dart            # LeafTheme.light() / LeafTheme.dark() → ThemeData
    leaf_component_themes.dart # Material component overrides
    leaf_page_transitions_builder.dart # fade + 8 px rise
    leaf_context.dart          # extension: context.leafColors, context.leafText
  icons/
    leaf_icons.dart            # semantic icon names → Phosphor
  components/                  # §6
  gallery/
    design_system_gallery.dart # debug-only
  design_system.dart           # barrel export
```

- **Colours and typography are `ThemeExtension`s.** They switch with light and dark mode, and they can animate between themes. Features read them with `context.leafColors.primary` or `context.leafText.title`.
- **Spacing, radii, shadows and motion are static constants**, because they don't change between themes: `LeafSpacing.md`, `LeafRadii.lg`.
- **`ColorScheme` and `TextTheme` are filled in from the tokens.** Any Material widget we don't wrap ourselves, such as an image picker dialog, a date picker or text selection handles, still uses our palette.
- Later, a **high-contrast "sunlight" mode** is just another `LeafColors` set. No component code would change.

### Material overrides in `LeafTheme`

| Area | Override |
|---|---|
| Tap feedback | `splashFactory: NoSplash.splashFactory` and `highlightColor: transparent`. Components handle press feedback themselves (scale and opacity). |
| Surfaces | `surfaceTintColor: transparent` everywhere. `scaffoldBackgroundColor` is `background`. |
| App bar | Same colour as the page, elevation 0, no colour change on scroll, title aligned left. |
| Buttons | Filled, outlined and text button themes styled to match `LeafButton`, for package screens. |
| Inputs | Filled with `surfaceSunken`, radius `md`, `borderStrong` outline, 2 px `primary` border when focused. |
| Cards, dialogs, bottom sheets | Flat, hairline border, our radii, `surface` colour. |
| Snack bars | Floating, `textPrimary` background with `background` text, radius `md`. |
| Progress, switches, checkboxes | Use `primary` and `borderStrong`. |
| Page transitions | Fade combined with an 8 px upward slide on Android and other platforms. **iOS keeps the native Cupertino transition**, because replacing it removes the edge swipe-back gesture iOS users expect. Changed during step 3. |
| Text selection | `primary` cursor, and `primaryContainer` for the selection highlight. |

## 5. Interaction and accessibility standards (every component)

- **Touch targets** are at least 48×48 dp.
- **Every component has these states:** default, pressed, focused (a visible 2 px `primary` ring), disabled (50% opacity, still labelled for screen readers) and loading where relevant.
- **Screen reader labels:** every component sets `Semantics`. Icon-only buttons require a `semanticLabel`.
- **Never colour alone:** status always appears as icon, label and colour together.
- **Haptics:** light haptic feedback on scan and when a result appears. It's off if the system setting is off.

## 6. Components

### v1: needed for the scan flow (Phase 1)

| Component | Variants and API (summary) | Notes |
|---|---|---|
| `LeafScaffold` | `title`, `body`, `actions`, `bottom` | Page background, safe area and side margins |
| `LeafAppBar` | `title`, `leading`, `actions` | Flat, left-aligned title |
| `LeafGap` | `LeafGap.md()` etc. | Spacing from tokens, so features never write `SizedBox(height: 13)` |
| `LeafButton` | `variant: primary/secondary/ghost/danger`, `size: md/lg`, `icon`, `isLoading`, `expand` | Press-to-scale feedback |
| `LeafIconButton` | `variant`, required `semanticLabel` | n/a |
| `LeafCard` | `variant: surface/sunken/outlined`, optional `onTap` | n/a |
| `StatusBadge` | `status: healthy/diseased/uncertain/notALeaf`, `size: sm/md` | Icon, label and colour |
| `ConfidenceMeter` | `value` (0–1), `status` | Bar, percentage and words ("High confidence") |
| `ScanButton` | `onPressed`, `isBusy` | The app's signature control: a large round button with a floating shadow and a pulse while scanning |
| `LeafImageFrame` | `image`, `aspectRatio`, placeholder | Rounded `xl` corners, warm placeholder |
| `LeafTabs` | Segmented tabs: `items`, `selected` | Treatment sections: immediate, organic, chemical, prevention |
| `LeafListTile` | `leading`, `title`, `subtitle`, `trailing`, `onTap` | History rows, settings |
| `LeafNotice` | `tone: info/warning/offline`, `message`, `action` | Low-confidence warning, offline notice, disclaimer |
| `LeafSheet` | `showLeafSheet(context, …)` | The camera / gallery picker |
| `LeafStateView` | `.empty()`, `.error(onRetry)`, `.loading()` | Standard screen states |
| `LeafToast` | `showLeafToast(context, message)` | Short confirmations |

### v2: later phases

- `LeafChip`, for crop hints and filters.
- `LeafBottomNav`, if we add tabs.
- `LeafTextField`, for feedback forms.
- `LeafSkeleton`, for loading placeholders.
- `LeafDialog`.

## 7. Gallery and sample screen

- **`DesignSystemGallery`** lives at the route `/_gallery` and is only registered when `kDebugMode` is true.
  - It shows each component in every variant and state.
  - It has controls to switch light/dark mode and text scale (100% / 150% / 200%).
- **Sample result screen.** A static mock built only from the design system: image frame, status badge, disease name, confidence meter, treatment tabs and disclaimer notice. It proves the look end-to-end before Phase 1.
- `main.dart` replaces the counter template with `LeafLensApp`, which uses `LeafTheme` and opens the gallery for now.

## 8. Dependencies

| Package | Why |
|---|---|
| `phosphor_flutter` | Icons |
| Inter `.ttf` files (v4.1, 400–700) | Bundled fonts, declared in `pubspec.yaml` |

No other packages are needed. Riverpod and go_router come in Phase 1.

## 9. Testing

- **Widget tests for every component:**
  - It renders in light and dark mode.
  - Variants apply the right tokens.
  - Callbacks fire.
  - Disabled and loading states block taps.
  - Semantics labels are present.
- **Text scale test:** key components at 200% scale don't overflow.
- **Token tests:**
  - A test asserts the contrast ratios in §3.1, so a future colour change can't silently break accessibility.
  - A test checks that `LeafColors.lerp` and `copyWith` behave correctly.
- **Golden (screenshot) tests: optional** (see open question 5).

## 10. Implementation steps

Each step ends with `flutter analyze` and `flutter test` passing.

1. Add the fonts and `phosphor_flutter`, update `pubspec.yaml`, and tighten `analysis_options.yaml` (stricter lints).
2. Add the token files and the contrast tests.
3. Build `LeafTheme` light and dark with all the Material overrides, plus the `context` extensions.
4. Create the `LeafLensApp` shell and remove the counter template.
5. Build the foundation components: `LeafScaffold`, `LeafAppBar`, `LeafGap`, `LeafButton`, `LeafIconButton` and `LeafCard`, with tests.
6. Build the diagnosis components: `StatusBadge`, `ConfidenceMeter`, `ScanButton` and `LeafImageFrame`, with tests.
7. Build the structure and feedback components: `LeafTabs`, `LeafListTile`, `LeafNotice`, `LeafSheet`, `LeafStateView` and `LeafToast`, with tests.
8. Build the gallery and the sample result screen.
9. Do a final review against app/CLAUDE.md §1 and §3, then commit.

## 11. Risks

| Risk | Mitigation |
|---|---|
| The terracotta accent and the "diseased" red look too similar | Make "diseased" a cooler brick red, keep the accent away from result screens, and always show status with icon and label |
| Long disease names overflow at large text sizes | The type scale is tested at 200%. Long disease names fall back to the `headline` size. |
| Package screens (camera, cropper) look native and off-brand | Theme what we can (`image_cropper` accepts colours), and accept that the native camera screen will look native |
| Spending too long polishing the design system | Stick to the v1 list. v2 components are built only when a feature needs them. |

## 12. Decisions (2026-10-01)

1. **Accent versus "diseased":** terracotta brand accent and brick red for disease, kept apart as described in §11.
2. **Font:** Inter for everything (see §3.2).
3. **Icons:** Phosphor (`phosphor_flutter` ^2.1.0).
4. **Dark mode:** included in v1, with the tokens in §3.1.
5. **Golden tests:** only for the five key components: `LeafButton`, `LeafCard`, `StatusBadge`, `ConfidenceMeter` and `ScanButton`.

### Changes during step 5 (2026-10-04)

- **Icons, amending decision 3.** `phosphor_flutter` 2.1.0 (last released May 2024) extends `IconData`, which is a `final` class in Flutter 3.47, so it doesn't compile. With the user's agreement, Phosphor's MIT-licensed regular font is bundled directly (`assets/fonts/Phosphor-Regular.ttf`). The icons are `const IconData` values in `LeafIcons`, and the package is removed. Duotone can be added the same way later if needed.
- **`danger` colour roles.** The "danger" button variant and form errors need a red that isn't the reserved `diseased` status colour. `danger`, `onDanger`, `dangerContainer` and `onDangerContainer` share the brick hue but are a separate role. Their contrast is tested.
- **`LeafPressable`.** An internal building block, not exported, giving every tappable component the same behaviour:
  - Shrink to 0.97 on press, instant when motion is reduced.
  - A 2 px focus ring, with Enter and Space activating the control.
  - Button semantics, where an explicit label replaces the child's text.
- **`LeafGap`** is a small render object rather than a `SizedBox`, so it takes space only along a `Row` or `Column`'s main axis.
- **Golden tests** are tagged `golden`. They're generated on macOS and skipped in Linux CI, because text rendering differs between platforms.

### Decisions during step 6 (2026-10-05)

- **`StatusBadge` default labels:** "Healthy", "Diseased", "Not sure" and "Not a leaf", each with its own icon. A `label` parameter overrides them, for translations later. `md` is 36 dp tall and `sm` is 28 dp, for list rows.
- **`ConfidenceMeter` bands:**
  - 85% and up reads "High confidence", 60% and up reads "Medium confidence", and anything lower reads "Low confidence".
  - These are **presentation only**. The hybrid model's fallback threshold `T` stays in config (PLAN §1).
  - The fill uses the status `solid` colour, on a track in the `border` colour. The track was first `surfaceSunken`, but that was nearly invisible on the dark page. Contrast tests require every status fill to reach at least 3:1 against the track.
- **`ScanButton`:**
  - An 88 dp olive disc with a camera icon and the `floating` shadow.
  - While busy, it shows a spinner and a pulsing ring, ignores taps and is announced as "Scanning". The pulse is static when motion is reduced.
  - A press gives a light haptic tap (§5).
- **`LeafImageFrame`:**
  - `xl` corners with a hairline border, and a fade-in on load.
  - Shows a leaf placeholder when there's no image, and an info placeholder if the image fails to load.
  - Decorative unless it's given a `semanticLabel`.
- **Goldens** now cover all five key components from decision 5.

### Decisions during step 7 (2026-10-05)

- **`LeafNotice` tones:**
  - `info` uses `primaryContainer`, `warning` uses `accentContainer`, `offline` uses `surfaceSunken` with `textSecondary`, and `error` uses `dangerContainer`. None of them use the reserved status roles.
  - The low-confidence notice on the result screen uses `info`, which keeps the accent away from results (§11).
  - An action is an underlined link in the notice's own colour, a 48 dp target. Notices are announced as live regions.
- **`LeafTabs`:**
  - A segmented control in a sunken track that scrolls sideways when it doesn't fit, so labels aren't squeezed at 200% text.
  - Each segment is a 48 dp target. The selected and mutually exclusive state goes on the same semantics node as the label, through a new `LeafPressable.isSelected`. Tests caught that an outer `Semantics` wrapper had attached those flags to the wrong node.
- **`LeafStateView`:** `.loading`, `.empty` and `.error`. The error variant **requires** `onRetry`, so the rule that every error offers recovery (app/CLAUDE.md §3) is enforced by the type system. Loading and error states are live regions.
- **`LeafListTile`:** at least 56 dp tall, and pressable only when `onTap` is set.
- **`showLeafSheet` and `LeafSheet`:** a themed modal sheet. The title is marked as a header for screen readers, and the sheet completes with the value it's closed with, or `null` when dismissed.
- **`showLeafToast`:** a themed floating snack bar for short confirmations. It replaces any toast already showing, and the label and action must be given together.
- **New icons:** `warning`, `error`, `offline` and `chevronRight`.
- **Contrast tests** now also cover the toast's inverted text and its action label.

### Decisions during step 8 (2026-10-06)

- **No route yet.** `go_router` arrives in Phase 1, so debug builds open the `DesignSystemGallery` as the home screen, and release builds keep the placeholder home, now on `LeafScaffold`. The check `kDebugMode && showGallery` folds to a constant, so release builds compile the gallery out. Phase 1 moves the gallery to a debug-only `/_gallery` route, as §7 intended.
- **Gallery layout:**
  - It lives in `lib/design_system/gallery/`, isn't exported from the barrel, and uses only the public `design_system.dart` API, like a feature would.
  - It has one section per group: foundations, actions, diagnosis, surfaces and feedback.
  - The light/dark and 100/150/200% text switches go through `GalleryFrame`, which also wraps pages opened from the gallery.
- **Sample result screen.** Its data mirrors `contracts/fixtures/valid/diseased.json`. Goldens in both modes act as an end-to-end visual check.
- **Smoke tests** scroll through the whole gallery in light, dark and 200% text, and fail on any rendering error. Together they exercise every component.
- **Final review against app/CLAUDE.md:**
  - No raw colours, numbers or Material widgets outside the design system's internals.
  - Status colours are read only by `StatusBadge` and `ConfidenceMeter`, plus the gallery's swatches.
  - Every public API is documented, except the internal palette constants, which have group comments.
  - `LeafStatusColors` moved to its own file, per the one-public-class rule.
  - Two files are slightly over 300 lines because of framework boilerplate: `leaf_colors.dart` at 312 (`copyWith` and `lerp` for 25 roles) and `leaf_component_themes.dart` at 315 (flat builder functions). Both were kept whole.

### Open issue for Phase 1

- **The four treatment tabs don't fit** at 100% text on 360–412 dp phones. "Prevention" is cut off, and the bar scrolls by design. The real result screen should decide whether to use shorter labels ("Now", "Organic", "Chemical", "Prevent"), fewer tabs, or a stacked layout.

