import SwiftUI

struct FeaturedPricingTierCard: View {
    let planName: String
    let price: String
    let period: String
    let tagline: String
    let features: [String]
    var isFeatured: Bool = false
    var ctaTitle: String = "Choose plan"
    var accent: Color = .accentColor
    var onSelect: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            Divider().opacity(0.4)
            featureList
            cta
        }
        .padding(22)
        .background(.background, in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    isFeatured ? AnyShapeStyle(accent.opacity(0.85)) : AnyShapeStyle(.separator),
                    lineWidth: isFeatured ? 2 : 1
                )
        }
        .overlay(alignment: .top) {
            if isFeatured {
                badge
            }
        }
        .shadow(color: .black.opacity(isFeatured ? 0.16 : 0.06), radius: isFeatured ? 18 : 8, y: 6)
        .scaleEffect(isFeatured ? 1.0 : 0.97)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(planName)
                .font(.title3.weight(.bold))
                .foregroundStyle(isFeatured ? AnyShapeStyle(accent) : AnyShapeStyle(.primary))
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(price)
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)
                Text("/ \(period)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(tagline)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(features, id: \.self) { feature in
                Label {
                    Text(feature)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(accent)
                        .font(.subheadline)
                }
                .labelStyle(.titleAndIcon)
            }
        }
    }

    private var cta: some View {
        Button(action: onSelect) {
            Text(ctaTitle)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(isFeatured ? accent : .gray)
        .buttonBorderShape(.roundedRectangle(radius: 14))
    }

    private var badge: some View {
        Text("MOST POPULAR")
            .font(.caption2.weight(.bold))
            .tracking(0.6)
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(accent, in: Capsule())
            .offset(y: -12)
    }

    private var accessibilityText: String {
        let popular = isFeatured ? "Most popular. " : ""
        return "\(planName) plan, \(price) per \(period). \(popular)\(features.count) features included."
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 28) {
            FeaturedPricingTierCard(
                planName: "Starter",
                price: "$9",
                period: "mo",
                tagline: "Everything to get going.",
                features: ["3 projects", "Community support", "1 GB storage"]
            )
            FeaturedPricingTierCard(
                planName: "Pro",
                price: "$29",
                period: "mo",
                tagline: "For growing teams that ship.",
                features: ["Unlimited projects", "Priority support", "100 GB storage", "Advanced analytics"],
                isFeatured: true,
                ctaTitle: "Start free trial",
                accent: .indigo
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
