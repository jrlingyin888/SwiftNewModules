import SwiftUI

/// An adaptive sidebar/detail layout. On compact widths it collapses to a
/// push navigation stack; on regular widths it shows sidebar + detail.
struct SidebarSplitLayout: View {
    @State private var selection: SidebarItem? = SidebarItem.inbox
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selection) {
                Section("Mail") {
                    ForEach(SidebarItem.mailbox) { item in
                        SidebarRowLabel(item: item)
                    }
                }
                Section("Smart") {
                    ForEach(SidebarItem.smart) { item in
                        SidebarRowLabel(item: item)
                    }
                }
            }
            .navigationTitle("Folders")
            .navigationSplitViewColumnWidth(min: 220, ideal: 260, max: 320)
        } detail: {
            NavigationStack {
                if let selection {
                    SidebarDetailView(item: selection)
                } else {
                    ContentUnavailableView(
                        "No Folder Selected",
                        systemImage: "sidebar.left",
                        description: Text("Pick a folder from the sidebar.")
                    )
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

private struct SidebarRowLabel: View {
    let item: SidebarItem

    var body: some View {
        Label {
            Text(item.title)
        } icon: {
            Image(systemName: item.symbol)
                .foregroundStyle(item.tint)
        }
        .badge(item.count)
        .tag(item)
    }
}

private struct SidebarDetailView: View {
    let item: SidebarItem

    var body: some View {
        List {
            ForEach(0..<item.count, id: \.self) { index in
                NavigationLink(value: index) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(item.title) message \(index + 1)")
                            .font(.headline)
                        Text("Tap to open the full conversation thread.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(item.title)
        .navigationDestination(for: Int.self) { index in
            SidebarMessageDetail(item: item, index: index)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .accessibilityLabel("Compose")
            }
        }
    }
}

private struct SidebarMessageDetail: View {
    let item: SidebarItem
    let index: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(item.title) message \(index + 1)")
                    .font(.title.weight(.bold))
                Text("From: team@example.com")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Divider()
                Text("This is the body of the message. NavigationSplitView keeps the sidebar visible on iPad while pushing this detail inside the detail column's own NavigationStack.")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Message")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct SidebarItem: Identifiable, Hashable {
    let id: String
    let title: String
    let symbol: String
    let count: Int
    let tint: Color

    static func == (lhs: SidebarItem, rhs: SidebarItem) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    static let inbox = SidebarItem(id: "inbox", title: "Inbox", symbol: "tray.fill", count: 8, tint: .blue)
    static let mailbox: [SidebarItem] = [
        inbox,
        .init(id: "sent", title: "Sent", symbol: "paperplane.fill", count: 3, tint: .green),
        .init(id: "drafts", title: "Drafts", symbol: "doc.fill", count: 2, tint: .orange)
    ]
    static let smart: [SidebarItem] = [
        .init(id: "flagged", title: "Flagged", symbol: "flag.fill", count: 4, tint: .red),
        .init(id: "unread", title: "Unread", symbol: "circle.fill", count: 6, tint: .indigo)
    ]
}

#Preview {
    SidebarSplitLayout()
}
