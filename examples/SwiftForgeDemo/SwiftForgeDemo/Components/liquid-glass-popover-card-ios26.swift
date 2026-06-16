import SwiftUI

@available(iOS 26, *)
struct LiquidGlassPopoverCard: View {
    let title: String
    let message: String
    var confirmTitle: String = "Got it"
    var systemImage: String = "sparkles"
    var tint: Color = .accentColor
    var onConfirm: () -> Void
    var onDismiss: () -> Void

    @Namespace private var glassNamespace

    var body: some View {
        GlassEffectContainer(spacing: 22) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(systemName: systemImage)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(tint)
                        .frame(width: 48, height: 48)
                        .glassEffect(.regular.tint(tint.opacity(0.22)), in: .rect(cornerRadius: 14))
                        .glassEffectID("icon", in: glassNamespace)

                    Spacer(minLength: 12)

                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(10)
                            .contentShape(.circle)
                            .glassEffect(.regular.interactive(), in: .circle)
                            .glassEffectID("close", in: glassNamespace)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title3.bold())
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.glassProminent)
                .tint(tint)
            }
            .padding(22)
            .frame(maxWidth: 360)
            .glassEffect(.regular, in: .rect(cornerRadius: 28))
            .glassEffectID("card", in: glassNamespace)
        }
    }
}

// MARK: - Fallback (iOS 17–25)

struct LiquidGlassPopoverCardFallback: View {
    let title: String
    let message: String
    var confirmTitle: String = "Got it"
    var systemImage: String = "sparkles"
    var tint: Color = .accentColor
    var onConfirm: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                Image(systemName: systemImage)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: 48, height: 48)
                    .background(tint.opacity(0.18), in: .rect(cornerRadius: 14))
                Spacer(minLength: 12)
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .contentShape(.circle)
                        .background(.regularMaterial, in: .circle)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close")
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.title3.bold())
                Text(message).font(.subheadline).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Button(action: onConfirm) {
                Text(confirmTitle).font(.headline)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(tint)
        }
        .padding(22)
        .frame(maxWidth: 360)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 28))
    }
}

// MARK: - Demo

struct LiquidGlassPopoverCardDemo: View {
    @State private var isPresented = true

    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange, .pink, .purple],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Button("Show Card") { withAnimation(.bouncy) { isPresented = true } }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.black)

            if isPresented {
                Color.black.opacity(0.35).ignoresSafeArea()
                    .onTapGesture { withAnimation(.snappy) { isPresented = false } }
                    .transition(.opacity)

                Group {
                    if #available(iOS 26, *) {
                        LiquidGlassPopoverCard(
                            title: "Welcome aboard",
                            message: "This card floats on Liquid Glass and blurs the content behind it. Tap outside to dismiss.",
                            confirmTitle: "Start exploring",
                            tint: .white,
                            onConfirm: { withAnimation(.snappy) { isPresented = false } },
                            onDismiss: { withAnimation(.snappy) { isPresented = false } }
                        )
                    } else {
                        LiquidGlassPopoverCardFallback(
                            title: "Welcome aboard",
                            message: "This card floats on a material and blurs the content behind it. Tap outside to dismiss.",
                            confirmTitle: "Start exploring",
                            tint: .white,
                            onConfirm: { withAnimation(.snappy) { isPresented = false } },
                            onDismiss: { withAnimation(.snappy) { isPresented = false } }
                        )
                    }
                }
                .padding(28)
                .transition(.scale(scale: 0.92).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    LiquidGlassPopoverCardDemo()
}
