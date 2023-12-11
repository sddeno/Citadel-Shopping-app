//
//  PerformanceView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 09/06/23.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {
    
    @State private var title: String = "Some Title"
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(){
//                configure()
                downloadFromJsonAndUploadToFirebaseDB()
            }
    }
    
    private func configure(){
        let trace = Performance.startTrace(name: "performance_view_loading")
        trace?.setValue(title, forAttribute: "title_text")
        Task{
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Started downloading", forAttribute: "func_state")
            
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Continue downloading", forAttribute: "func_state")
            
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Finished downloading", forAttribute: "func_state")
            
            trace?.stop()
        }
        
    }
    
    
    func downloadFromJsonAndUploadToFirebaseDB(){
        let trace = Performance.startTrace(name: "dummyjson API call")
        trace?.setValue("title dummyJSON", forAttribute: "dummyjson attribute")
        
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        Task{
            do{
                trace?.setValue("fetching", forAttribute: "fetching ")
                let (data, _) = try await URLSession.shared.data(from: url)
                
                trace?.setValue("decoding", forAttribute: "decoding")
                let products = try JSONDecoder().decode(Products.self, from: data)
                
                
                let productArray = products.products
                trace?.setValue("uploading to DB", forAttribute: "uploading to DB")
                for product in (productArray ?? []) { // updload product
                    try? await ProductManager.shared.createProduct(product: product)
                }
                
                trace?.stop()
            }catch {
                print(error)
            }
        }
    }
    
}

struct PerformanceView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
    }
}
