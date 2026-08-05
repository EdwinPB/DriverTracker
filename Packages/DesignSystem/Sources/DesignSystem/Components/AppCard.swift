import SwiftUI

/// Surface container for grouping related content.
///
/// Composed exclusively from design tokens: `ColorToken.surface` fill,
/// `Radius.medium` corners, `Spacing.medium` padding.
/// Elevation is flat by default (spec §6: fills, not shadows); an explicit
/// soft shadow is available for floating elements but only in light mode.
///
/// Content is arbitrary via `ViewBuilder`, so cards can hold text, rows,
/// or nested controls.
///
/// Spec: Docs/design-language.md §5, §6.
public struct AppCard<Content: View>: View {

    @Environment(\.colorScheme) private var colorScheme

    private let isElevated: Bool
    private let content: Content

    public init(isElevated: Bool = false, @ViewBuilder content: () -> Content) {
        self.isElevated = isElevated
        self.content = content()
    }

    public var body: some View {
        content
            .padding(Spacing.medium.rawValue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ColorToken.surface,
                in: RoundedRectangle(cornerRadius: Radius.medium, style: .continuous)
            )
            .shadow(
                color: isElevated && colorScheme == .light
                    ? Color.black.opacity(0.08)
                    : Color.clear,
                radius: 8,
                y: 2
            )
    }
}

#Preview("Light") {
    ScrollView {
        VStack(spacing: Spacing.large.rawValue) {
            AppCard {
                VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                    Text("Trip Summary")
                        .textStyle(.headline)
                    Text("12.4 mi · 38 min · $14.50")
                        .textStyle(.body)
                        .foregroundStyle(ColorToken.textSecondary)
                }
            }

            AppCard(isElevated: true) {
                HStack(spacing: Spacing.medium.rawValue) {
                    Image(systemName: "location.fill")
                        .foregroundStyle(ColorToken.primary)
                    Text("Recording in progress")
                        .textStyle(.body)
                    Spacer()
                    PrimaryButton("Stop", systemImage: "stop.fill", isFullWidth: false) {}
                }
            }

            AppCard {
                VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                    Text("Last trip")
                        .textStyle(.label)
                        .foregroundStyle(ColorToken.textSecondary)
                    Text("$14.50")
                        .textStyle(.value)
                }
            }
        }
        .padding(Spacing.large.rawValue)
        .background(ColorToken.background)
    }
}

#Preview("Dark") {
    ScrollView {
        VStack(spacing: Spacing.large.rawValue) {
            AppCard {
                VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                    Text("Trip Summary")
                        .textStyle(.headline)
                    Text("12.4 mi · 38 min · $14.50")
                        .textStyle(.body)
                        .foregroundStyle(ColorToken.textSecondary)
                }
            }

            AppCard(isElevated: true) {
                HStack(spacing: Spacing.medium.rawValue) {
                    Image(systemName: "location.fill")
                        .foregroundStyle(ColorToken.primary)
                    Text("Recording in progress")
                        .textStyle(.body)
                    Spacer()
                    PrimaryButton("Stop", systemImage: "stop.fill", isFullWidth: false) {}
                }
            }
        }
        .padding(Spacing.large.rawValue)
        .background(ColorToken.background)
        .preferredColorScheme(.dark)
    }
}
