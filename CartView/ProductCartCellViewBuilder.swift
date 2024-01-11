//
//  ProductCartCellViewBuilder.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 14/12/23.
//

import SwiftUI

struct ProductCartCellViewBuilder: View {
    let productDocument: UserCartProduct
    @EnvironmentObject var viewModel: CartViewModel
    
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack{
            if let product {
                ProductRow(product: product, productDocument: productDocument)
                    .environmentObject(viewModel)
            }
        }
        .onFirestAppear {
            Task{
                self.product = try? await ProductManager.shared.getProduct(productId: String(productDocument.productId))
                if let price = product?.price {
                    viewModel.addPriceToTotal(price: price)
                }
            }
        }
    }
}
//
//struct ProductCartCellViewBuilder_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCartCellViewBuilder(productId: "1")
//    }
//}
