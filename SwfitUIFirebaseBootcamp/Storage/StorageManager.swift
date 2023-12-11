//
//  StorageManager.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 07/06/23.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference() // root storage
    
    private init() {}
    
    private var imagesReference: StorageReference {
        storage.child("images") // Folder in root storage
    }
    
    private func userReference(userId: String) -> StorageReference { // folder inside folder - userid named folder inside folder named "users"
        storage.child("users").child(userId)
    }
    
    func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    func getUrlForImage(path: String) async throws -> URL{
        try await getPathForImage(path: path).downloadURL()
    }
    
    /* no need as we have converted picker image into URL while picking and url.absoluteString() is stored in user's profile
     
//    func getData(userId: String, path: String) async throws -> Data {
////        try await userReference(userId: userId).child(path).data(maxSize: 3 * 1024 * 1024)
//        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
//    }
    
//    func getImage(userId: String, path: String) async throws -> UIImage {
//        let data = try await getData(userId: userId, path: path)
//
//        guard let image = UIImage(data: data) else {
//            throw URLError(.badURL)
//        }
//        return image
//    }
    
     */
    
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        
        let returnedMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badURL)
        }
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage, userId: String) async throws -> (path: String, name: String){
        //image.pngData()
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.badURL)
        }
        
        return try await saveImage(data: data, userId: userId)
    }
    
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
}
