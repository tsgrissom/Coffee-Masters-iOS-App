import SwiftUI

struct CartItemView: View {
    
    @EnvironmentObject var cartManager: CartManager
    
    var itemInCart: CartItem
    
    init(for itemInCart: CartItem) {
        self.itemInCart = itemInCart
    }
    
    var body: some View {
        HStack {
            Text("\(itemInCart.quantity)x")
            Text(itemInCart.product.name)
            Spacer()
            cartManager.formatCostAsView(itemInCart.subtotal)
            RemoveItemView(frameSize: 35, itemInCart: itemInCart)
                .padding()
        }
    }
}

private struct RemoveItemView: View {
    
    @EnvironmentObject var cartManager: CartManager
    
    var frameSize: CGFloat
    var itemInCart: CartItem
    
    @State var isPressed = false
    @State var debounce = false
    
    private func handleTap(delay: Double = 1.0) {
        let actionDelay = delay + 0.2
        let debounceDelay = delay + 0.4
        
        if (debounce) { return }
        
        withAnimation { isPressed = true }
        debounce = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.linear(duration: 0.2)) { isPressed = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + actionDelay) {
            cartManager.removeByUnique(itemInCart.id)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay) {
            debounce = false
        }
    }
    
    var body: some View {
        return ZStack {
            Circle()
                .fill(.accent)
                .frame(width: frameSize, height: frameSize)
            Image(systemName: "trash")
                .font(.title3)
                .foregroundStyle(.white)
                .bold()
        }
        .rotationEffect(.degrees(isPressed ? 180 : 0))
        .onTapGesture { handleTap() }
    }
}

private let mockedCartItem = MockupUtilities.getMockCartItem()

#Preview("Primary View") {
    CartItemView(for: mockedCartItem)
        .environmentObject(CartManager())
}

#Preview("Remove Button View") {
    RemoveItemView(frameSize: 55, itemInCart: mockedCartItem)
        .environmentObject(CartManager())
}
