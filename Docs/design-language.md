# DriverTracker — Visual Language & Brand Personality

The design contract for the `DesignSystem` package. No component is built until this
spec is agreed, because every visual decision below traces back to who this product is
for: **professional drivers, mid-shift, in the cab**.

---

## 1. Brand personality

### Who it is

DriverTracker is a work tool, not a consumer gadget. It is the dashboard app a
professional uses to earn money. It must feel like the trustworthy end of a truck
console — solid, legible, unflappable — never like a game, never like a toy.

### Personality in four words

| Trait | What it means in practice |
|---|---|
| **Dependable** | Stable, consistent, never surprising. Same state looks the same every time. Numbers are trustworthy — no visual tricks. |
| **Focused** | Respects attention. One primary action per screen. Everything glanceable in under one second while driving is off-screen. |
| **Direct** | Plain language. "Trip started", "8.4 mi", "Synced 12:04". No decoration, no dead metaphors, no flourish. |
| **Workmanlike modern** | Clean, current iOS-native feel — but stoic. Think instrument panel in a modern truck: precise, quiet, premium, not flashy. |

### Voice — does and doesn't

- **Does:** short active sentences, concrete numbers, exact state words (`Synced`,
  `Offline`, `In progress`).
- **Does not:** exclamations, emoji, playful copy, gamification, urgency theatrics
  ("Your trips are waiting!").

### Brand "temperature"

Calm, mid-range, blue-leaning. No red energy, no green "go" everything, no flat black
sportiness. The dominant accent is a trustworthy blue; everything else stays neutral.

---

## 2. Design principles

1. **Readability beats beauty.** Any decision that trades legibility for flair is decided:
   legibility wins. Outdoors, in sunlight, at speed, in motion.
2. **Glanceable states.** Every state is encoded at least two ways (color **and** text or
   icon). Never color alone.
3. **Accessibility is not a mode.** Defaults are AA-compliant, Dynamic Type to AX-L, dark
   mode first-class (drivers work at night).
4. **One primary action per screen.** If two things look equally important, neither is.
5. **Numbers are heroes.** Mileage, odometer, trip totals are the product. They get the
   largest, most legible treatment on screen.
6. **Native first.** Use SF Pro, SF Symbols, system components. Custom work only where
   system can't meet principle 1–3.

---

## 3. Color system

### 3.1 Token set (light / dark)

All pairs below are **WCAG AA verified** (≥ 4.5:1 normal text, ≥ 3:1 large text/UI).

| Token | Light | Dark | Used for |
|---|---|---|---|
| `backgroundPrimary` | `#FFFFFF` | `#0B0B0F` | App background |
| `backgroundSecondary` | `#F4F5F7` | `#14141A` | Cards, grouped sections |
| `backgroundTertiary` | `#E9EAEF` | `#1C1C24` | Fills, subtle emphasis |
| `textPrimary` | `#1A1A1E` | `#F5F6FA` | Headlines, values, content |
| `textSecondary` | `#5B5E6B` | `#C3C6D4` | Labels, captions, metadata |
| `textTertiary` | (disabled only) | (disabled only) | Placeholder — never for content |
| `accent` | `#0A6CFF` | `#4C9AFF` | Primary actions, active selection, links |
| `accentPressed` | `#084BB3` | `#2E79E8` | Pressed state of accent |
| `statusSuccess` | `#187A3B` | `#3DBE63` | Completed, synced, healthy |
| `statusWarning` | `#B25E00` | `#FFB340` | Degraded, needs attention |
| `statusDanger` | `#D70015` | `#FF453A` | Errors, failures, stop conditions |
| `separator` | `#D9DAE0` | `#2A2A33` | Hairline dividers |

Contrast sanity (light mode, on white): accent 4.5:1, success 5.4:1, warning 4.6:1,
danger 5.4:1, textPrimary 17:1, textSecondary 7:1. Dark mode is equal or better.

### 3.2 Rules

- **Accent is one.** Never introduce a second action color. Everything actionable is the
  accent; everything status-y is semantic.
