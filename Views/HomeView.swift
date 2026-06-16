import CoreLocation
import MapKit
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    private var activeCourses: [HabitCourse] {
        appState.courses.filter(\.isEnabled)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                mapCard
                courseCard
                permissionCard
            }
            .padding()
        }
        .navigationTitle("Spotus")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.requestCurrentLocation()
                } label: {
                    Label("現在地", systemImage: "location")
                }
            }
        }
    }

    private var permissionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("権限")
                .font(.headline)

            StatusRow(
                title: "位置情報",
                value: appState.locationService.authorizationStatus.habitRouteDisplayName,
                systemImage: "location.fill",
                isHealthy: appState.locationService.authorizationStatus == .authorizedAlways
            )

            StatusRow(
                title: "通知",
                value: appState.notificationService.authorizationStatus.habitRouteDisplayName,
                systemImage: "bell.fill",
                isHealthy: appState.notificationService.authorizationStatus == .authorized
            )

            HStack {
                Button {
                    appState.requestLocationPermission()
                } label: {
                    Label("位置情報を許可", systemImage: "location.circle")
                }
                .buttonStyle(.bordered)

                Button {
                    appState.requestNotificationPermission()
                } label: {
                    Label("通知を許可", systemImage: "bell.circle")
                }
                .buttonStyle(.bordered)
            }

            if appState.locationService.authorizationStatus != .authorizedAlways {
                Label("バックグラウンド通知には「常に許可」が必要です。", systemImage: "exclamationmark.triangle")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }
        }
        .cardStyle()
    }

    private var courseCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("有効なコース")
                    .font(.headline)
                Spacer()
                Text("\(activeCourses.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if activeCourses.isEmpty {
                Text("Course画面で生活改善コースをONにできます。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(activeCourses.prefix(4)) { course in
                    Label(course.name, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.primary)
                }
            }
        }
        .cardStyle()
    }

    private var mapCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("登録地点")
                    .font(.headline)
                Spacer()
                Text("\(appState.locationService.monitoredRegionCount)/20 監視中")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if appState.places.isEmpty {
                Text("Place画面で自宅、駅、職場などを登録できます。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                PlacesOverviewMap(places: appState.places.filter(\.isEnabled))
                    .frame(height: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                ForEach(appState.places.prefix(5)) { place in
                    HStack {
                        Label(place.name, systemImage: place.category.systemImage)
                        Spacer()
                        Button {
                            appState.showMap(for: place.id)
                        } label: {
                            Image(systemName: "map")
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("\(place.name)を地図で見る")

                        Text(place.isEnabled ? "ON" : "OFF")
                            .font(.caption)
                            .foregroundStyle(place.isEnabled ? .green : .secondary)
                    }
                }
            }
        }
        .cardStyle()
    }
}

struct PlacesOverviewMap: View {
    let places: [Place]
    @State private var position: MapCameraPosition

    init(places: [Place]) {
        self.places = places
        _position = State(initialValue: PlacesOverviewMap.initialPosition(for: places))
    }

    var body: some View {
        Map(position: $position) {
            UserAnnotation()

            ForEach(places) { place in
                MapCircle(center: place.coordinate, radius: place.radius)
                    .foregroundStyle(Color.accentColor.opacity(0.12))
                    .stroke(Color.accentColor.opacity(0.7), lineWidth: 1)

                Marker(place.name, systemImage: place.category.systemImage, coordinate: place.coordinate)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
    }

    private static func initialPosition(for places: [Place]) -> MapCameraPosition {
        guard let firstPlace = places.first else {
            return .automatic
        }

        let coordinates = places.map(\.coordinate)
        let minLatitude = coordinates.map(\.latitude).min() ?? firstPlace.latitude
        let maxLatitude = coordinates.map(\.latitude).max() ?? firstPlace.latitude
        let minLongitude = coordinates.map(\.longitude).min() ?? firstPlace.longitude
        let maxLongitude = coordinates.map(\.longitude).max() ?? firstPlace.longitude
        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
        let northSouthMeters = max(CLLocation(latitude: minLatitude, longitude: center.longitude).distance(
            from: CLLocation(latitude: maxLatitude, longitude: center.longitude)
        ), 700)
        let eastWestMeters = max(CLLocation(latitude: center.latitude, longitude: minLongitude).distance(
            from: CLLocation(latitude: center.latitude, longitude: maxLongitude)
        ), 700)

        return .region(
            MKCoordinateRegion(
                center: center,
                latitudinalMeters: northSouthMeters * 1.6,
                longitudinalMeters: eastWestMeters * 1.6
            )
        )
    }
}

struct PlaceMapDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    let place: Place
    @State private var position: MapCameraPosition

    init(place: Place) {
        self.place = place
        let spanMeters = max(place.radius * 5, 700)
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: place.coordinate,
                latitudinalMeters: spanMeters,
                longitudinalMeters: spanMeters
            )
        ))
    }

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                UserAnnotation()

                Marker(place.name, systemImage: place.category.systemImage, coordinate: place.coordinate)

                MapCircle(center: place.coordinate, radius: place.radius)
                    .foregroundStyle(Color.accentColor.opacity(0.16))
                    .stroke(Color.accentColor, lineWidth: 2)
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(place.name)
                        .font(.headline)
                    Text("\(place.category.displayName) / 半径 \(Int(place.radius))m")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.regularMaterial)
            }
            .navigationTitle("地図")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        appState.requestCurrentLocation()
                    } label: {
                        Label("現在地", systemImage: "location")
                    }
                }
            }
        }
    }
}

private struct StatusRow: View {
    let title: String
    let value: String
    let systemImage: String
    let isHealthy: Bool

    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isHealthy ? .green : .orange)
        }
    }
}

private extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}
