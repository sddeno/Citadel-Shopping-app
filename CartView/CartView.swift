//
//  CartView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 13/12/23.
//

import SwiftUI

struct CartView: View {
    @StateObject var viewModel = CartViewModel()
    var body: some View {
        ScrollView{
            
            if viewModel.userCartProducts.count > 0 {
                ForEach(viewModel.userCartProducts, id: \.id.self) { document in
                    ProductCartCellViewBuilder(productDocument: document)
                        .environmentObject(viewModel)
                }
                Text("Total : \(viewModel.total)")
                    .bold()
                    .padding(10)
            }else{
                Text("Your cart is empty")
            }
        }
        .navigationTitle(Text("My Cart"))
        .padding(.top)
        .onFirestAppear {
            viewModel.addListenerForCart()
        }

    }
  
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
