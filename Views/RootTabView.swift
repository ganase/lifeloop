import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                CourseListView()
            }
            .tabItem {
                Label("Course", systemImage: "figure.walk.motion")
            }

            NavigationStack {
                PlaceListView()
            }
            .tabItem {
                Label("Place", systemImage: "mappin.and.ellipse")
            }

            NavigationStack {
                RuleListView()
            }
            .tabItem {
                Label("Rule", systemImage: "list.bullet.rectangle")
            }

            NavigationStack {
                LogListView()
            }
            .tabItem {
                Label("Log", systemImage: "clock.arrow.circlepath")
            }
        }
        .sheet(item: $appState.mapSelection) { selection in
            if let place = appState.place(for: selection.placeId) {
                PlaceMapDetailView(place: place)
                    .environmentObject(appState)
            } else {
                ContentUnavailableView("場所が見つかりません", systemImage: "mappin.slash")
            }
        }
    }
}
