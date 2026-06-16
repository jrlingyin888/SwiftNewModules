import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let message: String
    var tint: Color = .accentColor
}

struct OnboardingPagerView: View {
    let pages: [OnboardingPage]
    var onFinish: () -> Void = {}

    @State private var selection = 0

    private var isLastPage: Bool {
        selection >= pages.count - 1
    }

    private var currentTint: Color {
        guard pages.indices.contains(selection) else { return .accentColor }
        return pages[selection].tint
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    VStack(spacing: 24) {
                        Image(systemName: page.symbol)
                            .font(.system(size: 84, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(page.tint.gradient)
                            .accessibilityHidden(true)

                        VStack(spacing: 12) {
                            Text(page.title)
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                            Text(page.message)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            PagingDots(count: pages.count, current: selection)
                .padding(.top, 8)

            Button(action: advance) {
                Text(isLastPage ? "Get Started" : "Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(currentTint)
            .animation(.smooth, value: selection)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 16)
        }
    }

    private func advance() {
        if isLastPage {
            onFinish()
        } else {
            withAnimation(.smooth) { selection += 1 }
        }
    }
}

private struct PagingDots: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.primary : Color.secondary.opacity(0.3))
                    .frame(width: index == current ? 22 : 8, height: 8)
            }
        }
        .animation(.smooth, value: current)
        .accessibilityElement()
        .accessibilityLabel("Page \(current + 1) of \(count)")
    }
}

#Preview {
    OnboardingPagerView(pages: [
        OnboardingPage(symbol: "sparkles", title: "Welcome", message: "Everything you need to get started, beautifully organized in one place.", tint: .purple),
        OnboardingPage(symbol: "bolt.fill", title: "Lightning Fast", message: "Built for speed so you can focus on what matters most.", tint: .orange),
        OnboardingPage(symbol: "lock.shield.fill", title: "Private by Design", message: "Your data stays yours. Always encrypted, never sold.", tint: .green)
    ])
}
