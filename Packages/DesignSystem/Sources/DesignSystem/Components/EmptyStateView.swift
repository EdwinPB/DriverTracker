import SwiftUI

/// Placeholder shown when a screen or list has no content yet.
///
/// Composed exclusively from design tokens: optional SF Symbol in the
/// `.display` size, `.title` heading, `.body` subtitle, and an optional
/// action area. Provide either a titled `PrimaryButton` via
/// `actionTitle`/`action`, or any custom content via the trailing
/// `actionArea` builder. Content is centered and fills available space;
/// use inside a sized frame when embedding in a `ScrollView`.
///
/// All text scales with Dynamic Type (caption → AX-L); colors adapt to
/// Dark Mode. The symbol is hidden from VoiceOver since it is decorative.
///
/// Spec: Docs/design-language.md §5, §7.
public struct EmptyStateView: View {

    private let systemImage: String?
    private let title: String
    private let subtitle: String?
    private let actionContent: AnyView?

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
        if let actionTitle, let action {
            self.actionContent = AnyView(
                PrimaryButton(actionTitle, isFullWidth: false, action: action)
            )
        } else {
            self.actionContent = nil
        }
    }

    public init<Content: View>(
        systemImage: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder actionArea: () -> Content
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.actionContent = AnyView(actionArea())
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
                    .multilineTextAlignment(.center)

                if let subtitle {
                    Text(subtitle)
                        .textStyle(.body)
                        .foregroundStyle(ColorToken.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionContent {
                actionContent
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

#Preview("Custom action area", traits: .sizeThatFitsLayout) {
    EmptyStateView(
        systemImage: "shippingbox",
        title: "No Weekly Data",
        subtitle: "Set up your first reporting period to see payouts."
    ) {
        HStack(spacing: Spacing.small.rawValue) {
            PrimaryButton("Import", isFullWidth: false) {}
            PrimaryButton("Create", isFullWidth: false) {}
        }
    }
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

#Preview("Dynamic Type AX-L", traits: .sizeThatFitsLayout) {
    EmptyStateView(
        systemImage: "location.slash",
        title: "No Trips Yet",
        subtitle: "Your recorded trips will appear here once you start driving.",
        actionTitle: "Start Trip"
    ) {}
    .background(ColorToken.background)
    .dynamicTypeSize(.accessibility1)
}
