import SwiftUI
import DesignSystem

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xLarge.rawValue) {
                    ReportingPeriodCard(
                        title: "Reporting Period",
                        dateRange: "Jul 29 – Aug 4, 2026",
                        subtitle: "Weekly summary · Paid every Friday"
                    )

                    TodaySummaryCard(trips: 3, distanceMiles: 42.3)

                    VStack(spacing: Spacing.medium.rawValue) {
                        sectionHeader("Recent Trips")

                        EmptyStateView(
                            systemImage: "car.fill",
                            title: "No Trips Yet",
                            subtitle: "Your recorded trips will appear here once you start driving.",
                            actionTitle: "Start Trip"
                        ) {}
                        .frame(minHeight: 240)
                    }
                }
                .padding(.horizontal, Spacing.medium.rawValue)
                .padding(.vertical, Spacing.large.rawValue)
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
            .background(ColorToken.background)
            .navigationTitle("Driver Tracker")
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .textStyle(.headline)
            .foregroundStyle(ColorToken.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    HomeView()
}

#Preview("Dynamic Type AX-L") {
    HomeView()
        .dynamicTypeSize(.accessibility1)
}

#Preview("Dark") {
    HomeView()
        .preferredColorScheme(.dark)
}
