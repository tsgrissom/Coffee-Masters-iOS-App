import SwiftUI

struct ProductItemView: View {
    
    var product: Product
    
    private func getPriceAsView() -> some View {
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
                    getPriceAsView()
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
    let mockProduct = MockupUtilities.getMockProduct()
    return ProductItemView(product: mockProduct)
}
