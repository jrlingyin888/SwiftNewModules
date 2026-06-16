import SwiftUI

/// A bottom sheet demonstrating custom detents, programmatic selection,
/// a grabber, and detent-aware content. Drop the `.detentSheet` modifier
/// onto any view to present it.
struct DetentSheetDemoScreen: View {
    @State private var isSheetPresented = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.35)

    private let small: PresentationDetent = .fraction(0.35)
    private let large: PresentationDetent = .large

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ContentUnavailableView(
                        "Plan Your Route",
                        systemImage: "map",
                        description: Text("Tap below to choose a destination and options.")
                    )
                    .padding(.top, 40)

                    Button {
                        selectedDetent = small
                        isSheetPresented = true
                    } label: {
                        Label("Show Options", systemImage: "slider.horizontal.3")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Trip")
            .detentSheet(
                isPresented: $isSheetPresented,
                selection: $selectedDetent,
                detents: [small, large]
            ) {
                DetentSheetContent(
                    selectedDetent: $selectedDetent,
                    expandedDetent: large,
                    collapsedDetent: small
                )
            }
        }
    }
}

/// A view modifier that wires up a sheet with custom detents, a grabber,
/// and a bound detent selection so callers can read/drive the active size.
struct DetentSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selection: PresentationDetent
    let detents: Set<PresentationDetent>
    @ViewBuilder var sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            sheetContent()
                .presentationDetents(detents, selection: $selection)
                .presentationDragIndicator(.visible)
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(28)
                .presentationContentInteraction(.scrolls)
        }
    }
}

extension View {
    func detentSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        selection: Binding<PresentationDetent>,
        detents: Set<PresentationDetent>,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(DetentSheetModifier(
            isPresented: isPresented,
            selection: selection,
            detents: detents,
            sheetContent: content
        ))
    }
}

private struct DetentSheetContent: View {
    @Binding var selectedDetent: PresentationDetent
    let expandedDetent: PresentationDetent
    let collapsedDetent: PresentationDetent

    private var isExpanded: Bool { selectedDetent == expandedDetent }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Ride Options")
                    .font(.title2.weight(.bold))
                Spacer()
                Button {
                    withAnimation(.snappy) {
                        selectedDetent = isExpanded ? collapsedDetent : expandedDetent
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(.thinMaterial, in: .circle)
                }
                .accessibilityLabel(isExpanded ? "Collapse sheet" : "Expand sheet")
            }
            .padding([.horizontal, .top], 20)
            .padding(.bottom, 12)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(DetentRideOption.samples) { option in
                        DetentRideRow(option: option)
                    }
                    if isExpanded {
                        DetentExtraInfoPanel()
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .animation(.snappy, value: isExpanded)
            }
        }
    }
}

private struct DetentRideRow: View {
    let option: DetentRideOption

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: option.symbol)
                .font(.title3)
                .frame(width: 44, height: 44)
                .background(option.tint.opacity(0.15), in: .rect(cornerRadius: 12))
                .foregroundStyle(option.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(option.name).font(.headline)
                Text(option.eta).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Text(option.price).font(.headline.monospacedDigit())
        }
        .padding(12)
        .background(.background.secondary, in: .rect(cornerRadius: 16))
        .accessibilityElement(children: .combine)
    }
}

private struct DetentExtraInfoPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Estimated arrival 4:18 PM", systemImage: "clock")
            Label("Payment: Apple Pay", systemImage: "creditcard")
            Label("Fares may change with demand", systemImage: "info.circle")
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }
}

private struct DetentRideOption: Identifiable {
    let id = UUID()
    let name: String
    let eta: String
    let price: String
    let symbol: String
    let tint: Color

    static let samples: [DetentRideOption] = [
        .init(name: "Standard", eta: "3 min away", price: "$12", symbol: "car.fill", tint: .blue),
        .init(name: "Comfort", eta: "5 min away", price: "$18", symbol: "car.side.fill", tint: .indigo),
        .init(name: "XL", eta: "6 min away", price: "$24", symbol: "bus.fill", tint: .teal)
    ]
}

#Preview {
    DetentSheetDemoScreen()
}
