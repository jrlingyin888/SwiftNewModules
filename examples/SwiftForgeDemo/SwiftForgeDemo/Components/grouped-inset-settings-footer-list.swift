import SwiftUI

struct GroupedFooterSettingsSection: Identifiable {
    let id: UUID = UUID()
    var title: String
    var footer: String
    var rows: [GroupedFooterSettingsRow]
}

struct GroupedFooterSettingsRow: Identifiable {
    enum Accessory {
        case toggle(Binding<Bool>)
        case value(String)
        case disclosure
    }
    let id: UUID = UUID()
    var icon: String
    var iconTint: Color
    var title: String
    var accessory: Accessory
}

struct GroupedFooterSettingsListView: View {
    let sections: [GroupedFooterSettingsSection]

    var body: some View {
        List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.rows) { row in
                        GroupedFooterSettingsRowView(row: row)
                    }
                } header: {
                    Text(section.title)
                } footer: {
                    Text(section.footer)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct GroupedFooterSettingsRowView: View {
    let row: GroupedFooterSettingsRow

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: row.icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 29, height: 29)
                .background(row.iconTint, in: .rect(cornerRadius: 7))
                .accessibilityHidden(true)
            switch row.accessory {
            case .toggle(let binding):
                Toggle(row.title, isOn: binding)
            case .value(let value):
                Text(row.title)
                Spacer(minLength: 8)
                Text(value)
                    .foregroundStyle(.secondary)
            case .disclosure:
                Text(row.title)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct GroupedFooterSettingsPreviewHost: View {
    @State private var wifi = true
    @State private var airplane = false
    @State private var haptics = true

    var body: some View {
        NavigationStack {
            GroupedFooterSettingsListView(sections: [
                GroupedFooterSettingsSection(
                    title: "Connectivity",
                    footer: "Airplane Mode disables wireless features. Wi-Fi can stay on separately.",
                    rows: [
                        GroupedFooterSettingsRow(icon: "airplane", iconTint: .orange, title: "Airplane Mode", accessory: .toggle($airplane)),
                        GroupedFooterSettingsRow(icon: "wifi", iconTint: .blue, title: "Wi-Fi", accessory: .toggle($wifi)),
                        GroupedFooterSettingsRow(icon: "antenna.radiowaves.left.and.right", iconTint: .green, title: "Cellular", accessory: .value("Roaming"))
                    ]
                ),
                GroupedFooterSettingsSection(
                    title: "Feedback",
                    footer: "Play subtle vibrations for taps and alerts across the system.",
                    rows: [
                        GroupedFooterSettingsRow(icon: "hand.tap.fill", iconTint: .pink, title: "System Haptics", accessory: .toggle($haptics)),
                        GroupedFooterSettingsRow(icon: "speaker.wave.2.fill", iconTint: .purple, title: "Sounds", accessory: .disclosure)
                    ]
                )
            ])
            .navigationTitle("Settings")
        }
    }
}

#Preview("Grouped Footer Settings") {
    GroupedFooterSettingsPreviewHost()
}
