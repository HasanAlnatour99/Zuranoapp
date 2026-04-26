---
name: flutter-en-ar-localization
description: Enforces English and Arabic localization with ARB files, RTL-safe layouts, persisted locale switching, Arabic-capable typography, and intl formatting. Use when adding or changing UI copy, layouts, themes, locale state, ARB keys, RTL behavior, date/number formatting, or tests that must work in LTR and RTL.
---

# Flutter EN + AR localization (LTR / RTL)

## When this applies

Use for any Flutter work that touches user-visible text, reading order, alignment, spacing relative to screen edges, typography, or locale-dependent formatting. Treat localization as non-negotiable for new screens and refactors.

## Non-negotiable rules

1. **No hardcoded user-facing strings in UI** — no string literals in `Text`, labels, hints, titles, dialogs, snackbars, buttons, empty states, or validation messages shown to users. Comments and debug logs may stay in English.
2. **All UI strings come from ARB** — `lib/l10n/app_en.arb` (template) and `lib/l10n/app_ar.arb`. Generated code is the single source of truth in Dart (`AppLocalizations` / project-generated class name).
3. **Dependencies** — `flutter_localizations` (SDK), `intl`, and Flutter codegen for l10n. Ensure `pubspec.yaml` enables generation (see Flutter docs: `generate: true` and `l10n.yaml`).
4. **Locales** — English `en` (LTR), Arabic `ar` (RTL). Design for additional locales later: same key set in every ARB, no duplicate keys, descriptive names (`login_title`, `error_network_timeout`).

## Project file layout

- `lib/l10n/app_en.arb` — template; include `@` metadata for placeholders and descriptions where helpful.
- `lib/l10n/app_ar.arb` — Arabic translations for the same keys.
- Optional: `l10n.yaml` at repo root with `arb-dir`, `template-arb-file`, `output-localization-file` per team convention.

After ARB edits, run code generation (`flutter gen-l10n` or `flutter pub get` as configured) before relying on new getters.

## Using strings in UI

- Resolve copy with `AppLocalizations.of(context)!` (or the generated equivalent) inside widgets; pass **values** into shared widgets, not raw strings.
- For parameterized messages, use ARB placeholders and generated methods — do not concatenate translated fragments in Dart.
- **Accessibility / semantics**: use localized strings for labels where semantics expose text.

## RTL and layout (Arabic)

- **Do not** set `textDirection` on the whole app for “fixes”; rely on `MaterialApp` / `WidgetsApp` locale and directionality.
- Prefer **direction-aware** APIs:
  - `EdgeInsetsDirectional`, `BorderRadiusDirectional`, `AlignmentDirectional`, `PositionedDirectional`
  - `TextAlign.start` / `TextAlign.end` instead of `left` / `right` except rare, intentional cases
  - `MainAxisAlignment.start` / `end` and `CrossAxisAlignment.start` / `end` instead of `left` / `right` where appropriate
- **Icons that imply direction** (back, forward, navigation): use `Directionality.of(context)` or `Icon` variants that mirror in RTL (e.g. `Icons.arrow_back` is handled by `Material` back button; for custom rows use mirroring or swap icon per direction only when design requires).
- **Row vs Row with RTL**: default `Row` order follows child order; ensure visual order matches design in both directions (sometimes `Row` + `MainAxisAlignment.spaceBetween` is enough; sometimes child order or `Directionality` awareness is required).
- Verify **no clipped or overflowed** Arabic text: allow flexible width, `maxLines`, and test longer Arabic strings.

## Typography (premium in both languages)

- Arabic needs reliable glyphs and metrics. Prefer a bundled Arabic-capable family (e.g. **Cairo**, **Noto Sans Arabic**) or `google_fonts` with an Arabic-supporting family.
- Define **theme** `textTheme` / `fontFamily` so Latin and Arabic both look intentional; use `fontFamilyFallback` when mixing families so missing glyphs resolve cleanly.
- Avoid relying on a single Latin-only font for the whole app if Arabic strings exist anywhere.

## Formatting (dates, numbers, currency)

- Use **`intl`** (`DateFormat`, `NumberFormat`, etc.) with the **active locale** from app state / `Localizations.localeOf(context)`, not a hardcoded `'en'` locale string.
- Currency and compact formats: centralize formatters so QA can verify AR and EN outputs.

## Language switching and persistence

- Expose **two** user-facing languages: English and Arabic.
- Drive `MaterialApp` (or router wrapper) `locale` from **Riverpod** (or existing app state) so the whole tree rebuilds consistently.
- **Persist** the user’s choice (e.g. `shared_preferences` or an existing settings repository). On startup, resolve: saved locale → device locale if supported → fallback English.
- Changing locale must update **directionality** automatically (no manual `Directionality` wrapper hacks in feature screens).

## Scalable ARB practices

- **Keys**: `feature_section_purpose` style; stable over time; avoid renaming once shipped if avoidable.
- **One key, one meaning** — no duplicate strings with different keys unless copy truly diverges later.
- **Placeholders**: name them by meaning (`userName`, `count`), document in ARB metadata.
- **Plurals / gender**: use ARB ICU/select patterns; do not hand-roll plural logic in Dart for user-visible text.

## Testing

- **Every screen or flow** worth shipping: verify in **both** EN and AR (widget tests and/or golden tests). Include at least one RTL golden per critical screen when the project uses goldens.
- Smoke-test: longest plausible Arabic strings, formatted dates/numbers, and navigation after locale switch without restart if the product requires it.

## Integration with other project skills

- **`flutter-ui-builder`**: shared widgets (`AppTextField`, `AppButton`, etc.) must accept **already localized** `String` parameters (or `BuildContext` only if the widget internally calls `AppLocalizations` — prefer passing strings in for testability).
- **Business logic** must not embed UI copy; return error codes or enums and map to localized messages at the presentation layer.

## Quick checklist (before merge)

- [ ] No new user-visible string literals in Dart UI code
- [ ] Keys added to **both** `app_en.arb` and `app_ar.arb`
- [ ] LTR/RTL: directional padding/alignment; no hardcoded left/right for layout
- [ ] Dates/numbers use `intl` with current locale
- [ ] Fonts render Arabic cleanly; premium look preserved in both languages
- [ ] Locale switch + persistence covered; app restarts with correct language
- [ ] Tested (or automated) in EN and AR