- **Semantic colors are status, not decoration.** Success/warning/danger only ever encode
  state, never brand.
- **Color is never the sole signal.** Danger also gets a warning glyph and the word
  "Failed". See §7.
- **No gradients, no shadows-on-text for hierarchy.** Hierarchy comes from weight and
  size (esp. under sun glare and Increase Contrast mode).

### 3.3 Color-vision deficiency

~8% of drivers (male skew) have red-green deficiency. Red/green pairs are the classic trap.
Rules:
- `statusDanger` vs `statusSuccess` are never distinguished by hue alone — always paired
  with distinct icons/text.
- Warning uses amber, not yellow-green, so it reads distinctly from success across the
  common deficiency types.

### 3.4 Dark mode

First-class, not an afterthought: drivers work nights. All colors are adaptive via
`UIColor(dynamicProvider:)`/asset catalogs. No hard-coded light colors anywhere in the
DesignSystem.

---

## 4. Typography

- **Family:** SF Pro (system) throughout. No custom fonts — SF is the most legible choice
  at driving distances and honors Dynamic Type for free.
- **Weights:** `semibold` for values and screen titles, `regular` for body and labels.
  No thin/ultralight weights — they die in sunlight.
- **Dynamic Type:** all text scales with Dynamic Type from `caption` to `AX-L`. UI must
  not break at any size. Headlines use larger **size** for hierarchy, not smaller weight.

### 4.1 Semantic text styles

Implemented as `Typography` in DesignSystem (SF Pro, Dynamic Type, `caption` → `AX-L`).

| Token | System style / weight | Use when |
|---|---|---|
| `.display` | Large Title / semibold, tabular digits | Screen-level hero numbers — odometer, trip total. One per screen. Numeric by design |
| `.title` | Title / semibold | Screen titles, section names ("Trips", "Reports") |
| `.headline` | Headline / semibold | Prominent lines inside content — current trip status, card titles, list-item titles |
| `.body` | Body / regular | Default content, instructions, descriptions |
| `.label` | Subheadline / regular | Field labels, metadata rows, property names |
| `.caption` | Footnote / regular | Timestamps, legal, unit notes under values. Never for readable content |
| `.button` | Body / semibold | Action labels — "Start Trip", "Save". Inherits 44pt+ touch target |
| `.value` | Title 2 / semibold, tabular digits | Mid-level numbers in cards — trip distance, duration, odometer rows |

Usage rules:

- Numbers use `.display` (hero) or `.value` (card) — never `.body` or `.headline`, which
  lack tabular figures.
- Hierarchy by size (`.display` → `.title` → `.headline`), never by weight on the same size.
- `.caption` is for metadata, not content — if you want the reader to read it, use `.body`.
- `.button` pairs with the `primary` color token on filled actions; it is not a replacement
  for `.body`.

### 4.2 Numbers

- **Every numeral uses tabular figures** (`.monospacedDigit()`). Odometer digits must not
  jiggle while counting — professional trust depends on it.
- Numbers always carry units: `8.4 mi`, `42 min`, `3 trips` — never bare digits.
- `-` for unknown values, not `0` (a missing odometer reading is not zero miles).

---

## 5. Spacing & layout

- **8-point grid.** Implemented as `Spacing` in DesignSystem.

| Token | Value | Use when |
|---|---|---|
| `.zero` | 0 | Removing space — edge-to-edge rows, full-bleed cells |
| `.micro` | 4 | The only sub-8 exception: tight inline gaps — number + unit ("8.4 mi"), icon to small label |
| `.small` | 8 | Tight gaps between inline elements — icon to label, between chips/badges |
| `.medium` | 16 | Default: card padding, screen gutters, between related rows |
| `.large` | 24 | Between grouped content blocks, between a field label and its input |
| `.xLarge` | 32 | Between sections, between cards in a scrolling list |
| `.xxLarge` | 48 | Major screen breaks — below hero values, above bottom action bars |

