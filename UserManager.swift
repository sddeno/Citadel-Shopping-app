//
//  UserManager.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 26/05/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine




struct Movie : Codable { // we have to create coding keys for movie as well other wise it won't be able to encode and decode
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser : Codable {
    let userId: String
    let isAnonymous: Bool?
    let eamil: String?
    let photoUrl: String?
    let date_created: Date?
    var isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.eamil = auth.email
        self.photoUrl = auth.photoUrl
        self.date_created = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }

    init(userId: String, isAnonymous: Bool?, eamil: String?, photoUrl: String?, date_created: Date?, isPremium: Bool?, preferences: [String]?, favoriteMovie: Movie, profileImagePath: String?, profileImagePathUrl: String?) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.eamil = eamil
        self.photoUrl = photoUrl
        self.date_created = date_created
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
    
    
//    func togglePremiumStatus() -> DBUser{
//        let currentValue = isPremium ?? false
//
//        let updatedUser = DBUser(
//            userId: userId,
//            isAnonymous: isAnonymous,
//            eamil: eamil,
//            photoUrl: photoUrl,
//            date_created: date_created,
//            isPremium: !currentValue
//        )
//
//        return updatedUser
//    }
    
//    mutating func togglePremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    
    // our own encoder and decoder for our own key style
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case eamil = "email"
        case photoUrl = "photo_url"
        case date_created = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favoriteMovie"
        case profileImagePath = "profileImagePath"
        case profileImagePathUrl = "profileImagePathUrl"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.eamil = try container.decodeIfPresent(String.self, forKey: .eamil)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.date_created = try container.decodeIfPresent(Date.self, forKey: .date_created)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.eamil, forKey: .eamil)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.date_created, forKey: .date_created)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
    }
}


final class UserManger {
    
    
    static let shared = UserManger()
    private init() {}
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    private var userFavoriteProductsListner: ListenerRegistration? = nil
    private var userCartProductsListner: ListenerRegistration? = nil
    private var aggregateCountListener: ListenerRegistration? = nil
    
    // MARK: Firebase CollectionReference(User, Favorite, Cart) and their DocumentReference Methods
    
    // User Document Refernce
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // Favourite Collection Refernce
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    // Favorite Document Refernce
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    // Cart Collection Refernce
    private func userCartCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("Cart")
    }
    // Cart Document Refernce
    private func userCartProductDocument(userId: String, CartProductId: String) -> DocumentReference {
        userCartCollection(userId: userId).document(CartProductId)
    }

    
    
    // no need of external encoder and decoder, we are gonna use coding keys for our custom key style, that's why commenting
     
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase // ase our userData is key: Value i.e key is user_id <- this is snakecase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase // while decoding - convert from snake case
        return decoder
    }()
     
    
    
    // MARK: - User Methods
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false) //, encoder: encoder)
    }
    
    func createNewUser(auth: AuthDataResultModel) async throws { // email will becoem document ID of user // keys are in snake case
//        var userData: [String: Any] = [
//            "user_id" : auth.uid,
//            "is_anonymous" : auth.isAnonymous,
//            "date_created" : Timestamp(), // fireaase's timestamp
//        ]
//
//        if let email = auth.email {
//            userData["email"] = email
//        }
//
//        if let photoUrl = auth.photoUrl {
//            userData["photo_url"] = photoUrl
//        }
//
//
//
//        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false) // merge- if user exist it updates otherwise creates
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self) //, decoder: decoder) // y commenting? - using custome coding keys
    }
    
