//
//  TabbarView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 02/06/23.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView{
            NavigationStack{
                ProductView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }
            
            NavigationStack{
                FavoriteView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorite")
            }
            
            NavigationStack{
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(showSignInView: .constant(true))
    }
}
