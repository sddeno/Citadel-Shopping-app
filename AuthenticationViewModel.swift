//
//  AuthenticationViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 26/05/23.
//

import Foundation


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        let user = DBUser(auth: authDataResult)
        
        try await UserManger.shared.createNewUser(user: user)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManger.shared.createNewUser(user: user)
        
//      try await UserManger.shared.createNewUser(auth: authDataResult)
    }
    
    
    
}
