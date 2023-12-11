//
//  SignInEmailViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 26/05/23.
//

import Foundation



@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
       let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        try await UserManger.shared.createNewUser(auth: authDataResult) // just want to create profile when it create user and not again when signin with email in below method signIn() 
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
}
