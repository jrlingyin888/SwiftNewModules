import SwiftUI

/// One selectable filter option.
struct FilterChipItem: Identifiable, Hashable {
    let id: String
    var title: String
    var systemImage: String?

    init(_ id: String, title: String, systemImage: String? = nil) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }
}

/// A horizontally scrolling, multi-selectable chip filter row.
struct HorizontalChipFilterRow: View {
    let items: [FilterChipItem]
    @Binding var selection: Set<String>
    var tint: Color = .accentColor

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items) { item in
                    chip(for: item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private func chip(for item: FilterChipItem) -> some View {
        let isOn = selection.contains(item.id)

        Button {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
            if isOn {
                selection.remove(item.id)
            } else {
                selection.insert(item.id)
            }
        } label: {
            HStack(spacing: 6) {
                if let symbol = item.systemImage {
                    Image(systemName: symbol)
                        .font(.subheadline)
                }
                Text(item.title)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .foregroundStyle(isOn ? AnyShapeStyle(.white) : AnyShapeStyle(.primary))
            .background {
                Capsule()
                    .fill(isOn ? AnyShapeStyle(tint) : AnyShapeStyle(.thinMaterial))
            }
            .overlay {
                Capsule()
                    .strokeBorder(
                        isOn ? AnyShapeStyle(.clear) : AnyShapeStyle(.secondary.opacity(0.3)),
                        lineWidth: 1
                    )
            }
            .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .animation(.snappy(duration: 0.2), value: isOn)
        .accessibilityLabel(Text(item.title))
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

#Preview {
    struct Demo: View {
        @State private var selection: Set<String> = ["swift"]
        private let items = [
            FilterChipItem("all", title: "All", systemImage: "square.grid.2x2"),
            FilterChipItem("swift", title: "Swift", systemImage: "swift"),
            FilterChipItem("design", title: "Design", systemImage: "paintbrush"),
            FilterChipItem("ai", title: "AI", systemImage: "sparkles"),
            FilterChipItem("news", title: "News"),
            FilterChipItem("jobs", title: "Jobs", systemImage: "briefcase")
        ]

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Topics")
                    .font(.title2.bold())
                    .padding(.horizontal, 16)
                HorizontalChipFilterRow(items: items, selection: $selection)
                Text("Selected: \(selection.sorted().joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
            }
            .padding(.vertical)
        }
    }
    return Demo()
}
