import SwiftUI

struct OrderPage: View {
    
    // Bring singleton injected in app into scope
    @EnvironmentObject var cartManager: CartManager
    
    @State var name:  String = ""
    @State var phone: String = ""
    
    var body: some View {
        NavigationView {
            if cartManager.cart.count == 0 {
                Text("Your order is empty")
                    .navigationTitle("Your Order")
            } else {
                let count = cartManager.getAmountOfItems()
                listBody
                    .navigationTitle("Your Order (\(count))")
            }
        }
    }
    
    private var listBody: some View {
        let bgModifier = ListRowModifier()
        return List {
            cartSection
                .modifier(bgModifier)
            customerDetailsSection
                .modifier(bgModifier)
            costSection
                .modifier(bgModifier)
            SubmitButton(name: name, phone: phone)
                .modifier(bgModifier)
        }
    }
    
    
    private var cartSection: some View {
        Section("ITEMS") {
            ForEach(cartManager.cart) { itemInCart in
                CartItemView(for: itemInCart)
            }
        }
    }
    
    private var customerDetailsSection: some View {
        Section("YOUR DETAILS") {
            VStack {
                TextField("Your Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                Spacer().frame(height: 20)
                TextField("Your Phone #", text: $phone)
                    .keyboardType(.phonePad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.vertical)
        }
    }
    
    private var costSection: some View {
        let subtotal = cartManager.getSubtotalCost()
        let taxAmount = cartManager.getTaxAmount()
        let total = cartManager.getTotalCost()
        return Section() {
            HStack {
                VStack(alignment: .leading) {
                    Text("Subtotal")
                    Text("Tax")
                    Text("Total")
                }
                Spacer()
                VStack(alignment: .leading) {
                    cartManager.formatCostAsView(subtotal)
                    cartManager.formatCostAsView(taxAmount)
                    cartManager.formatCostAsView(total)
                        .bold()
                }
            }
        }
    }
}

private struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color("Background"))
    }
}

private struct SubmitButton: View {
    
    var name: String
    var phone: String
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cartManager: CartManager
    
    @State var isPressed: Bool = false
    
    private func onSubmitTap() {
        withAnimation { isPressed = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            isPressed = false
            cartManager.removeAll()
            dismiss()
        }
    }
    
    private var submitBgColor: Color {
        if (name.isEmpty || phone.isEmpty) {
            return Color("Disabled")
        }
        
        if ((name.isNotEmpty && phone.isNotEmpty) && isPressed) {
            return Color("Success")
        }
        
        return Color("Alternative2")
    }
    
    private var submitFgColor: Color {
        isPressed ? .white : .black
    }
    
    private var isSubmitDisabled: Bool {
        name.isEmpty || phone.isEmpty
    }
    
    var body: some View {
        Button(action: onSubmitTap) {
            Text(isPressed ? "..." : "Submit Order")
                .animation(nil)
        }
        .padding()
        .frame(width: 250)
        .disabled(isSubmitDisabled)
        .background(submitBgColor)
        .foregroundStyle(submitFgColor)
        .cornerRadius(25)
    }
}

#Preview("Order Page") {
    OrderPage()
        .environmentObject(CartManager())
}

#Preview("Submit Button") {
    SubmitButton(name: "Tyler", phone: "8002224747")
        .environmentObject(CartManager())
}
