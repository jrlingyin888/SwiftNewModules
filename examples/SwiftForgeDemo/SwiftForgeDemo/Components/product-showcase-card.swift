import SwiftUI

struct ProductShowcaseCard: View {
    let title: String
    let price: String
    var compareAtPrice: String? = nil
    var imageURL: URL? = nil
    var rating: Double? = nil
    var badge: String? = nil
    var accent: Color = .accentColor
    var onAddToCart: () -> Void = {}

    @State private var isFavorite = false
    @State private var didAdd = false
    @State private var resetTask: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            thumbnail
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)

                if let rating {
                    let clamped = min(max(rating, 0), 5)
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", clamped))
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Rated \(String(format: "%.1f", clamped)) out of 5")
                }

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    VStack(alignment: .leading, spacing: 0) {
                        if let compareAtPrice {
                            Text(compareAtPrice)
                                .font(.caption)
                                .strikethrough()
                                .foregroundStyle(.secondary)
                        }
                        Text(price)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    Spacer(minLength: 8)
                    addButton
                }
            }
            .padding(12)
        }
        .background(.background, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Color(.separator), lineWidth: 1))
        .clipShape(.rect(cornerRadius: 18))
        .shadow(color: .black.opacity(0.07), radius: 10, y: 5)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title), \(price)")
    }

    private var thumbnail: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .empty:
                ZStack { Color(.secondarySystemBackground); ProgressView() }
            default:
                ZStack {
                    Color(.secondarySystemBackground)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .clipped()
        .overlay(alignment: .topLeading) {
            if let badge {
                Text(badge)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accent, in: .capsule)
                    .padding(10)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.snappy) { isFavorite.toggle() }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isFavorite ? .red : .secondary)
                    .padding(8)
                    .background(.regularMaterial, in: .circle)
            }
            .buttonStyle(.plain)
            .padding(10)
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        }
    }

    private var addButton: some View {
        Button {
            onAddToCart()
            withAnimation(.snappy) { didAdd = true }
            resetTask?.cancel()
            resetTask = Task {
                try? await Task.sleep(for: .seconds(1.1))
                guard !Task.isCancelled else { return }
                withAnimation(.snappy) { didAdd = false }
            }
        } label: {
            Image(systemName: didAdd ? "checkmark" : "plus")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(didAdd ? Color.green : accent, in: .circle)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(didAdd ? "Added to cart" : "Add \(title) to cart")
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ProductShowcaseCard(
                title: "Aurora Wireless Headphones",
                price: "$149",
                compareAtPrice: "$199",
                rating: 4.8,
                badge: "-25%",
                accent: .indigo
            )
            ProductShowcaseCard(
                title: "Linen Crew Tee",
                price: "$38",
                rating: 4.5,
                accent: .teal
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
