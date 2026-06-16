import SwiftUI

/// A social-proof testimonial card: a large decorative quotation glyph, the
/// quote body, an optional star rating, and an author row with a monogram or
/// AsyncImage avatar, name, and role.
struct SpotlightTestimonialCard: View {
    let quote: String
    let authorName: String
    let authorRole: String
    /// 0...5; pass nil to hide the star row.
    let rating: Int?
    /// Optional remote avatar; falls back to a tinted monogram.
    let avatarURL: URL?
    let accent: Color

    private var initials: String {
        let parts = authorName.split(separator: " ").prefix(2)
        let letters = parts.compactMap { $0.first }.map(String.init)
        return letters.joined().uppercased()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "quote.opening")
                .font(.system(size: 34, weight: .black))
                .foregroundStyle(accent.opacity(0.35))
                .accessibilityHidden(true)

            Text(quote)
                .font(.callout)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if let rating {
                starRow(rating)
            }

            Divider()

            authorRow
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: .rect(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Testimonial from \(authorName), \(authorRole)")
        .accessibilityValue(ratingPhrase + quote)
    }

    private func starRow(_ rating: Int) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: i < rating ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(i < rating ? AnyShapeStyle(.yellow) : AnyShapeStyle(.tertiary))
            }
        }
        .accessibilityHidden(true)
    }

    private var authorRow: some View {
        HStack(spacing: 12) {
            avatar
            VStack(alignment: .leading, spacing: 2) {
                Text(authorName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(authorRole)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private var avatar: some View {
        let size: CGFloat = 40
        Group {
            if let avatarURL {
                AsyncImage(url: avatarURL) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        monogram
                    }
                }
            } else {
                monogram
            }
        }
        .frame(width: size, height: size)
        .clipShape(.circle)
        .overlay(Circle().strokeBorder(.separator.opacity(0.4), lineWidth: 0.5))
        .accessibilityHidden(true)
    }

    private var monogram: some View {
        ZStack {
            accent.opacity(0.18)
            Text(initials)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(accent)
        }
    }

    private var ratingPhrase: String {
        guard let rating else { return "" }
        return "\(rating) out of 5 stars. "
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            SpotlightTestimonialCard(
                quote: "This is hands-down the cleanest component library I've shipped with. It saved my team weeks of polish work.",
                authorName: "Maya Chen",
                authorRole: "Lead iOS Engineer, Northwind",
                rating: 5,
                avatarURL: nil,
                accent: .indigo
            )
            SpotlightTestimonialCard(
                quote: "The attention to dark mode and accessibility detail is exactly what we needed. Dropped it straight into production.",
                authorName: "Diego Ramos",
                authorRole: "Founder, Tinybird Apps",
                rating: 4,
                avatarURL: nil,
                accent: .pink
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
