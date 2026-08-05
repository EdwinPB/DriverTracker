import SwiftUI

/// Semantic text styles built on Apple's Dynamic Type.
///
/// Names describe role (`display`, `body`, `value`, `button`), never size.
/// All styles use SF Pro and scale automatically from caption to AX-L.
/// Numeric styles use tabular figures so digits never jiggle.
///
/// Spec: Docs/design-language.md §4.
public enum TypographyToken {
    case display
    case title
    case headline
    case body
    case label
    case caption
    case button
    case value

    public var font: Font {
        switch self {
        case .display:
            .system(.largeTitle, design: .default, weight: .semibold).monospacedDigit()
        case .title:
            .system(.title, weight: .semibold)
        case .headline:
            .system(.headline, weight: .semibold)
        case .body:
            .system(.body)
        case .label:
            .system(.subheadline)
        case .caption:
            .system(.footnote)
        case .button:
            .system(.body, weight: .semibold)
        case .value:
            .system(.title2, weight: .semibold).monospacedDigit()
        }
    }
}

public extension View {
    /// Applies a semantic text style to the view.
    func textStyle(_ token: TypographyToken) -> some View {
        font(token.font)
    }
}
