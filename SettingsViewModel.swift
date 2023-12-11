//
//  SettingsViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 26/05/23.
//

import Foundation


@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil

    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProvider(){
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticationUser()
    }
    // link google account, fb, apple, email methiods will bring from manager and access it in view below
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticationUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist) // create custom error not his
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    
    func updateEmail() async throws {
        
        let email = "changedEmail@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        
        let password = "hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResults = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
        self.authUser = authDataResults
        
    }
    
    func linkEmailAccount() async throws {
       let email = "linkdingAllLogin@gmail.com"
        let password = "bingo123"
        let authDataResults = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
        self.authUser = authDataResults
        
    }
}
