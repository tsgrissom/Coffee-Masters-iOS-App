import SwiftUI

struct SpecialOfferView: View {
    var title = ""
    var description = ""
    
    var body: some View {
        ZStack {
            Image("BackgroundPattern")
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipped()
            VStack {
                Text(title)
                    .padding()
                    .background(Color("CardBackground"))
                    .font(.title)
                Text(description)
                    .padding()
                    .background(Color("CardBackground"))
            }
        }
    }
}

#Preview {
    SpecialOfferView(title: "Some title", description: "The body of the offer")
        .previewLayout(.fixed(width: 350, height: 200))
        .previewInterfaceOrientation(.portrait)
}

#Preview {
    SpecialOfferView(title: "Another", description: "The body of some other offer")
        .previewInterfaceOrientation(.portraitUpsideDown)
}

#Preview {
    SpecialOfferView(title: "Yet another", description: "This is the body of yet another offer")
        .previewInterfaceOrientation(.landscapeLeft)
}
