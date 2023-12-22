//
//  Query+EXT.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 06/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension Query {
    
    
    //    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Codable {
    //        let snapshot = try await self.getDocuments() // snapshot meaning all the products / documents it has now i.e [Product]
    //
    //        let products = try snapshot.documents.map({ document in // traverse on each document and create T type object
    //            try document.data(as: T.self)
    //        })
    //
    //        return products
    //
    //
    //        /*
    //         var productArray : [T] = []
    //
    //         for document in snapshot.documents {
    //         let product = try document.data(as: T.self)
    //         productArray.append(product)
    //         }
    //
    //         return productArray
    //         */
    //    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Codable {
        
        let (products, _) = try await self.getDocumentsWithSnapshot(as: type.self)
        
        return products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Codable {
        
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in // traverse on each document and create T type object
            try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    // addition of doucment count in cart collection then only this triggers and count is send on the publisher
    func addAggregateCountListener() -> (AnyPublisher<Int, Error> ,ListenerRegistration) {
        
        let publisher = PassthroughSubject<Int, Error>()

        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let count = querySnapshot?.count else {
                print("no count snapshot")
                return
            }
            
            publisher.send(count)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
    // addition of document in the product collection then only then only this listner fires itself, and then products are sent on publisher
    func addSnapshotListener<T: Decodable>(as type: T.Type) -> (AnyPublisher<[T], Error> , ListenerRegistration) {
        
        
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
             guard let documents = querySnapshot?.documents else {
                 print("NO Documents")
                 return
             }
                
             let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
             publisher.send(products) // <-- passing
         }
         
         return (publisher.eraseToAnyPublisher(), listener)
        
    }
    
}



