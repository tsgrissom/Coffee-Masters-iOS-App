import Foundation

struct MockupUtilities {
    static func getMockProduct() -> Product {
        return Product(
            id: 1,
            name: "A Product",
            description: "Some mocked up product with an extended description",
            price: 1.75,
            image: ""
        )
    }
}
