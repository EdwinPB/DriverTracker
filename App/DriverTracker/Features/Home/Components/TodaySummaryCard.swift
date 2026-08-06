import SwiftUI
import DesignSystem

/// Card summarizing today's activity: trip count and distance traveled.
///
/// Two balanced stats separated by a token-colored hairline, composed from
/// `AppCard` and design tokens only. Numeric values use the `.value` text
/// style (tabular digits). Distance is formatted to one decimal with `mi`.
/// Each stat reads as a single VoiceOver element ("3 Trips").
///
/// Business-logic specific to the Home feature; lives in the app target.
///
/// Spec: Docs/design-language.md §5, §6.
struct TodaySummaryCard: View {

    private let title: String
    private let trips: Int
    private let distanceMiles: Double

    init(
        title: String = "Today",
        trips: Int,
        distanceMiles: Double
    ) {
        self.title = title
        self.trips = trips
        self.distanceMiles = distanceMiles
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
                Text(title)
                    .textStyle(.label)
                    .foregroundStyle(ColorToken.textSecondary)

                HStack(spacing: Spacing.medium.rawValue) {
                    stat(value: "\(trips)", label: trips == 1 ? "Trip" : "Trips")

                    Rectangle()
                        .fill(ColorToken.separator)
                        .frame(width: 1, height: 32)

                    stat(
                        value: "\(distanceMiles.formatted(.number.precision(.fractionLength(1)))) mi",
                        label: "Distance"
                    )
                }
            }
        }
    }

    private func stat(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.micro.rawValue) {
            Text(value)
                .textStyle(.value)
            Text(label)
                .textStyle(.caption)
                .foregroundStyle(ColorToken.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(value) \(label)")
    }
}

#Preview("Activity") {
    TodaySummaryCard(trips: 3, distanceMiles: 42.3)
        .padding(Spacing.large.rawValue)
        .background(ColorToken.background)
}

#Preview("Zero state", traits: .sizeThatFitsLayout) {
    TodaySummaryCard(trips: 0, distanceMiles: 0)
        .padding(Spacing.large.rawValue)
        .background(ColorToken.background)
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    TodaySummaryCard(trips: 8, distanceMiles: 96.7)
        .padding(Spacing.large.rawValue)
        .background(ColorToken.background)
        .preferredColorScheme(.dark)
}
