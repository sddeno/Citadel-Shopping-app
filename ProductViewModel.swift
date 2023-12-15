//
//  ProductViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 06/06/23.
//

import Foundation
import FirebaseFirestore
import Combine

// get data from URL and then updlaod it to Firebase and get from firebase and display in SwiftUI

@MainActor
final class ProductViewModel: ObservableObject {
    
    @Published private(set) var cartItemCount: Int = 0
    @Published private(set) var productArray: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    
    func addListenercartItemCount() {
        Task {
            guard let authDataResult = try? AuthenticationManager.shared.getAuthenticationUser() else { return }
            
            UserManger.shared.addAggregateCountListener(userId: authDataResult.uid)
                .sink { _ in
                    
                } receiveValue: { returnedCount in
                    self.cartItemCount = returnedCount
                }
                .store(in: &cancellable)

        }
    }
    
//    func cartCount() {
//        Task {
//            do {
//                let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
//
//                let count = try await UserManger.shared.userCartCount(userId: authDataResult.uid)
//                self.cartItemCount = count
//            }catch {
//                print("couldn't fetch auth user ")
//            }
//        }
//    }
    
    // only wants to download once
    //    func downloadProductsAndUplaodToFirebase() {
    //        guard let url = URL(string: "https://dummyjson.com/products") else { return }
    //        Task{
    //            do{
    //                let (data, _) = try await URLSession.shared.data(from: url)
    //
    //                let products = try JSONDecoder().decode(Products.self, from: data)
    //
    //                let productArray = products.products
    //
    //                for product in (productArray ?? []) { // updload product
    //                    try? await ProductManager.shared.createProduct(product: product)
    //                }
    //
    //            }catch {
    //                print(error)
    //            }
    //        }
    //    }
    
    //    func getAllProducts() {
    //        Task{
    //            do{
    //                let products = try await ProductManager.shared.getAllProduct()
    //                self.productArray = products
    //            }catch {
    //                print("error fetching all products \(error)")
    //            }
    //        }
    //    }
    
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.productArray = []
        self.lastDocument = nil
        self.getProducts()
        
        /*
         switch option {
         case .noFilter:
         self.productArray = try await ProductManager.shared.getAllProduct()
         
         case .priceHigh:
         // query and fetch item
         self.productArray = try await ProductManager.shared.getAllProductsSortedByPrice(descending: true)
         // update UI
         // set filter to price high
         case .priceLow:
         self.productArray = try await ProductManager.shared.getAllProductsSortedByPrice(descending: false)
         }
         
         self.selectedFilter = option
         */
    }
    
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func CategorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.productArray = []
        self.lastDocument = nil
        self.getProducts()
        
        /*
         switch option {
         case .noCategory:
         self.productArray = try await ProductManager.shared.getAllProduct()
         case .smartphones, .laptops, .fragrances :
         self.productArray = try await ProductManager.shared.getAllProductsForCategory(category: option.rawValue)
         }
         self.selectedCategory = option
         */
    }
    
    
    func getProducts() {
        //        print("LAST DOC")
        //        print(lastDocument)
        
        Task{
            do{
                let (newProducts, lastDocument) = try await
                ProductManager.shared.getAllProducts(
                    priceDescending: selectedFilter?.priceDescending,
                    forCategory: selectedCategory?.categoryKey,
                    count: 10,
                    lastDocument: lastDocument
                )
                
                self.productArray.append(contentsOf: newProducts)
                if let lastDocument {
                    self.lastDocument = lastDocument
                }
            }catch {
                print("error fetching products")
            }
            
            //            print("Returned DOC")
            //            print(lastDocument)
        }
    }
    
    func getProductsByRating() {
        Task{

            do{
                let (newProducts, lastDocument) = try await ProductManager.shared.getProductsByRating(count: 4, lastDocument: lastDocument, lastRating: productArray.last?.rating)
                self.productArray.append(contentsOf: newProducts)

                self.lastDocument = lastDocument

            }catch{
                print("error fetching product by rating by lastDocument \(error)")
            }

        }
    }
    
    func getAllProductsCount() {
        
        Task{
            do{
                let count = try await ProductManager.shared.getAllProductsCount()
                print("count \(count)")
            }catch {
                print(error)
            }
        }
    }
    
    func addUserFavoriteProduct(productId: Int){
        Task{
            do{
                let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
                
                try? await UserManger.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
            }catch{
                
            }
        }
    }
    
    func addProductToCart(productId: Int){
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
                try? await UserManger.shared.addUserCartProduct(userId: authDataResult.uid, productId: productId)
            }catch {
                print("product not added to cart due to error : \(error)")
            }
        }

    }
    
}
