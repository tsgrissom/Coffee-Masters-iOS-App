import SwiftUI

struct ProductItemView: View {
    
    var product: Product
    
    init(for product: Product) {
        self.product = product
    }
    
    private func renderPricePerUnit() -> some View {
        let price = product.price
        return Text("$ \(price, specifier: "%.2f")")
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: product.imageUrl)
                .frame(width: 300, height: 150)
                .background(Color("AccentColor"))
                .cornerRadius(5)
            HStack {
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.title3)
                        .bold()
                    renderPricePerUnit()
                        .font(.caption)
                }
                .padding(.leading, 15)
                Spacer()
            }
        }
        .cornerRadius(10)
    }
}

#Preview {
    ProductItemView(for: MockupUtilities.getMockProduct())
}
