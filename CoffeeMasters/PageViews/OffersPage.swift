import SwiftUI

struct OffersPage: View {
    var body: some View {
        NavigationView {
            List {
                SpecialOfferView(title: "Early Coffee", description: "10% off. Offer valid from 6am to 9am.")
                SpecialOfferView(title: "Welcome Gift", description: "25% off on your first order.")
            }.navigationTitle("Offers")
        }
    }
}

#Preview {
    OffersPage()
}
