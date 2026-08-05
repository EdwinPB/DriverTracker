import CoreGraphics

/// Semantic corner-radius tokens.
///
/// Values describe role (`medium`, `large`, `pill`), never style intent.
/// `8` small elements (chips, badges), `12` standard controls/cards,
/// `20` sheets and modals, `pill` full pills/status.
///
/// Spec: Docs/design-language.md §6.
public enum Radius {
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 20
    public static let pill: CGFloat = 999
}
