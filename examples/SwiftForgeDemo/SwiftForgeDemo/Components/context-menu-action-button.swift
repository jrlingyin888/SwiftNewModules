import SwiftUI

/// A single action shown inside the context menu. Use `isDestructive` to get
/// the system red destructive treatment for delete-style operations.
struct ContextMenuAction: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    var isDestructive: Bool = false
    let handler: () -> Void
}

/// A labeled control that presents a native long-press context menu. Regular
/// actions render in one group and destructive actions in a separate trailing
/// group, matching the system grouping convention.
///
/// The generic parameter is named `LabelContent` (not `Label`) so it does not
/// shadow SwiftUI's own `Label` view used inside the menu items.
struct ContextMenuActionButton<LabelContent: View>: View {
    let actions: [ContextMenuAction]
    @ViewBuilder let label: () -> LabelContent

    private var primaryActions: [ContextMenuAction] { actions.filter { !$0.isDestructive } }
    private var destructiveActions: [ContextMenuAction] { actions.filter(\.isDestructive) }

    var body: some View {
        label()
            .contentShape(.rect)
            .contextMenu {
                ForEach(primaryActions) { action in
                    Button(action: action.handler) {
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
                if !destructiveActions.isEmpty {
                    Section {
                        ForEach(destructiveActions) { action in
                            Button(role: .destructive, action: action.handler) {
                                Label(action.title, systemImage: action.systemImage)
                            }
                        }
                    }
                }
            }
            .accessibilityHint(Text("Double tap and hold for actions"))
    }
}

#Preview {
    @Previewable @State var status = "Long-press the card"
    return VStack(spacing: 24) {
        Text(status)
            .font(.footnote)
            .foregroundStyle(.secondary)

        ContextMenuActionButton(actions: [
            ContextMenuAction(title: "Share", systemImage: "square.and.arrow.up") { status = "Shared" },
            ContextMenuAction(title: "Duplicate", systemImage: "plus.square.on.square") { status = "Duplicated" },
            ContextMenuAction(title: "Pin", systemImage: "pin") { status = "Pinned" },
            ContextMenuAction(title: "Delete", systemImage: "trash", isDestructive: true) { status = "Deleted" }
        ]) {
            HStack(spacing: 14) {
                Image(systemName: "doc.text.fill")
                    .font(.title2)
                    .foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Project Brief").font(.headline)
                    Text("Updated 2h ago").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "ellipsis").foregroundStyle(.secondary)
            }
            .padding()
            .background(.quaternary.opacity(0.6), in: .rect(cornerRadius: 14))
        }
        .padding()
    }
    .padding()
}
