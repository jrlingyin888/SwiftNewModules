import SwiftUI

@available(iOS 26, *)
struct LiquidGlassSearchPill: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var tint: Color = .accentColor
    var onSubmit: () -> Void = {}

    @FocusState private var isFocused: Bool
    @Namespace private var glassNamespace

    var body: some View {
        GlassEffectContainer(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isFocused ? AnyShapeStyle(tint) : AnyShapeStyle(.secondary))

                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .onSubmit(onSubmit)

                if !text.isEmpty {
                    Button {
                        withAnimation(.smooth(duration: 0.25)) { text = "" }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .glassEffect(.regular.interactive(), in: .circle)
                            .glassEffectID("clear", in: glassNamespace)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(
                .regular.tint(isFocused ? tint.opacity(0.18) : .clear).interactive(),
                in: .capsule
            )
            .glassEffectID("field", in: glassNamespace)
        }
        .animation(.smooth(duration: 0.25), value: isFocused)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(placeholder)
    }
}

// MARK: - Fallback (iOS 17–25)

struct LiquidGlassSearchPillFallback: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var tint: Color = .accentColor
    var onSubmit: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isFocused ? AnyShapeStyle(tint) : AnyShapeStyle(.secondary))

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.body)
                .focused($isFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .onSubmit(onSubmit)

            if !text.isEmpty {
                Button {
                    withAnimation(.smooth(duration: 0.25)) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: .capsule)
        .overlay {
            Capsule().strokeBorder(isFocused ? tint.opacity(0.6) : .clear, lineWidth: 1)
        }
        .animation(.smooth(duration: 0.25), value: isFocused)
        .animation(.smooth(duration: 0.25), value: text.isEmpty)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(placeholder)
    }
}

// MARK: - Demo

struct LiquidGlassSearchPillDemo: View {
    @State private var query = ""

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [.teal, .blue, .indigo],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            if #available(iOS 26, *) {
                LiquidGlassSearchPill(text: $query, placeholder: "Search anything", tint: .white)
                    .padding()
            } else {
                LiquidGlassSearchPillFallback(text: $query, placeholder: "Search anything", tint: .white)
                    .padding()
            }
        }
    }
}

#Preview {
    LiquidGlassSearchPillDemo()
}