//    func getUser(userId: String) async throws -> DBUser {
//
//        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
//
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {   // will convert into dictionary like above userData
//            throw URLError(.badServerResponse)
//        }
//
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let eamil = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let date_created = data["data_created"] as? Date // pushing as firebase's timestamp and now pulling as swift's Date
//        
//        return DBUser(userId: userId, isAnonymous: isAnonymous, eamil: eamil, photoUrl: photoUrl, date_created: date_created)
//    }
    
    
//    func updateUserPremiumStates(user: DBUser) async throws {
//         try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder) // NOTE : merge is true in update() // PUT
//    }
    
    func updateUserPremiumStates(userId: String, isPremium: Bool) async throws {
      
        let data: [String: Any] = [
//            "user_isPremium" : isPremium // be careful you write the key given in JSON and same in struct
            DBUser.CodingKeys.isPremium.rawValue : isPremium,
//            "custom_key" : "123"
        ]

        try await userDocument(userId: userId).updateData(data) // update the specific fields only // PATCH
    }
    
    
    func updateUserProfileImagePath(userId: String, pathUrl: String?, path: String?) async throws {
      
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePathUrl.rawValue : pathUrl,
            DBUser.CodingKeys.profileImagePath.rawValue: path
        ]

        try await userDocument(userId: userId).updateData(data) // update the specific fields only // PATCH
    }
    
    func addUserPreference(userId: String, preference: String) async throws{
        let data: [String:Any] = [
//            DBUser.CodingKeys.preferences.rawValue : [preference]
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data) // PATCH
    }
    
    func removeUserPreference(userId: String, preference: String) async throws{
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userId: userId).updateData(data) // PATCH
    }
    
    func addFavoriteMovie(userId: String, favoriteMovie: Movie) async throws{
        guard let data = try? encoder.encode(favoriteMovie) else {
            throw URLError(.badURL)
        }
        
        let dict: [String:Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : data
        ]
        try await userDocument(userId: userId).updateData(dict) // PATCH
    }
    
    func removeFavoriteMovie(userId: String) async throws{
        let data: [String:Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : nil
        ]
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any]) // PATCH
    }
    
    
    
    
    
    // MARK: + and - Favourite
    
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        
        let document = userFavoriteProductCollection(userId: userId).document() // blank document - document with auto id
        let documentId = document.documentID // make auto id part of fields
        
        let data: [String: Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue : documentId,
            UserFavoriteProduct.CodingKeys.productId.rawValue : productId,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
    
        try await document.setData(data, merge: false)
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
     
    func getAlluserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() { // usually return listner to view and hold it there till the time we need it // not used only defined
        self.userFavoriteProductsListner?.remove()
    }
    
//    func addListnerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ poducts: [UserFavoriteProduct]) -> Void) {
//
//        // we should make it publisher but we are returning using completion - we can convert this funct into pubisher
//        // so that we can subscribe to it as it's a listener
//        var listener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("NO Documents")
//                return
//            }
//
//            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
//            completion(products)
//
//        // to konw what changed in document of collection - remember : it dont update UI if field value is changed unless you reload UI
//            querySnapshot?.documentChanges.forEach { diff in
//                if (diff.type == .added) {
//                    print("New products: \(diff.document.data())")
//                }
//                if (diff.type == .modified) {
//                    print("Modified products: \(diff.document.data())")
//                }
//                if (diff.type == .removed) {
//                    print("Removed products: \(diff.document.data())")
//                }
//            }
//        }
//        self.userFavoriteProductsListner = listener
//    }
   
    
//    func addListnerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
//       let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
//
//        self.userFavoriteProductsListner = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("NO Documents")
//                return
//            }
//
//            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
//            publisher.send(products) // <-- passing
//        }
//
//        return publisher.eraseToAnyPublisher()
//    }
    
    
    func addListnerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId)
            .addSnapshotListener(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductsListner = listener
        return publisher // can return listener also along with it usually
    }
    
    
    
    
    
    // MARK: + - Product to Cart
    
    func addUserCartProduct(userId: String, productId: Int) async throws {
        let document = userCartCollection(userId: userId).document() // blank document - document with auto id
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserCartProduct.CodingKeys.id.rawValue : documentId,
            UserCartProduct.CodingKeys.productId.rawValue : productId,
            UserCartProduct.CodingKeys.dateCreated.rawValue : Timestamp()
        ]
        try await document.setData(data, merge: false)
    }
    
    func removeUserCartProduct(userId: String, productId: String) async throws {
        try await userCartProductDocument(userId: userId, CartProductId: productId).delete()
    }
    
    func addListnerForAllUserCartProducts(userId: String) -> AnyPublisher<[UserCartProduct], Error> {
        let (publisher, listener) = userCartCollection(userId: userId).addSnapshotListener(as: UserCartProduct.self)
        
        self.userCartProductsListner = listener
        return publisher
    }
    
    
    
    // MARK: Cart count
    
    func addAggregateCountListener(userId: String) -> AnyPublisher<Int, Error> {
        let (publisher, listener) = userCartCollection(userId: userId).addAggregateCountListener()
        self.aggregateCountListener = listener
        return publisher
    }
    
    func userCartCount(userId: String) async throws -> Int {
        return try await userCartCollection(userId: userId).aggregateCount()
    }
    
}

// MARK: - Coable for Collection Favorite, Cart
struct UserFavoriteProduct: Codable {
    
    let id: String
    let productId: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
}

struct UserCartProduct: Codable {
    
    let id: String
    let productId: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
}
