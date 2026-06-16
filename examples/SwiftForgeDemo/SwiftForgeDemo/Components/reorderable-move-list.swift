import SwiftUI

/// A row model for `ReorderableMoveList`.
struct ReorderableTask: Identifiable, Hashable {
    let id: UUID
    var title: String
    var symbol: String

    init(id: UUID = UUID(), title: String, symbol: String) {
        self.id = id
        self.title = title
        self.symbol = symbol
    }
}

/// A reorderable, deletable List driven by `onMove` / `onDelete`.
/// Toggle edit mode with the toolbar EditButton, then drag rows by the handle.
struct ReorderableMoveList: View {
    @State private var tasks: [ReorderableTask]

    init(tasks: [ReorderableTask] = ReorderableMoveList.sample) {
        _tasks = State(initialValue: tasks)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(tasks) { task in
                        ReorderableTaskRow(task: task)
                    }
                    .onMove { source, destination in
                        tasks.move(fromOffsets: source, toOffset: destination)
                    }
                    .onDelete { offsets in
                        tasks.remove(atOffsets: offsets)
                    }
                } footer: {
                    Text("Tap Edit, then drag the handle to reorder. Swipe a row to delete.")
                }
            }
            .navigationTitle("Priorities")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    static let sample: [ReorderableTask] = [
        .init(title: "Draft launch email", symbol: "envelope"),
        .init(title: "Review pull requests", symbol: "checkmark.seal"),
        .init(title: "Update changelog", symbol: "doc.text"),
        .init(title: "Record demo video", symbol: "video"),
        .init(title: "Schedule standup", symbol: "calendar")
    ]
}

private struct ReorderableTaskRow: View {
    let task: ReorderableTask

    var body: some View {
        Label {
            Text(task.title)
                .font(.body)
        } icon: {
            Image(systemName: task.symbol)
                .foregroundStyle(.tint)
        }
        .padding(.vertical, 4)
        .accessibilityLabel(task.title)
    }
}

#Preview {
    ReorderableMoveList()
        .tint(.orange)
}
