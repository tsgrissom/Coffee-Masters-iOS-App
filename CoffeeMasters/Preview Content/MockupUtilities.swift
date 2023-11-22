import Foundation

struct MockupUtilities {
    
    static func getMockCartItem() -> CartItem {
        return CartItem(
            product: getMockProduct(),
            quantity: 1
        )
    }
    
    static func getMockProduct() -> Product {
        return Product(
            id: 1,
            name: "Mock Product",
            description: "Some mocked up product with an extended description",
            price: 1.75,
            image: ""
        )
    }
}
