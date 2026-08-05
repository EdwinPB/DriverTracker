import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Current trip status
                    Divider()
                    Color.clear.frame(height: 160)
                    Divider()

                    // Earnings / stats
                    Color.clear.frame(height: 24)
                    Divider()
                    Color.clear.frame(height: 120)
                    Divider()

                    // Recent trips
                    Color.clear.frame(height: 24)
                    Divider()
                    Color.clear.frame(height: 200)
                    Divider()

                    Color.clear.frame(height: 24)
                }
            }
            .navigationTitle("Driver Tracker")
        }
    }
}

#Preview {
    HomeView()
}
