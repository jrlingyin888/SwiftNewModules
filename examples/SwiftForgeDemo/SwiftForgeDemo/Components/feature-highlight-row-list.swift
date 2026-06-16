import SwiftUI

struct FeatureHighlight: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let description: String
    var tint: Color = .accentColor
}

struct FeatureHighlightList: View {
    let headline: String
    let features: [FeatureHighlight]

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text(headline)
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 24) {
                ForEach(features) { feature in
                    FeatureRow(feature: feature)
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FeatureRow: View {
    let feature: FeatureHighlight

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: feature.symbol)
                .font(.title2.weight(.semibold))
                .foregroundStyle(feature.tint)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 44, height: 44)
                .background(
                    feature.tint.opacity(0.15),
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ScrollView {
        FeatureHighlightList(
            headline: "What's New in Aurora",
            features: [
                FeatureHighlight(symbol: "wand.and.stars", title: "Smart Suggestions", description: "AI-powered recommendations tailored to how you work.", tint: .purple),
                FeatureHighlight(symbol: "icloud.fill", title: "Seamless Sync", description: "Your library stays up to date across every device.", tint: .blue),
                FeatureHighlight(symbol: "chart.bar.fill", title: "Rich Insights", description: "Beautiful charts that turn raw data into clarity.", tint: .green),
                FeatureHighlight(symbol: "hand.raised.fill", title: "Private by Default", description: "On-device processing keeps your information yours.", tint: .orange)
            ]
        )
    }
}
