//
//  FavoriteViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 06/06/23.
//

import Foundation
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    //    @Published private(set) var productArray: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellable = Set<AnyCancellable>()
    
    func addListenerForFavorites() {
        Task{
            guard let authDataResult = try? AuthenticationManager.shared.getAuthenticationUser() else { return }
            
            //            UserManger.shared.addListnerForAllUserFavoriteProducts(userId: authDataResult.uid, completion: { [weak self] poducts in
            //                self?.userFavoriteProducts = poducts
            //            })
            
            UserManger.shared.addListnerForAllUserFavoriteProducts(userId: authDataResult.uid)
                .sink { _ in
                    
                } receiveValue: { [weak self] returnedProducts in
                    self?.userFavoriteProducts = returnedProducts
                }
                .store(in: &cancellable)
            
        }
    }
    
    //    func getFavorites() {
    //        Task{
    //            let authDataResult = try  AuthenticationManager.shared.getAuthenticationUser()
    //            self.userFavoriteProducts = try await UserManger.shared.getAlluserFavoriteProducts(userId: authDataResult.uid)
    //        }
    //    }
    
    //    func getFavorites() {
    //        Task{
    //            do{
    //                let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
    //
    //                let userFavoriteProducts = try await UserManger.shared.getAlluserFavoriteProducts(userId: authDataResult.uid)
    //
    //                var localArray: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
    //
    //                for userFavoritedProduct in userFavoriteProducts {
    //                    if let product = try? await ProductManager.shared.getProduct(productId: String(userFavoritedProduct.productId)){
    //                        localArray.append((userFavoritedProduct, product))
    //                    }
    //                }
    //
    //                self.productArray = localArray
    //            }catch{
    //                print("error \(error)")
    //            }
    //        }
    //    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
            try? await UserManger.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            //            getFavorites()
        }
    }
}