- No positional values (`paddingLeft`, `topSpacing`) — position comes from layout, space comes from this scale.
- Screen gutters: `.medium` (16). Card padding: `.medium` (16). Between related rows: `.small` (8). Between sections: `.xLarge` (32).
- Touch targets: **minimum 44 × 44 pt** always. Trip start/stop targets are 56+.
- Max line length for body copy: ~64 characters (readability without scanning).
- If a measurement isn't on this scale, the layout is wrong — fix the layout, not the token.

---

## 6. Shape, elevation, components' anatomy

- **Corner radius:** `Radius.small` (8) small elements (chips, badges), `Radius.medium` (12)
  standard controls/cards, `Radius.large` (20) sheets and modals, `Radius.pill` pills/status.
- **Elevation:** flat by default (readability + Increase Contrast friendly). Use hairlines
  and fills for separation, not shadows. Shadows only on sheets/floating elements, and
  only in light mode — none in dark mode.
- **Controls:** system components first (`Button`, `Toggle`, `Stepper`). Custom only to
  reach the accessibility bar in §2.

---

## 7. Iconography & status encoding

- **Source:** SF Symbols. Weight `medium` for inline, `bold` for status. No filled/outlined
  mixing within a row.
- **Every status state is a triad:** icon + word + color.

| State | Icon | Word | Color |
|---|---|---|---|
| Synced / healthy | `checkmark.circle.fill` | "Synced" | success |
| In progress | `location.fill` | "Recording" | accent |
| Offline | `wifi.slash` | "Offline" | warning |
| Failed | `exclamationmark.triangle.fill` | "Failed" | danger |

No state may render as a colored dot alone.

---

## 8. Motion & feedback

- **Feedback is immediate and physical:** trip start/stop trigger `UIImpactFeedbackGenerator`
  (success vs stop) + visual state change + optional short tone. A driver confirming a stop
  at a pickup needs tactile certainty without looking.
- **Motion is restraint:** fade/slide, < 300 ms, spring dampening for cards only.
- **Honor Reduce Motion** (`UIAccessibility.isReduceMotionEnabled`): crossfade instead of
  slide, no spring.
- **No looping animations** anywhere (battery, glare, distraction).

---

## 9. Glanceability rules (driving context)

- One primary action per screen; it is the largest colored element.
- The current trip state is always visible at the top while a trip is active — it is
  information the driver checks every few minutes.
- No autoplaying, no timed-dismiss notifications mid-drive, no full-screen interruptions
  while in motion.
- Background mode is assumed: trip state must be recoverable from a cold launch
  (see SyncEngine/Location scope).

---

## 10. Implementation mapping (DesignSystem)

Token names above map 1:1 to Swift enums in the `DesignSystem` package, e.g.:

- `ColorToken.background`, `ColorToken.primary`, `ColorToken.statusError`
- `Spacing.medium` (16), `Radius.medium` (12)
- `Typography.display`, `Typography.value` (tabular digits), `Typography.button`
- Components (`PrimaryButton`, `Card`, `StatusBadge`) are composed **only** from these tokens.

DesignSystem stays dependency-thin (Core only) — the spec above must never require importing
Domain or UIKit frameworks.

---

## 11. Acceptance criteria (before Sprint 1 ships UI)

- [ ] Every text/background pair meets WCAG AA 4.5:1 — verified with a contrast tool, not eyeballed
- [ ] Full UI readable at Dynamic Type `AX-L` with no clipped text
- [ ] Every status rendered with icon + word + color (no color-only)
- [ ] Dark mode reviewed and approved for night use
- [ ] All numerals in tabular figures
- [ ] Trip start/stop feedback verifiable without looking at screen
- [ ] App builds with warnings-as-errors and strict concurrency (existing CI gates)

## 12. Anti-patterns (review checklist)

- ✗ Color-only status (dots, tinted text without a word)
- ✗ Thin weights, low-contrast gray-on-gray ("elegant" body text under 4.5:1)
- ✗ Emoji or exclamation in product copy
- ✗ Second accent color for a "special" feature
- ✗ Decimal noise in numbers (`8.40` where `8.4` is true)
- ✗ Gradients behind text, drop shadows for hierarchy
- ✗ Success green used for branding anywhere
