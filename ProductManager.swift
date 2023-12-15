//
//  ProductManager.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 30/05/23.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Products: Codable {
    
    var products : [Product]? = []
    var total    : Int?        = nil
    var skip     : Int?        = nil
    var limit    : Int?        = nil
    
    enum CodingKeys: String, CodingKey {
        
        case products = "products"
        case total    = "total"
        case skip     = "skip"
        case limit    = "limit"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        products = try values.decodeIfPresent([Product].self , forKey: .products )
        total    = try values.decodeIfPresent(Int.self        , forKey: .total    )
        skip     = try values.decodeIfPresent(Int.self        , forKey: .skip     )
        limit    = try values.decodeIfPresent(Int.self        , forKey: .limit    )
        
    }
    
    
    
    
}

struct Product: Identifiable, Codable, Equatable {
    
    var id                      : Int
    var title                   : String?   = nil
    var description             : String?   = nil
    var price                   : Int?      = nil
    var discountPercentage      : Double?   = nil
    var rating                  : Double?   = nil
    var stock                   : Int?      = nil
    var brand                   : String?   = nil
    var category                : String?   = nil
    var thumbnail               : String?   = nil
    var images                  : [String]? = []
    var multipleSelectionCount  : Int?      = nil
    
    enum CodingKeys: String, CodingKey {
        
        case id                     = "id"
        case title                  = "title"
        case description            = "description"
        case price                  = "price"
        case discountPercentage     = "discountPercentage"
        case rating                 = "rating"
        case stock                  = "stock"
        case brand                  = "brand"
        case category               = "category"
        case thumbnail              = "thumbnail"
        case images                 = "images"
        case multipleSelectionCount = "multipleSelectionCount"
        
    }
    
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: Int, title: String? = nil, description: String? = nil, price: Int? = nil, discountPercentage: Double? = nil, rating: Double? = nil, stock: Int? = nil, brand: String? = nil, category: String? = nil, thumbnail: String? = nil, images: [String]? = nil, multipleSelectionCount: Int? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
        self.multipleSelectionCount = multipleSelectionCount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id                 = try values.decode(Int.self      , forKey: .id                 )
        title              = try values.decodeIfPresent(String.self   , forKey: .title              )
        description        = try values.decodeIfPresent(String.self   , forKey: .description        )
        price              = try values.decodeIfPresent(Int.self      , forKey: .price              )
        discountPercentage = try values.decodeIfPresent(Double.self   , forKey: .discountPercentage )
        rating             = try values.decodeIfPresent(Double.self   , forKey: .rating             )
        stock              = try values.decodeIfPresent(Int.self      , forKey: .stock              )
        brand              = try values.decodeIfPresent(String.self   , forKey: .brand              )
        category           = try values.decodeIfPresent(String.self   , forKey: .category           )
        thumbnail          = try values.decodeIfPresent(String.self   , forKey: .thumbnail          )
        images             = try values.decodeIfPresent([String].self , forKey: .images             )
        multipleSelectionCount = try values.decodeIfPresent(Int.self, forKey: .multipleSelectionCount)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.discountPercentage, forKey: .discountPercentage)
        try container.encodeIfPresent(self.rating, forKey: .rating)
        try container.encodeIfPresent(self.stock, forKey: .stock)
        try container.encodeIfPresent(self.brand, forKey: .brand)
        try container.encodeIfPresent(self.category, forKey: .category)
        try container.encodeIfPresent(self.thumbnail, forKey: .thumbnail)
        try container.encodeIfPresent(self.images, forKey: .images)
        try container.encodeIfPresent(self.multipleSelectionCount, forKey: .multipleSelectionCount)
    }
}



class ProductManager {
    
    // Firebase Products CRUD
    
    static let shared = ProductManager()
    private init() {}
    let productCollection = Firestore.firestore().collection("products")
    
    
    private func productDocument(id: String) -> DocumentReference {
        return productCollection.document(id) // generateing document
    }
    
    func createProduct(product: Product) async throws {
        try productDocument(id: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(id: productId).getDocument(as: Product.self)
    }
    
    
    // refactoring - here we do this refactoring only when return type is [Product] we are running it on one collection and returning smae type of document that’s why refactoring
    
    //        private func getAllProduct() async throws -> [Product] {
    //            try await productCollection
    //                .limit(to:5)
    //                .getDocuments(as: Product.self)
    //        }
    
   
    //    private func getAllProductsSortedByPrice(descending: Bool = true) async throws -> [Product] {
    //        return try await productCollection
    //            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    //            .limit(to: 4)
    //            .getDocuments(as: Product.self)
    //    }
    
    
    //    private func getAllProductsForCategory(category: String) async throws -> [Product] {
    //        try await productCollection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category).getDocuments(as: Product.self)
    //    }
    //
    //    // INDEXING - in firebase is required to run multiple filters in one query
    //    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
    //        return try await productCollection
    //            .order(by: Product.CodingKeys.price.rawValue, descending: descending) // sort by price
    //            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category) // filter by cateogry
    //            .getDocuments(as: Product.self)
    //    }
    
    
    
    
    private func getAllProductQuery() -> Query {
        productCollection // there are no query that's why no filter here
    }
    
    private func getAllProductsSortedByPrice(descending: Bool = true) -> Query {
        productCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getAllProductsForCategory(category: String) -> Query {
        productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getAllProductsByPriceAndCategory(descending: Bool, category: String)  -> Query {
        productCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending) // sort by price
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category) // filter by cateogry
    }
    
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int?, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot? ){
        
        var query: Query = getAllProductQuery()
        
        if let descending, let category {
            query = getAllProductsByPriceAndCategory(descending: descending, category: category)
        }else if let descending{
            query = getAllProductsSortedByPrice(descending: descending)
        }else if let category {
            query = getAllProductsForCategory(category: category)
        }
        
        
        return try await query
            .limit(to: count ?? 999)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
        
        
        //        if let lastDocument {
        //                return try await query
        //                    .limit(to: count ?? 999)
        //                    .start(afterDocument: lastDocument)
        //                    .getDocumentsWithSnapshot(as: Product.self)
        //        }else{
        //            return try await query
        //                .limit(to: count ?? 999)
        //                .getDocumentsWithSnapshot(as: Product.self)
        //        }
    }
    
    // we won't refector getProductsByRating because we actually RUN query in it.
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?, lastRating: Double?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        
        //        if let lastDocument {
        //            // 2nd time fetching more 4 documents that comes after last document
        //            return try await productCollection
        //                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
        //                .limit(to: count)
        //                .start(afterDocument: lastDocument)
        //                .start(afterDocument: [lastRating ?? 999999])
        //                .getDocumentsWithSnapshot(as: Product.self)
        //        }else {
        //            // else block for 1st time fetching first count documents without having last Document
        //            return try await productCollection
        //                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
        //                .limit(to: count)
        //                .getDocumentsWithSnapshot(as: Product.self)
        //        }
        
        return try await productCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 99999])
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
    func getAllProductsCount() async throws -> Int {
        return try await productCollection.aggregateCount()
    }
    
    //    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
    //        if let descending, let category {
    //            return try await getAllProductsByPriceAndCategory(descending: descending, category: category)
    //        }else if let descending{
    //            return try await getAllProductsSortedByPrice(descending:xb descending)
    //        }else if let category {
    //            return try await getAllProductsForCategory(category: category)
    //        }
    //
    //        return try await getAllProduct()
    //    }
    
}
