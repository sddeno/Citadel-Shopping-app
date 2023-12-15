//
//  ProductView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 30/05/23.
//

import SwiftUI



struct ProductView: View {
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        
        List{
            //            Button {
            //                viewModel.getProductsByRating()
            //            } label: {
            //                Text("Get More Products")
            //            }
            
            
            ForEach(viewModel.productArray, id: \.self.id) { product in
                ProductListView(product: product)
                    .contextMenu {
                        Button("Add to Favorite"){
                            // add to favorite product list view
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                
                if product == viewModel.productArray.last {
                    ProgressView()
                        .onAppear(){
                            print("fetching more PRODUCTS ::::")
                            viewModel.getProducts()
                        }
                }
            }
        }
        .navigationBarTitle("Products")
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading){
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")"){
                    ForEach(ProductViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(filterOption.rawValue.capitalized) {
                            Task{
                                try? await viewModel.filterSelected(option:filterOption)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing){
                Menu("Filter: \(viewModel.selectedCategory?.rawValue ?? "NONE")"){
                    ForEach(ProductViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue.capitalized) {
                            Task{
                                try? await viewModel.CategorySelected(option:option)
                            }
                        }
                    }
                }
            }
        }
        .toolbar(content: {
            NavigationLink {
                CartView()
            } label: {
                CartButton(numberOfProducts: viewModel.cartItemCount)
            }
        })
        .padding(.horizontal,10)
        .task{
            viewModel.getAllProductsCount()
//            viewModel.cartCount()
            viewModel.addListenercartItemCount()
        }
    }
    
    
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
