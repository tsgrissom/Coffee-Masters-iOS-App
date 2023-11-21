import Foundation

struct CartItem: Identifiable {
    var id: String
    var product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int) {
        self.id = UUID().uuidString
        self.product = product
        self.quantity = quantity
    }
    
    var pricePerUnit: Double {
        return self.product.price
    }
    
    var subtotal: Double {
        return pricePerUnit * Double(quantity)
    }
}
