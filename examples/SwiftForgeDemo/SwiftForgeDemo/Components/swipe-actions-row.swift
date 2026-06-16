import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    var sender: String
    var preview: String
    var isPinned: Bool = false
    var isUnread: Bool = true
}

struct SwipeActionsRowList: View {
    @State private var messages: [Message] = [
        Message(sender: "Ava Chen", preview: "Sounds good \u{2014} see you at 3."),
        Message(sender: "Build Bot", preview: "Pipeline #482 passed.", isUnread: false),
        Message(sender: "Mom", preview: "Call me when you can \u{2764}\u{FE0F}", isPinned: true),
        Message(sender: "Newsletter", preview: "5 things to read this week.", isUnread: false)
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach($messages) { $message in
                    MessageRow(message: message)
                        // Leading swipe: lightweight toggle, no full-swipe.
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                message.isUnread.toggle()
                            } label: {
                                Label(
                                    message.isUnread ? "Read" : "Unread",
                                    systemImage: message.isUnread ? "envelope.open" : "envelope.badge"
                                )
                            }
                            .tint(.blue)
                        }
                        // Trailing swipe: destructive delete is the full-swipe default.
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(message)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                message.isPinned.toggle()
                            } label: {
                                Label(message.isPinned ? "Unpin" : "Pin",
                                      systemImage: message.isPinned ? "pin.slash" : "pin")
                            }
                            .tint(.orange)
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Inbox")
            .animation(.snappy, value: messages.map(\.id))
        }
    }

    private func delete(_ message: Message) {
        messages.removeAll { $0.id == message.id }
    }
}

private struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(message.isUnread ? Color.accentColor : .clear)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    if message.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                            .accessibilityHidden(true)
                    }
                    Text(message.sender)
                        .font(.headline)
                        .fontWeight(message.isUnread ? .semibold : .regular)
                }
                Text(message.preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(message.isUnread ? "Unread, " : "")\(message.sender), \(message.preview)")
    }
}

#Preview {
    SwipeActionsRowList()
}
