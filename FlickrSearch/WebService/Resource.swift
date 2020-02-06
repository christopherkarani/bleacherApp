//
//  Resource.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import Foundation

/// Create a new Resource.
///
/// - Parameters:
///   - url: the endpoint's URL
///   - parse: this converts a response into an `A`.
public protocol Resource {
    /// target Url
    var url: URL { get }
    
    associatedtype T
    
    /// Transformation on some data returning a type T
    var parse : (Data) -> T? { get }
}


/// A Resource For Codable Objects
public struct CodableResource<T: Codable>: Resource {
    public let url: URL
    public var parse: (Data) -> T?
}


/// convinience initializer
extension CodableResource where T: Codable {
    init(url: URL) {
        self.init(url: url) { data in
            print(url.absoluteString)
            return try! JSONDecoder().decode(T.self, from: data)
        }
    }
}

extension CodableResource {
    init(searchText: String, pageNumber: Int) {
        let urlString = String(format: FlickrConstants.searchURL, searchText, pageNumber)
        let url = URL(string: urlString) ?? URL(string: "")!
        self.init(url: url)
    }
}



// convinience initializer on url request
extension URLRequest {
    init<R: Resource>(resource: R) {
        self.init(url: resource.url)
        // for this example we'll assume all requests are "GET" requests
        self.httpMethod = "GET"
    }
}
