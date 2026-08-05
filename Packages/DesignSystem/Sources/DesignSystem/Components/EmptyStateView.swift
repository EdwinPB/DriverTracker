import SwiftUI

/// Placeholder shown when a screen or list has no content yet.
///
/// Composed exclusively from design tokens: optional SF Symbol in the
/// `.display` size, `.title` heading, `.body` subtitle, and an optional
/// `PrimaryButton` action. Content is centered and fills the available
/// space; use inside a sized frame when embedding in a `ScrollView`.
///
/// Spec: Docs/design-language.md §5, §7.
public struct EmptyStateView: View {

    private let systemImage: String?
    private let title: String
    private let subtitle: String?
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        systemImage: String? = nil,
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: Spacing.medium.rawValue) {
            if let systemImage {
                Image(systemName: systemImage)
                    .textStyle(.display)
                    .foregroundStyle(ColorToken.textSecondary)
                    .accessibilityHidden(true)
            }

            VStack(spacing: Spacing.small.rawValue) {
                Text(title)
                    .textStyle(.title)
                    .foregroundStyle(ColorToken.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .textStyle(.body)
                        .foregroundStyle(ColorToken.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle, let action {
                PrimaryButton(actionTitle, isFullWidth: false, action: action)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xLarge.rawValue)
    }
}

#Preview("Icon + title + subtitle") {
    EmptyStateView(
        systemImage: "location.slash",
        title: "No Trips Yet",
        subtitle: "Your recorded trips will appear here once you start driving."
    )
    .background(ColorToken.background)
}

#Preview("With action", traits: .sizeThatFitsLayout) {
    EmptyStateView(
        systemImage: "figure.walk",
        title: "Start Your First Trip",
        subtitle: "Begin tracking when you leave the yard.",
        actionTitle: "Start Trip"
    ) {}
    .background(ColorToken.background)
}

#Preview("Title only", traits: .sizeThatFitsLayout) {
    EmptyStateView(title: "Nothing here")
        .background(ColorToken.background)
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    EmptyStateView(
        systemImage: "wifi.slash",
        title: "Offline",
        subtitle: "Trip data will sync when you're back online.",
        actionTitle: "Retry"
    ) {}
    .background(ColorToken.background)
    .preferredColorScheme(.dark)
}
