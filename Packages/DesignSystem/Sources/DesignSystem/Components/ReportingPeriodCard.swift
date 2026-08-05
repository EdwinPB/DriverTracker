import SwiftUI

/// Card summarizing a reporting period (weekly, monthly, custom).
///
/// Displays a section title, the period's date range, and an optional
/// small subtitle. Composed from `AppCard` and design tokens only —
/// padding, fill, and corner radius come from `AppCard`.
/// Callers pass a pre-formatted `dateRange` string so locale-specific
/// formatting stays with the caller.
///
/// Spec: Docs/design-language.md §5, §6.
public struct ReportingPeriodCard: View {

    private let title: String
    private let dateRange: String
    private let subtitle: String?

    public init(
        title: String,
        dateRange: String,
        subtitle: String? = nil
    ) {
        self.title = title
        self.dateRange = dateRange
        self.subtitle = subtitle
    }

    public var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                Text(title)
                    .textStyle(.label)
                    .foregroundStyle(ColorToken.textSecondary)

                Text(dateRange)
                    .textStyle(.title)

                if let subtitle {
                    Text(subtitle)
                        .textStyle(.caption)
                        .foregroundStyle(ColorToken.textSecondary)
                }
            }
        }
    }
}

#Preview("Weekly + monthly") {
    VStack(spacing: Spacing.large.rawValue) {
        ReportingPeriodCard(
            title: "Reporting Period",
            dateRange: "Jul 29 – Aug 4, 2026",
            subtitle: "Weekly earnings · Paid every Friday"
        )
        ReportingPeriodCard(
            title: "Reporting Period",
            dateRange: "Jul 1 – Jul 31, 2026",
            subtitle: "Monthly summary · Next payout Aug 15"
        )
    }
    .padding(Spacing.large.rawValue)
    .background(ColorToken.background)
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    VStack(spacing: Spacing.large.rawValue) {
        ReportingPeriodCard(
            title: "Reporting Period",
            dateRange: "Jul 29 – Aug 4, 2026",
            subtitle: "Weekly earnings · Paid every Friday"
        )
        ReportingPeriodCard(
            title: "Reporting Period",
            dateRange: "Jul 1 – Jul 31, 2026"
        )
    }
    .padding(Spacing.large.rawValue)
    .background(ColorToken.background)
    .preferredColorScheme(.dark)
}
