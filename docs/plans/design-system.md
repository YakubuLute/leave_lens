# Plan: Leaf Lens design system

**Status:** draft, awaiting approval
**Roadmap phase:** 0 (Setup)
**Rules:** [CLAUDE.md §2](../../CLAUDE.md)

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
| **Calm confidence** | Generous spacing. A serif for headings gives an editorial, trustworthy voice. Body text is a friendly sans-serif. |
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
| `borderStrong` | `#9C8862`* | Control outlines (inputs, chips) | target ≥ 3:1 |
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

\* The exact `borderStrong` value will be tuned and checked during implementation.

**Status colours.** These are reserved for diagnosis results only. Each status has three tokens:
- `fg`: text and icon colour on the status's tinted background.
- `bg`: the tinted background itself.
- `solid`: the strong version, for meters and filled badges. It is also checked as text on the cream page.

| Status | `fg` | `bg` | `fg` on `bg` | `solid` | `solid` on page | On-solid text |
|---|---|---|---|---|---|---|
| `healthy` (jade, distinct from the olive brand colour) | `#1D5A3F` | `#DDEFE4` | **6.8** | `#2A7454` | **5.0** | `#FFFBF3`: **5.5** |
| `diseased` (brick red) | `#7A1F1A` | `#F6D9D5` | **7.8** | `#A1302A` | **6.3** | `#FFFBF3`: **6.9** |
| `uncertain` (ochre) | `#6B4A0C` | `#F5E7C8` | **6.6** | `#8A5D0E` | **5.1** | n/a |
| `notALeaf` | uses neutral tokens | n/a | n/a | n/a | n/a | n/a |

**Dark mode.** Warm charcoal, not blue-black. Every pair is checked against its own background.

| Token | Hex | Checked against | Contrast |
|---|---|---|---|
| `background` | `#16130F` | n/a | n/a |
| `surface` | `#201C16` | n/a | n/a |
| `surfaceSunken` | `#110E0B` | n/a | n/a |
| `border` | `#3A3328` | n/a | n/a |
| `textPrimary` | `#F1E9DA` | `background` | **15.4** |
| `textSecondary` | `#C2B49C` | `background` | **9.1** |
| `textMuted` | `#9A8C75` | `surface` | **5.2** |
| `onPrimary` | `#1E2A10` | `primary` `#A9C47F` | **7.8** |
| `onPrimaryContainer` | `#DCE8C6` | `primaryContainer` `#34461F` | **8.0** |
| `accent` | `#E39A6B` | `background` | **8.0** |
| `healthy` `fg` | `#8AD3A9` | `bg` `#173A2A` | **7.2** |
| `diseased` `fg` | `#F4A497` | `bg` `#4A1C17` | **7.2** |
| `uncertain` `fg` | `#EBC67E` | `bg` `#3D2D0E` | **8.2** |

### 3.2 Typography

- **Headings:** **Fraunces**, a warm, soft serif in the same spirit as the mockup.
- **Body and UI text:** **DM Sans**, friendly and very legible.
- Both fonts are under the SIL Open Font License. They're **bundled in `assets/fonts/`**, not loaded at runtime with `google_fonts`, because the app must work offline.

| Token | Font | Size / line height (sp) | Weight | Use |
|---|---|---|---|---|
| `display` | Fraunces | 32 / 40 | 600 | Hero headings, the result's disease name |
| `headline` | Fraunces | 24 / 32 | 600 | Screen titles |
| `title` | Fraunces | 20 / 28 | 500 | Card titles, sections |
| `titleSmall` | DM Sans | 17 / 24 | 600 | List titles, emphasis |
| `body` | DM Sans | 16 / 24 | 400 | Default text |
| `bodySmall` | DM Sans | 14 / 20 | 400 | Secondary text |
| `label` | DM Sans | 15 / 20 | 600 | Buttons, tabs, badges |
| `caption` | DM Sans | 12 / 16 | 500 | Metadata only. Never for essential information. |

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
    leaf_typography.dart       # text styles, ThemeExtension
    leaf_spacing.dart          # static consts
    leaf_radii.dart            # static consts
    leaf_shadows.dart          # static consts
    leaf_motion.dart           # static consts
  theme/
    leaf_theme.dart            # LeafTheme.light() / LeafTheme.dark() → ThemeData
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
| App bar | Same colour as the page, elevation 0, no colour change on scroll, Fraunces title aligned left. |
| Buttons | Filled, outlined and text button themes styled to match `LeafButton`, for package screens. |
| Inputs | Filled with `surfaceSunken`, radius `md`, `borderStrong` outline, 2 px `primary` border when focused. |
| Cards, dialogs, bottom sheets | Flat, hairline border, our radii, `surface` colour. |
| Snack bars | Floating, `textPrimary` background with `background` text, radius `md`. |
| Progress, switches, checkboxes | Use `primary` and `borderStrong`. |
| Page transitions | Fade combined with an 8 px upward slide, the same on iOS and Android. |
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
| `LeafAppBar` | `title`, `leading`, `actions` | Flat, serif title |
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
| Fraunces and DM Sans `.ttf` files | Bundled fonts, declared in `pubspec.yaml` |

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
9. Do a final review against CLAUDE.md §2 and §4, then commit.

## 11. Risks

| Risk | Mitigation |
|---|---|
| The terracotta accent and the "diseased" red look too similar | Make "diseased" a cooler brick red, keep the accent away from result screens, and always show status with icon and label |
| Fraunces renders large on small screens | The type scale is tested at 200%. Long disease names fall back to the `headline` size. |
| Package screens (camera, cropper) look native and off-brand | Theme what we can (`image_cropper` accepts colours), and accept that the native camera screen will look native |
| Spending too long polishing the design system | Stick to the v1 list. v2 components are built only when a feature needs them. |

## 12. Open questions

1. **Accent versus "diseased".** Are you happy with terracotta as the brand accent and brick red for disease? The alternative is an ochre/gold accent, which removes the overlap entirely.
2. **Fonts.** Fraunces and DM Sans? Alternatives: Lora with Nunito Sans (softer), or Young Serif with Inter (crisper).
3. **Icons.** Phosphor (rounded, has a duotone style) or Lucide (thinner, more minimal)?
4. **Dark mode.** I've specified the dark tokens. Should dark mode ship in v1, or should we polish light mode first and ship dark later?
5. **Golden tests.** Adding them gives visual regression checks but makes tests depend on the platform. I'd add them for the five most important components only. Agree?
