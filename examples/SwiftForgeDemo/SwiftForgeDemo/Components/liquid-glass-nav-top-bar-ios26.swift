import SwiftUI

/// A trailing action for the glass top bar.
struct GlassTopBarAction: Identifiable {
    let id = UUID()
    let systemImage: String
    let label: String
    let action: () -> Void
}

/// An iOS 26 Liquid Glass floating top navigation bar: a back chip, a title pill,
/// and trailing icon chips, all blending inside a single GlassEffectContainer.
@available(iOS 26, *)
struct LiquidGlassNavTopBar: View {
    let title: String
    var subtitle: String? = nil
    var onBack: (() -> Void)? = nil
    var actions: [GlassTopBarAction] = []

    var body: some View {
        GlassEffectContainer(spacing: 14) {
            HStack(spacing: 14) {
                if let onBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.backward")
                            .font(.body.weight(.semibold))
                            .frame(width: 44, height: 44)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .accessibilityLabel("Back")
                }

                VStack(spacing: 1) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(1)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .glassEffect(.regular, in: .capsule)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)

                ForEach(actions) { action in
                    Button(action: action.action) {
                        Image(systemName: action.systemImage)
                            .font(.body.weight(.semibold))
                            .frame(width: 44, height: 44)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .accessibilityLabel(action.label)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

/// Fallback top bar for iOS 17-25 using ultraThinMaterial capsules.
struct GlassNavTopBarFallback: View {
    let title: String
    var subtitle: String? = nil
    var onBack: (() -> Void)? = nil
    var actions: [GlassTopBarAction] = []

    var body: some View {
        HStack(spacing: 14) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.backward")
                        .font(.body.weight(.semibold))
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .background(.ultraThinMaterial, in: Circle())
                .tint(.primary)
                .accessibilityLabel("Back")
            }
            VStack(spacing: 1) {
                Text(title).font(.headline).lineLimit(1)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 18)
            .padding(.vertical, 9)
            .background(.ultraThinMaterial, in: Capsule())
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
            ForEach(actions) { action in
                Button(action: action.action) {
                    Image(systemName: action.systemImage)
                        .font(.body.weight(.semibold))
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .background(.ultraThinMaterial, in: Circle())
                .tint(.primary)
                .accessibilityLabel(action.label)
            }
        }
        .padding(.horizontal, 16)
    }
}

@available(iOS 26, *)
#Preview {
    ZStack(alignment: .top) {
        ScrollView {
            LinearGradient(colors: [.orange, .pink, .purple], startPoint: .top, endPoint: .bottom)
                .frame(height: 900)
        }
        .ignoresSafeArea()

        LiquidGlassNavTopBar(
            title: "Discover",
            subtitle: "Trending today",
            onBack: {},
            actions: [
                GlassTopBarAction(systemImage: "magnifyingglass", label: "Search", action: {}),
                GlassTopBarAction(systemImage: "ellipsis", label: "More", action: {})
            ]
        )
        .padding(.top, 8)
    }
}
