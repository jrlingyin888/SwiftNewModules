import SwiftUI

/// A swipeable paged carousel with a custom dot indicator. The native page
/// dots are hidden so we can render tappable, animated indicators ourselves.
struct PagedCarouselView: View {
    @State private var currentPage = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let pages = PagedCardModel.samples

    var body: some View {
        VStack(spacing: 24) {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    PagedCardView(model: page)
                        .padding(.horizontal, 24)
                        .scaleEffect(scale(for: index))
                        .opacity(opacity(for: index))
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: currentPage)

            PagedDotIndicator(pageCount: pages.count, currentPage: $currentPage)

            Button {
                withAnimation(reduceMotion ? nil : .snappy) {
                    currentPage = min(currentPage + 1, pages.count - 1)
                }
            } label: {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .padding(.top, 40)
        .background(Color(.systemGroupedBackground))
    }

    private func scale(for index: Int) -> CGFloat {
        guard !reduceMotion else { return 1 }
        return index == currentPage ? 1 : 0.92
    }

    private func opacity(for index: Int) -> Double {
        guard !reduceMotion else { return 1 }
        return index == currentPage ? 1 : 0.6
    }
}

private struct PagedDotIndicator: View {
    let pageCount: Int
    @Binding var currentPage: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .onTapGesture {
                        withAnimation(reduceMotion ? nil : .snappy) { currentPage = index }
                    }
                    .accessibilityLabel("Page \(index + 1) of \(pageCount)")
                    .accessibilityAddTraits(index == currentPage ? .isSelected : [])
            }
        }
        .animation(reduceMotion ? nil : .snappy, value: currentPage)
        .accessibilityElement(children: .contain)
    }
}

private struct PagedCardView: View {
    let model: PagedCardModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: model.symbol)
                .font(.system(size: 72, weight: .semibold))
                .foregroundStyle(model.tint.gradient)
                .frame(height: 120)
                .accessibilityHidden(true)
            Text(model.title)
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)
            Text(model.subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 40)
        .background(.background, in: .rect(cornerRadius: 28))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
        .accessibilityElement(children: .combine)
    }
}

private struct PagedCardModel: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let subtitle: String
    let tint: Color

    static let samples: [PagedCardModel] = [
        .init(symbol: "sparkles", title: "Welcome", subtitle: "Swipe through to discover what's new in this release.", tint: .purple),
        .init(symbol: "bolt.fill", title: "Fast & Fluid", subtitle: "Everything is tuned for buttery-smooth performance.", tint: .orange),
        .init(symbol: "lock.shield.fill", title: "Private", subtitle: "Your data stays on device and fully encrypted.", tint: .green)
    ]
}

#Preview {
    PagedCarouselView()
}
