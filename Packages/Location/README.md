# Location

GPS tracking, location authorization, geofencing, and trip recording.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Interface Adapters (framework driver)
- **Current API:** `public enum Location {}` (namespace placeholder — no features yet)

## Purpose

CoreLocation is the messiest platform dependency in the app: permissions, background modes, delegate callbacks, accuracy tuning. Location bundles all of it behind clean Domain-facing interfaces so GPS plumbing never leaks into features, and so the tracking logic is unit-testable without a real device.

## Responsibilities

- `CLLocationManager` wrapper and delegate handling
- Location authorization state and permission request flow
- Continuous trip tracking: sampling, start/pause/resume/stop
- Geofencing
- Mapping raw `CLLocation` samples to Domain value objects (e.g., `Coordinates`)
- Background-mode behavior and battery-aware tuning

## Ownership

App team member responsible for tracking reliability. Changes to tracking behavior affect battery and app-store permissions.

## Allowed dependencies

- Core
- Domain

## Forbidden dependencies

- Networking, Storage, Authentication, SyncEngine, Analytics, DesignSystem, Testing

## Belongs here

- `LocationService`, `AuthorizationManager`
- `TripTracker` — records `Coordinates` samples during a trip
- `GeofenceMonitor`
- Permission status mapping to a Domain enum

## Does NOT belong here

- Permission *UI* (explanation screens) → app target
- Persisting recorded trips → `Storage`
- Uploading trips to server → `Networking` / `SyncEngine`
- Trip entities or business rules → `Domain`
- Deciding what happens when a trip completes (analytics, sync, UI) → app target

**Note — location events:** Location emits samples; it does not decide what happens to them. Features/composition root wire samples to storage, sync, or analytics.

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
