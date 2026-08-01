# DesignSystem

Shared UI tokens, reusable components, and theme.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Interface Adapters (presentation foundation)
- **Current API:** `public enum DesignSystem {}` (namespace placeholder — no features yet)

## Purpose

DesignSystem gives every feature a consistent visual language and prevents each screen from re-defining colors, spacing, and buttons differently. It stays **domain-agnostic** — generic components that features fill with their own content.

## Responsibilities

- Design tokens: colors, spacing, typography, radii, elevation
- Reusable SwiftUI components: buttons, cards, input fields, badges, loading states
- View modifiers and style presets
- Theme (light/dark) and accessibility support
- Layout utilities

## Ownership

Design-owner + app team. Token changes can touch every screen — treat as a contract.

## Allowed dependencies

- Core

## Forbidden dependencies

- Domain, Networking, Storage, Authentication, Location, SyncEngine, Analytics, Testing
- CoreData, CoreLocation, network APIs

## Belongs here

- `ColorToken`, `Spacing`, `Typography` enums
- `PrimaryButton`, `Card`, `TextFieldView`, `StatusBadge`
- Reusable modifiers (`.cardStyle()`, `.errorState()`)
- Shared `ViewModifier` helpers

## Does NOT belong here

- Feature screens (trip list, map, login) → app target
- Domain-typed components (e.g., `TripRow` that takes a `Trip`) → app target; DesignSystem offers generic `Card`, features compose them
- Business logic, view models → app target
- Branded marketing assets or non-UI resources → `Resources/` at repo root

**Note — keeping it generic:** if a component must import `Domain` to render, it's a feature component, not a design-system component.

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
