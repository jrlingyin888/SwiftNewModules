import SwiftUI

struct ExpandableSectionGroup<Item: Identifiable>: Identifiable {
    let id: UUID = UUID()
    var title: String
    var systemImage: String
    var items: [Item]
}

struct ExpandableSectionListView<Item: Identifiable, RowContent: View>: View {
    let sections: [ExpandableSectionGroup<Item>]
    var initiallyExpanded: Bool
    @ViewBuilder var row: (Item) -> RowContent

    @State private var expanded: Set<UUID> = []

    init(
        sections: [ExpandableSectionGroup<Item>],
        initiallyExpanded: Bool = true,
        @ViewBuilder row: @escaping (Item) -> RowContent
    ) {
        self.sections = sections
        self.initiallyExpanded = initiallyExpanded
        self.row = row
    }

    var body: some View {
        List {
            ForEach(sections) { section in
                Section {
                    if expanded.contains(section.id) {
                        ForEach(section.items) { item in
                            row(item)
                        }
                    }
                } header: {
                    Button {
                        toggle(section.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: section.systemImage)
                                .foregroundStyle(.tint)
                                .frame(width: 22)
                            Text(section.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("\(section.items.count)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.secondary.opacity(0.15), in: .capsule)
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.secondary)
                                .rotationEffect(.degrees(expanded.contains(section.id) ? 90 : 0))
                        }
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .textCase(nil)
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityValue(expanded.contains(section.id) ? "Expanded" : "Collapsed")
                }
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            if initiallyExpanded, expanded.isEmpty {
                expanded = Set(sections.map(\.id))
            }
        }
    }

    private func toggle(_ id: UUID) {
        withAnimation(.snappy(duration: 0.28)) {
            if expanded.contains(id) { expanded.remove(id) } else { expanded.insert(id) }
        }
    }
}

private struct ExpandableSectionDemoItem: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
}

#Preview("Expandable Section List") {
    let groups = [
        ExpandableSectionGroup(title: "Today", systemImage: "sun.max.fill", items: [
            ExpandableSectionDemoItem(name: "Standup", detail: "9:00 AM"),
            ExpandableSectionDemoItem(name: "Design review", detail: "11:30 AM")
        ]),
        ExpandableSectionGroup(title: "Tomorrow", systemImage: "calendar", items: [
            ExpandableSectionDemoItem(name: "1:1 with Sam", detail: "2:00 PM")
        ])
    ]
    return NavigationStack {
        ExpandableSectionListView(sections: groups) { item in
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                Text(item.detail).font(.caption).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Agenda")
    }
    .tint(.indigo)
}
