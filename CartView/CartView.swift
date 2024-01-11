//
//  CartView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 13/12/23.
//

import SwiftUI
import Razorpay

struct CartView: View {
    
    @StateObject var viewModel = CartViewModel()
    @State private var showScreen: Bool = false
    
    var body: some View {
        ScrollView{
            
            if viewModel.userCartProducts.count > 0 {
                ForEach(viewModel.userCartProducts, id: \.id.self) { document in
                    ProductCartCellViewBuilder(productDocument: document)
                        .environmentObject(viewModel)
                }
                Text("Total : $\(viewModel.total)")
                    .bold()
                    .padding(10)
            }else{
                Text("Your cart is empty")
            }
            
            // checkout to payment
            
            Button {
                showScreen.toggle()
            } label: {
                Text("Razorpay")
            }
            if(showScreen) {
                RazorpayViewRepresentable(razorKey: "rzp_test_uHqob8OJkDcfWA")
            }
        }
        .navigationTitle(Text("My Cart"))
        .padding(.top)
        .onFirestAppear {
            viewModel.addListenerForCart()
        }
    }

}

/* example of UIViewControllerRepresentable
struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .brown
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
*/

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
