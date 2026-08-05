import SwiftUI

/// Primary action button — the largest colored element on a screen.
///
/// Composed exclusively from design tokens: `ColorToken.primary`, the
/// `.button` text style, `Spacing.medium` gutters, and
/// `Radius.medium`. Meets the 44 pt minimum touch target and grows
/// with Dynamic Type (never clips at AX sizes).
///
/// Supports enabled, disabled, loading (non-interactive spinner), an
/// optional SF Symbol, and full-width or content-hugging layouts.
///
/// Spec: Docs/design-language.md §6, §9, §10.
public struct PrimaryButton: View {

    /// Minimum touch target per design language (§5). Public so sibling
    /// controls (fields, secondary actions) can align heights.
    public static let minimumHeight: CGFloat = 52

    private let title: String
    private let systemImage: String?
    private let isLoading: Bool
    private let isEnabled: Bool
    private let isFullWidth: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        systemImage: String? = nil,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.small.rawValue) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(ColorToken.onPrimary)
                } else if let systemImage {
                    Image(systemName: systemImage)
                        .textStyle(.button)
                }

                Text(title)
                    .textStyle(.button)
            }
        }
        .buttonStyle(PrimaryButtonStyle(
            isEnabled: isEnabled,
            isLoading: isLoading,
            isFullWidth: isFullWidth
        ))
        .disabled(!isEnabled || isLoading)
        .accessibilityLabel(isLoading ? "\(title), loading" : title)
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let isLoading: Bool
    let isFullWidth: Bool

    func makeBody(configuration: Configuration) -> some View {
        // Loading keeps active colors; it only blocks interaction.
        let effectivelyDisabled = !isEnabled && !isLoading

        let background: Color = if effectivelyDisabled {
            ColorToken.surfaceMuted
        } else if configuration.isPressed {
            ColorToken.primaryPressed
        } else {
            ColorToken.primary
        }

        let foreground: Color = effectivelyDisabled
            ? ColorToken.textDisabled
            : ColorToken.onPrimary

        configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, Spacing.medium.rawValue)
            .frame(
                maxWidth: isFullWidth ? .infinity : nil,
                minHeight: PrimaryButton.minimumHeight
            )
            .background(
                background,
                in: RoundedRectangle(cornerRadius: Radius.medium, style: .continuous)
            )
    }
}

#Preview("Enabled") {
    PrimaryButton("Start Trip", systemImage: "location.fill") {}
        .padding(Spacing.large.rawValue)
}

#Preview("States", traits: .sizeThatFitsLayout) {
    VStack(spacing: Spacing.large.rawValue) {
        PrimaryButton("Start Trip") {}
        PrimaryButton("End Trip", systemImage: "stop.fill") {}
        PrimaryButton("Syncing", isLoading: true) {}
        PrimaryButton("Save", isEnabled: false) {}
        PrimaryButton("Not full width", isFullWidth: false) {}
        PrimaryButton("Share", systemImage: "square.and.arrow.up", isFullWidth: false) {}
    }
    .padding(Spacing.large.rawValue)
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    VStack(spacing: Spacing.large.rawValue) {
        PrimaryButton("Start Trip", systemImage: "location.fill") {}
        PrimaryButton("Syncing", isLoading: true) {}
        PrimaryButton("Save", isEnabled: false) {}
    }
    .padding(Spacing.large.rawValue)
    .background(ColorToken.background)
    .preferredColorScheme(.dark)
}
