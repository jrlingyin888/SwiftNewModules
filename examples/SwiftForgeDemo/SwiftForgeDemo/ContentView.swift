import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DemoTab()
                .tabItem { Label("Demo", systemImage: "sparkles") }
            CatalogTab()
                .tabItem { Label("Catalog", systemImage: "square.grid.2x2") }
        }
    }
}

/// Live-renders real swiftforge components inside the running app.
private struct DemoTab: View {
    @State private var otp = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    GroupBox("OTPInput — swiftforge") {
                        OTPInput(code: $otp).padding(.vertical, 8)
                    }
                    GroupBox("PaywallScreen — swiftforge") {
                        PaywallScreen(
                            title: "Unlock Pro",
                            benefits: ["Unlimited everything", "Priority support", "No ads, ever"],
                            plans: [
                                PaywallPlan(name: "Yearly", price: "$39.99", period: "year", badge: "Save 40%"),
                                PaywallPlan(name: "Monthly", price: "$5.99", period: "month")
                            ]
                        )
                        .frame(height: 540)
                    }
                }
                .padding()
            }
            .navigationTitle("SwiftForge")
        }
    }
}

/// Lists every component the agent can pull from swiftforge.
private struct CatalogTab: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(SwiftForgeCatalog.categories, id: \.self) { cat in
                    Section(cat) {
                        ForEach(SwiftForgeCatalog.items.filter { $0.category == cat }) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.title).font(.headline)
                                    Spacer()
                                    Text("iOS " + item.minIOS).font(.caption).foregroundStyle(.secondary)
                                }
                                Text(item.info).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Catalog · \(SwiftForgeCatalog.items.count)")
        }
    }
}
