//
//  CartViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 14/12/23.
//

import Foundation
import Combine

@MainActor
class CartViewModel : ObservableObject {
    @Published private(set) var userCartProducts: [UserCartProduct] = []
    @Published var total: Int = 0
    private var cancellable = Set<AnyCancellable> ()
    
    func addPriceToTotal(price: Int){
        total += price
    }
    func subtractPriceFromTotal(price: Int){
        total -= price
    }
    
    func addListenerForCart() {
        Task {
            guard let authDataResult = try? AuthenticationManager.shared.getAuthenticationUser() else { return }
            UserManger.shared.addListnerForAllUserCartProducts(userId: authDataResult.uid)
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { [weak self] returnedProducts in
                    self?.userCartProducts = returnedProducts
                })
                .store(in: &cancellable)
        }
    }
    
    func removeCartProduct(productId: String) {
        
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
                
                try? await UserManger.shared.removeUserCartProduct(userId: authDataResult.uid , productId: productId)
            }catch {
                print("error fetching current auth user")
            }
        }
    }
}
