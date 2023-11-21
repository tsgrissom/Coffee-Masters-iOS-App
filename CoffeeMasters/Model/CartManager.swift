import Foundation
import SwiftUI

class CartManager: ObservableObject {
    
    @Published var cart: [CartItem] = []
    
    func getAmountOfItems() -> Int {
        var count = 0
        for itemInCart in self.cart {
            count += itemInCart.quantity
        }
        return count
    }
    
    func getSubtotalCost() -> Double {
        var sum = 0.0
        for itemInCart in self.cart {
            sum += itemInCart.subtotal
        }
        return sum
    }
    
    func formatCostAsView(_ cost: Double) -> some View {
        return Text("$ \(cost, specifier: "%.2f")")
    }
    
    func getTaxAmount(rate: Double = 0.10) -> Double {
        let subtotal = getSubtotalCost()
        return subtotal * rate
    }
    
    func getTotalCost(rate: Double = 0.10) -> Double {
        let subtotal = getSubtotalCost()
        let taxAmount = getTaxAmount(rate: rate)
        return subtotal + taxAmount
    }
    
    func add(product: Product, quantity: Int) {
        self.cart.append(CartItem(product: product, quantity: quantity))
    }
    
    func removeByUnique(_ uuidStr: String) {
        self.cart.removeAll { itemInCart in
            return itemInCart.id==uuidStr
        }
    }
    
    func removeByProduct(_ product: Product) {
        self.cart.removeAll { itemInCart in
            return itemInCart.product.id==product.id
        }
    }
    
    func removeAll() {
        self.cart = []
    }
}
