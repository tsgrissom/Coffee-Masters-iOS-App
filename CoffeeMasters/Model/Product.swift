import Foundation

struct Product: Decodable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var image: String
    
    var imageUrl: URL {
        URL(string: "https://firtman.github.io/coffeemasters/api/images/\(self.image)")!
    }
    
    init(id: Int, name: String, description: String, price: Double, image: String = "") {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.image = image
    }
}
