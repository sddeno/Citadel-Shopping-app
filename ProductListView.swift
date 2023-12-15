//
//  ProductListView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 31/05/23.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductViewModel()
    var product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            
            AsyncImage(url: URL(string: product.thumbnail ?? "")){ image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading){
                    Text(String(product.title ?? ""))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Price :" + String(product.price ?? 0))
                    Text("Category :" + String(product.category ?? ""))
                    Text("Brand: " + String(product.brand ?? ""))
                    Text("Rating :" + String(product.rating ?? 4.0))
            }
            .font(.callout)
            .foregroundColor(.secondary)
            
            
            Button {
                viewModel.addProductToCart(productId: product.id)
            } label: {
                Image("AddToCart")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .cornerRadius(90)
                    .padding([.leading,.bottom])
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(product: Product(
            id: 1, title: "title", description: "description", price: 32, discountPercentage: 30, rating: 4, stock: 90, brand: "Samsung", category: "Phone", thumbnail: "", images: []))
    }
}
