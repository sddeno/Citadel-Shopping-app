//
//  ProfileViewModel.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 07/06/23.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
        self.user = try await UserManger.shared.getUser(userId: authDataResult.uid)
    }
    
    // PUT
    //    func togglePremiumStatus() {
    //        guard var user else { return }
    //        user.togglePremiumStatus()
    //        Task {
    //            try await UserManger.shared.updateUserPremiumStates(user: user)
    //            self.user = try await UserManger.shared.getUser(userId: user.userId)
    //        }
    //    }
    
    // PATCH
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        
        Task {
            try await UserManger.shared.updateUserPremiumStates(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManger.shared.getUser(userId: user.userId)
        }
    }
    
    func addUserPrefrence(text: String){
        guard let user else { return }
        Task{
            try await UserManger.shared.addUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManger.shared.getUser(userId: user.userId)
        }
    }
    func removeUserPrefrence(text: String){
        
        guard let user else { return }
        Task{
            try await UserManger.shared.removeUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManger.shared.getUser(userId: user.userId)
        }
    }
    
    func addFavoriteMovie(){
        
        guard let user else { return }
        let movie = Movie(id: "1", title: "FastX", isPopular: true)
        Task{
            try await UserManger.shared.addFavoriteMovie(userId: user.userId, favoriteMovie: movie)
            self.user = try await UserManger.shared.getUser(userId: user.userId)
        }
    }
    func removeFavoriteMovie(){
        
        guard let user else { return }
        
        Task{
            try await UserManger.shared.removeFavoriteMovie(userId: user.userId)
            self.user = try await UserManger.shared.getUser(userId: user.userId)
        }
    }
    
    func saveProfileImage(item: PhotosPickerItem){
        
        guard let user else { return }
        Task{
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
            let (path,name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            print("Success image upoaded to Storage")
            print(path)
            print(name)
            
            let url = try await StorageManager.shared.getUrlForImage(path: path) // get URL for image so that we can use AsyncImage
            
            try await UserManger.shared.updateUserProfileImagePath(userId: user.userId, pathUrl: url.absoluteString, path: path ) // update user's profile
            // instead of updating user's profile not path but url for that path 
        }
    }
    
    func deleteProfileImage() {
        
        guard let user, let path = user.profileImagePath else { return }
       
        Task{
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManger.shared.updateUserProfileImagePath(userId: user.userId, pathUrl: nil, path: nil)
        }
    }
    

}
