//
//  ProductCartCellViewBuilder.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 14/12/23.
//

import SwiftUI

struct ProductCartCellViewBuilder: View {
    let productDocument: UserCartProduct
    
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack{
            if let product {
                ProductRow(product: product, productDocument: productDocument)
            }
        }
        .task{
            self.product = try? await ProductManager.shared.getProduct(productId: String(productDocument.productId))
        }
    }
}
//
//struct ProductCartCellViewBuilder_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCartCellViewBuilder(productId: "1")
//    }
//}
