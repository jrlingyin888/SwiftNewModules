import SwiftUI

/// A flexible trailing accessory for a settings row.
///
/// Note: the type is given a component-specific name (rather than a generic
/// `SettingsRowAccessory`) to avoid collisions with other top-level types in a
/// shared component library.
enum SettingsIconAccessoryRowAccessory {
    case chevron
    case value(String)
    case badge(String)
    case toggle(Binding<Bool>)
    case empty
}

/// A reusable settings row: tinted icon badge, title (+ optional subtitle), and a trailing accessory.
struct SettingsIconAccessoryRow: View {
    let systemImage: String
    let title: String
    var subtitle: String? = nil
    var tint: Color = .accentColor
    var accessory: SettingsIconAccessoryRowAccessory = .chevron
    var action: (() -> Void)? = nil

    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 30

    var body: some View {
        if let action {
            Button(action: action) { content }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isButton)
        } else {
            content
        }
    }

    private var content: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: iconSize, height: iconSize)
                .background(tint.gradient, in: .rect(cornerRadius: 7))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)
            accessoryView
        }
        .padding(.vertical, 4)
        .contentShape(.rect)
    }

    @ViewBuilder private var accessoryView: some View {
        switch accessory {
        case .chevron:
            Image(systemName: "chevron.forward")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        case .value(let text):
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        case .badge(let text):
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.red, in: .capsule)
        case .toggle(let isOn):
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(tint)
        case .empty:
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var notifications = true
    NavigationStack {
        List {
            Section {
                SettingsIconAccessoryRow(systemImage: "person.fill", title: "Account", subtitle: "jane@example.com", tint: .blue, accessory: .chevron) {}
                SettingsIconAccessoryRow(systemImage: "bell.fill", title: "Notifications", tint: .red, accessory: .toggle($notifications))
                SettingsIconAccessoryRow(systemImage: "globe", title: "Language", tint: .green, accessory: .value("English")) {}
                SettingsIconAccessoryRow(systemImage: "tray.full.fill", title: "Inbox", tint: .orange, accessory: .badge("12")) {}
                SettingsIconAccessoryRow(systemImage: "info.circle.fill", title: "About", tint: .gray, accessory: .empty)
            }
        }
        .navigationTitle("Settings")
    }
}
