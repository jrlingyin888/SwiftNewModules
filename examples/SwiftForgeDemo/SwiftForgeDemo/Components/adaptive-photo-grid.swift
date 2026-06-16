import SwiftUI

/// A single item rendered inside `AdaptivePhotoGrid`.
struct AdaptivePhotoItem: Identifiable, Hashable {
    let id: UUID
    let hue: Double
    var symbol: String

    init(id: UUID = UUID(), hue: Double, symbol: String) {
        self.id = id
        self.hue = hue
        self.symbol = symbol
    }
}

/// A responsive photo grid using `LazyVGrid` with adaptive columns.
/// Tiles are square, aspect-filled, and support single-tap selection.
struct AdaptivePhotoGrid: View {
    let items: [AdaptivePhotoItem]
    var minimumTileWidth: CGFloat = 104
    var spacing: CGFloat = 8

    @State private var selection: Set<AdaptivePhotoItem.ID> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: minimumTileWidth), spacing: spacing)]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(items) { item in
                    AdaptivePhotoTile(
                        item: item,
                        isSelected: selection.contains(item.id)
                    )
                    .onTapGesture {
                        withAnimation(reduceMotion ? nil : .snappy(duration: 0.22)) {
                            toggle(item.id)
                        }
                    }
                }
            }
            .padding(spacing)
        }
        .background(Color(.systemGroupedBackground))
    }

    private func toggle(_ id: AdaptivePhotoItem.ID) {
        if selection.contains(id) {
            selection.remove(id)
        } else {
            selection.insert(id)
        }
    }
}

private struct AdaptivePhotoTile: View {
    let item: AdaptivePhotoItem
    let isSelected: Bool

    var body: some View {
        LinearGradient(
            colors: [
                Color(hue: item.hue, saturation: 0.55, brightness: 0.92),
                Color(hue: item.hue, saturation: 0.7, brightness: 0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .aspectRatio(1, contentMode: .fill)
        .overlay {
            Image(systemName: item.symbol)
                .font(.title2)
                .foregroundStyle(.white.opacity(0.85))
        }
        .clipShape(.rect(cornerRadius: 14))
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.tint, lineWidth: 3)
            }
        }
        .overlay(alignment: .topTrailing) {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white, .tint)
                    .padding(6)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .scaleEffect(isSelected ? 0.94 : 1)
        .accessibilityElement()
        .accessibilityLabel("Photo")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(.isButton)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    let symbols = ["photo", "camera", "mountain.2", "leaf", "sun.max", "moon.stars", "flame", "drop"]
    let items = (0..<24).map { index in
        AdaptivePhotoItem(
            hue: Double(index) / 24.0,
            symbol: symbols[index % symbols.count]
        )
    }
    return AdaptivePhotoGrid(items: items)
        .tint(.indigo)
}
