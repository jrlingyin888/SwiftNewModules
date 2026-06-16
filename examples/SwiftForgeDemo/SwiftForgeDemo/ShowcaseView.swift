import SwiftUI

/// An auto-playing tour that cycles through highlight components every few seconds.
struct ShowcaseView: View {
    @State private var index = 0
    @State private var otp = "1208"
    private let count = 7
    private let titles = ["Liquid Glass card", "Pricing card", "Stat cards", "Activity rings", "OTP input", "Morphing glass bar", "Like burst"]
    private let timer = Timer.publish(every: 3.6, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            background(for: index).ignoresSafeArea()
            VStack(spacing: 0) {
                caption
                    .padding(.top, 12)
                Spacer(minLength: 0)
                scene(for: index)
                    .padding(.horizontal, 24)
                    .id(index)
                    .transition(.asymmetric(insertion: .scale(scale: 0.92).combined(with: .opacity), removal: .opacity))
                Spacer(minLength: 0)
                dots
                    .padding(.bottom, 72)
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                index = (index + 1) % count
            }
        }
    }

    @ViewBuilder private func scene(for i: Int) -> some View {
        switch i {
        case 0:
            if #available(iOS 26, *) {
                LiquidGlassFeatureCard(icon: "sparkles", title: "Liquid Glass", subtitle: "iOS 26 components your agent gets right.", tint: .cyan) {}
            } else { iosBadge }
        case 1:
            FeaturedPricingTierCard(planName: "Pro", price: "$29", period: "mo", tagline: "For growing teams.", features: ["Unlimited projects", "Priority support", "No ads, ever"], isFeatured: true, accent: .indigo) {}
        case 2:
            VStack(spacing: 16) {
                StatMetricCard(title: "Revenue", value: "$48.2K", icon: "dollarsign.circle.fill", change: 0.124, accent: .green)
                StatMetricCard(title: "Active Users", value: "12,840", icon: "person.2.fill", change: 0.083, accent: .blue)
            }
        case 3:
            ActivityRingsProgressGauge(metrics: [
                .init(name: "Move", progress: 0.82, tint: .pink),
                .init(name: "Exercise", progress: 0.6, tint: .green),
                .init(name: "Stand", progress: 0.45, tint: .cyan)
            ], centerTitle: "82%")
        case 4:
            OTPInput(code: $otp)
        case 5:
            if #available(iOS 26, *) {
                MorphingGlassToolbar(actions: [
                    .init(symbol: "square.and.arrow.up", title: "Share", tint: .white) {},
                    .init(symbol: "heart.fill", title: "Like", tint: .pink) {},
                    .init(symbol: "bookmark.fill", title: "Save", tint: .yellow) {}
                ])
            } else { iosBadge }
        default:
            HeartLikeBurstButton(likedColor: .red) { _ in }
                .scaleEffect(2.4)
        }
    }

    private var iosBadge: some View {
        Text("iOS 26").font(.largeTitle.bold()).foregroundStyle(.white)
    }

    private var caption: some View {
        VStack(spacing: 4) {
            Text("SwiftForge").font(.caption.weight(.semibold)).foregroundStyle(.white.opacity(0.75))
            Text(titles[index]).font(.title3.bold()).foregroundStyle(.white)
        }
        .id(index)
        .transition(.opacity)
    }

    private var dots: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { i in
                Circle().fill(.white.opacity(i == index ? 0.95 : 0.35)).frame(width: 7, height: 7)
            }
        }
    }

    private func background(for i: Int) -> LinearGradient {
        let palettes: [[Color]] = [
            [.indigo, .purple, .pink],
            [.blue, .cyan, .teal],
            [.green, .mint, .teal],
            [.orange, .pink, .red],
            [.purple, .indigo, .blue],
            [.teal, .blue, .indigo],
            [.pink, .red, .orange]
        ]
        return LinearGradient(colors: palettes[i % palettes.count], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

#Preview {
    ShowcaseView()
}
