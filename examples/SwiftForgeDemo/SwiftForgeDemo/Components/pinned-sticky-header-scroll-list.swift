import SwiftUI

struct PinnedHeaderGroup<Item: Identifiable>: Identifiable {
    let id: UUID = UUID()
    var title: String
    var items: [Item]
}

struct PinnedStickyHeaderListView<Item: Identifiable, RowContent: View>: View {
    let groups: [PinnedHeaderGroup<Item>]
    @ViewBuilder var row: (Item) -> RowContent

    init(
        groups: [PinnedHeaderGroup<Item>],
        @ViewBuilder row: @escaping (Item) -> RowContent
    ) {
        self.groups = groups
        self.row = row
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(groups) { group in
                    Section {
                        ForEach(Array(group.items.enumerated()), id: \.element.id) { index, item in
                            row(item)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                            if index < group.items.count - 1 {
                                Divider().padding(.leading)
                            }
                        }
                    } header: {
                        PinnedStickyHeaderLabel(title: group.title)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct PinnedStickyHeaderLabel: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.bar)
            .overlay(alignment: .bottom) {
                Divider()
            }
            .accessibilityAddTraits(.isHeader)
    }
}

private struct PinnedHeaderDemoContact: Identifiable {
    let id = UUID()
    let name: String
}

#Preview("Pinned Sticky Headers") {
    let groups = ["A", "B", "C"].map { letter in
        PinnedHeaderGroup(title: letter, items: (1...4).map {
            PinnedHeaderDemoContact(name: "\(letter) Contact \($0)")
        })
    }
    return PinnedStickyHeaderListView(groups: groups) { contact in
        HStack {
            Text(contact.name)
            Spacer()
            Image(systemName: "phone")
                .foregroundStyle(.tint)
        }
    }
    .tint(.green)
}
