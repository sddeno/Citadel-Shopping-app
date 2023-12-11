//
//  OnFirstAppearViewModifier.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 06/06/23.
//

import SwiftUI
import Foundation

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        
        content
            .onAppear(){
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    
    func onFirestAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
