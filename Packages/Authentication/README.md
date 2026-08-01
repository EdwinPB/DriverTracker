# Authentication

Sign-in/sign-up flows, session state, and token management.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Interface Adapters (application services)
- **Current API:** `public enum Authentication {}` (namespace placeholder — no features yet)

## Purpose

Auth is high blast-radius: tokens are secrets, sessions expire, providers change. Isolating it keeps credential handling, token refresh, and session lifecycle in one auditable place instead of scattering login logic across features.

## Responsibilities

- Sign-in / sign-up / sign-out use cases
- Session state and lifecycle (`Authenticated`, `Anonymous`, `Expired`)
- Token acquisition, refresh, and storage (Keychain)
- Provider adapters (email/password, OAuth providers, third-party SDKs)
- Exposing an auth-token provider protocol (implemented here, consumed via Domain protocol by Networking)

## Ownership

Security-conscious app team member. Credential handling changes require security review.

## Allowed dependencies

- Core
- Domain
- Networking

## Forbidden dependencies

- Storage, Location, SyncEngine, Analytics, DesignSystem, Testing
- SwiftUI, CoreData, CoreLocation

## Belongs here

- `AuthService`, `AuthSession`, `SessionState`
- `KeychainTokenStore`
- `LoginUseCase`, `RefreshSessionUseCase`
- OAuth provider adapter
- `SessionTokenProvider` implementation (conforming to a Domain-declared protocol)

## Does NOT belong here

- Auth UI screens, forms, view models → app target
- Trip/route business logic → `Domain`
- User profiles persisted to database → `Storage`
- Session change → analytics events → `Analytics` (Auth may emit via injected Analytics protocol, must not depend on it directly)
- Sync behavior after login → `SyncEngine`

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
