//
//  CartButton.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 12/12/23.
//


import SwiftUI

struct CartButton: View {
    
    let numberOfProducts: Int
    
    var body: some View {
        Image("CartToolBar")
            .resizable()
            .frame(width: 35, height: 35)
            .overlay(alignment: .topTrailing) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Text("\(numberOfProducts)")
                        
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
            }
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton(numberOfProducts: 0)
    }
}
