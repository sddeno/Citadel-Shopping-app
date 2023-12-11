//
//  SettingsView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 15/05/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                
                Task{
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
            
            Button(role: .destructive) {
                Task{
                    do{
                        try await viewModel.deleteAccount()
                        print("Account deleted")
                        showSignInView = true
                    }catch {
                        print("error deleting account \(error)")
                    }
                }
            } label: {
                Text("Delete Account")
            }

            
            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
            
        }
        .onAppear{
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    
    private var emailSection: some View {
        Section {
            
            Button("Reset password") {
                
                Task{
                    do {
                        try await viewModel.resetPassword()
                        print("Reset password :::")
                    }catch {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
            
            
            Button("Update password") {
                
                Task{
                    do {
                        try await viewModel.updatePassword()
                        print("Update password :::")
                    }catch {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
            Button("Update email") {
                
                Task{
                    do {
                        try await viewModel.updateEmail()
                        print("Update password :::")
                    }catch {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
        } header: {
            Text("Email Functions ")
        }
    }
    
    private var anonymousSection: some View {
        Section {
            
            Button("Link Email Account") {
                
                Task{
                    do {
                        try await viewModel.linkEmailAccount()
                        print("Linking email Done")
                    }catch {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
            
            
            Button("Link Google Account") {
                
                Task{
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("link google account Done ")
                    }catch {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
            
        } header: {
            Text("Create account")
        }
    }
}

