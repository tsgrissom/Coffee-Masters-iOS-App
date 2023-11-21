import SwiftUI

struct ProductDetailView: View {
    
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) var dismiss

    @State var quantity = 1
    var product: Product
    
    init(for product: Product) {
        self.product = product
    }
    
    private func renderPricePerUnit() -> some View {
        return Text("$ \(product.price, specifier: "%.2f") ea")
    }
    
    private func renderSubtotal() -> some View {
        let subtotal = Double(quantity) * product.price
        return Text("Subtotal $\(subtotal, specifier: "%.2f")")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                AsyncImage(url: product.imageUrl)
                    .cornerRadius(5)
                    .frame(maxWidth: .infinity, idealHeight: 150, maxHeight: 150)
                    .padding(.top, 32)
                Text("x\(quantity) \(product.name)")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .padding(24)
                
                Text(product.description)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .padding(24)
                
                HStack {
                    renderPricePerUnit()
                    Stepper(value: $quantity, in: 1...10) {}
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                
                renderSubtotal()
                    .bold()
                    .padding(12)
                Button("Add \(quantity) to Cart") {
                    cartManager.add(product: product, quantity: quantity)
                    dismiss()
                }
                .padding()
                .frame(width: 250)
                .background(Color("Alternative2"))
                .foregroundStyle(.black)
                .cornerRadius(25)
            }
        }
        .navigationTitle(product.name)
    }
}

#Preview {
    ProductDetailView(for: MockupUtilities.getMockProduct())
        .environmentObject(CartManager())
}
