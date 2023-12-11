//
//  FavoriteView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 05/06/23.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject var viewModel = FavoriteViewModel()
    
    
    var body: some View {
        
        List{
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                //                ProductListView(product: item.product)
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu{
                        Button("Remove from Favorite"){
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorites")
        .onFirestAppear {
            viewModel.addListenerForFavorites()
        }
        
        
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FavoriteView()
        }
    }
}

