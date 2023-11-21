import SwiftUI

struct MenuPage: View {
    
    @EnvironmentObject var menuManager: MenuManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(menuManager.menu) { category in
                    Text(category.name)
                    ForEach(category.products) { product in
                        getNavigationLink(for: product)
                    }
                }
            }
            .listStyle(.inset)
            .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .navigationTitle("Products")
        }
    }
    
    private func getNavigationLink(for product: Product) -> some View {
        NavigationLink {
            ProductDetailView(for: product)
        } label: {
            ProductItemView(for: product)
        }
    }
}

#Preview {
    MenuPage()
        .environmentObject(MenuManager())
}
