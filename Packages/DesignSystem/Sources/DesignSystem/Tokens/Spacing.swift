import CoreGraphics

/// Semantic spacing tokens on an 8-point grid.
///
/// Values describe role (`medium`, `large`, `section`), never position.
/// All values are multiples of 8 except `.micro` (4pt) — the one documented
/// sub-8 exception for tight inline gaps.
///
/// Spec: Docs/design-language.md §5.
public enum Spacing {
    case zero
    case micro
    case small
    case medium
    case large
    case xLarge
    case xxLarge

    public var rawValue: CGFloat {
        switch self {
        case .zero: 0
        case .micro: 4
        case .small: 8
        case .medium: 16
        case .large: 24
        case .xLarge: 32
        case .xxLarge: 48
        }
    }
}
