//
//  WebserviceError.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import Foundation

enum WebserviceError: Error {
    case notAuthenticated
    case other(description: String)
    case general(String)
    case statusCodeError(Int)
    case errorImageUrl(url: String)
}

extension WebserviceError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .errorImageUrl(url: let urlString):
            return urlString
        case .other(description: let description):
            return "Description \(description)"
        case .notAuthenticated:
            return "Not Authenticated"
        case .general(let description):
            return "General \(description)"
        case .statusCodeError(let code):
            return "Status Code Error: \(String(code))"
        }
    }
    
    
}

func logError<A>(_ result: Result<A, WebserviceError>) {
    guard case .failure(let e) = result else { return }
    assert(false, "\(e)")
}
