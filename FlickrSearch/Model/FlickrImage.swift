//
//  FlickrImage.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import Foundation

enum ImageSize {
    case thumbnail
    case medium
    case large
}



struct FlickrImage: Codable, Equatable {
    let farm : Int
    let id : String
    let isfamily : Int
    let isfriend : Int
    let ispublic : Int
    let owner: String
    let secret : String
    let server : String
    let title: String
    
    
    func imageUrl(size: ImageSize) throws -> URL {
        var urlString: String
        switch size {
        case .thumbnail:
            urlString = FlickrConstants.thumbnailImageURL
        case .large:
            urlString = FlickrConstants.largeImageURL
        case .medium:
            urlString = FlickrConstants.mediumImageURL
        }
        let urlStringFormat = String(format: urlString, farm, server, id, secret)
        if let url = URL(string: urlStringFormat) {
            return url
        } else {
            throw WebserviceError.errorImageUrl(url: "URL: \(urlString)")
        }
    }
}


