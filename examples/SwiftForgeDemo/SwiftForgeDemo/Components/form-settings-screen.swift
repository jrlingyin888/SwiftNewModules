import SwiftUI
import Observation

@Observable
final class SettingsModel {
    var notificationsEnabled = true
    var hapticsEnabled = true
    var appearance: Appearance = .system
    var downloadQuality: Quality = .high
    var maxDownloads = 3
    var name = "Jordan Rivera"
    var email = "jordan@example.com"

    enum Appearance: String, CaseIterable, Identifiable {
        case system, light, dark
        var id: Self { self }
        var label: String { rawValue.capitalized }
    }
    enum Quality: String, CaseIterable, Identifiable {
        case standard, high, lossless
        var id: Self { self }
        var label: String { rawValue.capitalized }
    }
}

struct SettingsScreen: View {
    @State private var model = SettingsModel()
    @State private var showSignOut = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        Text("Edit Profile")
                            .navigationTitle("Profile")
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 52))
                                .foregroundStyle(.white, Color.accentColor.gradient)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(model.name)
                                    .font(.headline)
                                Text(model.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Preferences") {
                    Toggle(isOn: $model.notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.badge")
                    }
                    Toggle(isOn: $model.hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap")
                    }
                    Picker(selection: $model.appearance) {
                        ForEach(SettingsModel.Appearance.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    } label: {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                    }
                }

                Section("Downloads") {
                    Picker(selection: $model.downloadQuality) {
                        ForEach(SettingsModel.Quality.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    } label: {
                        Label("Quality", systemImage: "waveform")
                    }
                    .pickerStyle(.menu)
                    Stepper(value: $model.maxDownloads, in: 1...10) {
                        Label("Max Concurrent: \(model.maxDownloads)", systemImage: "arrow.down.circle")
                    }
                }

                Section {
                    NavigationLink {
                        Text("About")
                            .navigationTitle("About")
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                    Button(role: .destructive) {
                        showSignOut = true
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Sign out of your account?",
                isPresented: $showSignOut,
                titleVisibility: .visible
            ) {
                Button("Sign Out", role: .destructive) { }
                Button("Cancel", role: .cancel) { }
            }
        }
        .tint(.accentColor)
    }
}

#Preview {
    SettingsScreen()
}
