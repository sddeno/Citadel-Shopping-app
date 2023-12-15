//
//  RootView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 14/05/23.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        
        ZStack{
            if !showSignInView {
                NavigationStack{
//                    ProductView()
//                    ProfileView(showSignInView: $showSignInView)
                    TabbarView(showSignInView: $showSignInView)
//                    CrashView()
//                    PerformanceView()
                    
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticationUser()
            self.showSignInView = authUser == nil ? true: false
            
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
