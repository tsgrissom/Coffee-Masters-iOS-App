import SwiftUI

struct OrderPage: View {
    
    // Bring singleton injected in app into scope
    @EnvironmentObject var cartManager: CartManager
    
    @FocusState var customTipFieldIsFocused: Bool
    
    @State var name:  String = ""
    @State var phone: String = ""
    @State var customTip: String = ""
    @State var selectedTip: Double = 0.15
    @State var calculatedTip: Double
    
    init() {
        self.calculatedTip = calculateTip()
    }
    
    private func calculateTip() -> Double {
        if (selectedTip == -1.0) { // Custom tip
            if (customTip.isEmpty) {
                print("calculateTip: selected custom tip with empty text field == 0.0")
                return 0.0
            }
            
            if (customTip.hasSuffix("%")) {
                if (!validatePercentage(customTip)) {
                    print("calculateTip: Thought \"\(customTip)\" might be a percentage, could not validate")
                    return 0.0
                } else {
                    let inputPercent = Double(customTip[customTip.startIndex...customTip.index(before: customTip.endIndex)])!
                    print("Percentage parsed: \(inputPercent)")
                }
            }
            
            if (!customTip.contains(".")) {
                print("calculateTip: No floating point") // Parse percentage input
                // Try whole number then?
            } else {
                if (validateCurrency(customTip)) {
                    print("calculateTip: Currency string for custom tip field validated")
                    return Double(customTip)!
                } else {
                    print("calculateTip: Custom tip field is invalid currency string")
                }
            }
        } else if (selectedTip > 0.0) {
            let total = cartManager.getTotalCost()
            let tipAmount = total * selectedTip
            return tipAmount
        }
        
        return 0.0
    }
    
    private func validateCurrency(_ input: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(?:\\$)?\\d{1,3}(?:,\\d{3})*(?:\\.\\d{2})?$", options: [])
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.firstMatch(in: input, options: [], range: range) != nil
        } catch {
            print("Error creating currency regex: \(error)")
            return false
        }
    }
    
    private func validatePercentage(_ input: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(100(?:\\.0{1,2})?|\\d{0,2}(?:\\.\\d{1,2})?)%$", options: [])
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.firstMatch(in: input, options: [], range: range) != nil
        } catch {
            print("Error creating percentage regex: \(error)")
            return false
        }
    }
    
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
        List {
            cartSection
            customerDetailsSection
            costSection
            SubmitButton(name: name, phone: phone)
                .listRowBackground(Color("SurfaceBackground"))
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
            VStack(spacing: 2) {
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
    
    private var customTipField: some View {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let prompt = Text("Enter your tip")
        
        return TextField(
            value: $customTip,
            formatter: formatter,
            prompt: prompt
        ) {
            Text("Enter your tip in amount of dollars")
        }
        .focused($customTipFieldIsFocused)
        .keyboardType(.numberPad)
        .frame(height: 45)
        .padding(.horizontal, 25)
        .textFieldStyle(.roundedBorder)
    }
    
    private var costSection: some View {
        let subtotal = cartManager.getSubtotalCost()
        let taxAmount = cartManager.getTaxAmount()
        let tipAmount = calculatedTip
        let total = cartManager.getTotalCost() + tipAmount
        return Section() {
            VStack {
                Text("Would you like to leave a tip?")
                Picker("How much would you like to tip?", selection: $selectedTip) {
                    Text("10%").tag(0.1)
                    Text("15%").tag(0.15)
                    Text("20%").tag(0.2)
                    Text("Custom").tag(-1.0)
                }
                .padding(.bottom, 10)
                .pickerStyle(.segmented)
                .onChange(of: selectedTip, initial: false) { oldValue, newValue in
                    print("value change: \(oldValue)->\(newValue)")
                    if (newValue == -1) {
                        print("new value eq custom")
                        customTipFieldIsFocused = true
                    } else {
                        print("new value neq custom")
                        customTip = "\(newValue)"
                    }
                }
                
                if (selectedTip == -1.0) {
                    customTipField
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Subtotal")
                    Text("Tax")
                    Text("Tip")
                    Text("Total")
                }
                Spacer()
                VStack(alignment: .leading) {
                    cartManager.formatCostAsView(subtotal)
                    cartManager.formatCostAsView(taxAmount)
                    cartManager.formatCostAsView(tipAmount)
                    cartManager.formatCostAsView(total)
                        .bold()
                }
            }
        }
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
