import SwiftUI
import UIKit

/// Semantic color tokens — adaptive Light/Dark.
///
/// Names describe role (`background`, `primary`, `textPrimary`, `statusError`),
/// never hue. Do not introduce color-named tokens (no `Blue`, `Gray`).
///
/// Spec: Docs/design-language.md §3.
public enum ColorToken {
    // MARK: Surfaces

    public static var background: Color { Color.adaptive(light: 0xFFFFFF, dark: 0x0B0B0F) }
    public static var surface: Color { Color.adaptive(light: 0xF4F5F7, dark: 0x14141A) }
    public static var surfaceMuted: Color { Color.adaptive(light: 0xE9EAEF, dark: 0x1C1C24) }

    // MARK: Action

    public static var primary: Color { Color.adaptive(light: 0x0A6CFF, dark: 0x4C9AFF) }
    public static var primaryPressed: Color { Color.adaptive(light: 0x084BB3, dark: 0x2E79E8) }
    public static var onPrimary: Color { Color.adaptive(light: 0xFFFFFF, dark: 0x0B0B0F) }

    // MARK: Text

    public static var textPrimary: Color { Color.adaptive(light: 0x1A1A1E, dark: 0xF5F6FA) }
    public static var textSecondary: Color { Color.adaptive(light: 0x5B5E6B, dark: 0xC3C6D4) }
    /// Placeholders and disabled content only — never for readable content.
    public static var textDisabled: Color { Color.adaptive(light: 0x8A8E99, dark: 0x6A6E7B) }

    // MARK: Status

    public static var success: Color { Color.adaptive(light: 0x187A3B, dark: 0x3DBE63) }
    public static var warning: Color { Color.adaptive(light: 0xB25E00, dark: 0xFFB340) }
    public static var error: Color { Color.adaptive(light: 0xD70015, dark: 0xFF453A) }

    // MARK: Structure

    public static var separator: Color { Color.adaptive(light: 0xD9DAE0, dark: 0x2A2A33) }
}

extension Color {
    /// Adaptive color: resolves `light` in Light mode, `dark` in Dark mode.
    ///
    /// Static factory, not an `init`: initializers added in extensions on
    /// foreign types (SwiftUI.Color) are invisible to modules that import
    /// DesignSystem. A `static func` stays visible. Call sites are identical:
    /// `Color.adaptive(light:dark:)`.
    public static func adaptive(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: dark)
                : UIColor(hex: light)
        })
    }
}

private extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
