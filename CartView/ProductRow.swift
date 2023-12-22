//
//  ProductRow.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 13/12/23.
//

import SwiftUI

struct ProductRow: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    var product: Product
    var productDocument: UserCartProduct
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: product.images?.first ?? ""), content: { image in
                image
                    .resizable()
                    .scaledToFit()
            }, placeholder: {
                ProgressView()
            })
            .scaledToFit()
            .frame(width: 150, height: 100)
            .cornerRadius(10)
            
            namePriceQuantity()
            
            Spacer()
            
            binButton()
            
        }
        .padding()
        .background {
            Color.gray
        }
        .cornerRadius(10)
        .padding()
    }
    
    func namePriceQuantity() -> some View {
        VStack(alignment: .leading,spacing: 10){
            Text("\(product.title ?? "No Title")")
            Text("$\(product.price ?? 0)")
//            HStack{
//                Text(" Qnt: \(product.multipleSelectionCount ?? 0)")
////                quantityPlusMinus(product: product)
//                Stepper("") {
////                    cartManager.addToCart(product: product)
//                } onDecrement: {
////                    cartManager.removeFromCart(product: product)
//                }
//            }
            .border(.white)
        }
    }
    
    func binButton() -> some View {
        Button {
            cartViewModel.removeCartProduct(productId: String(productDocument.id))
            cartViewModel.subtractPriceFromTotal(price: product.price ?? 0)
        } label: {
            Image("bin")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
                .cornerRadius(10)
        }
    }

}

//struct ProductRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductRow(product: Product(id: 3, title: "preview"))
//    }
//}
