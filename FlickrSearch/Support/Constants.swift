//
//  Constants.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import Foundation


class FlickrConstants: NSObject {
    

    
    static func apiKey() -> String {
        return ProcessInfo.processInfo.environment["APIKEY"]!
    }
    
    //static let api_key = "1508443e49213ff84d566777dc211f2a"
    static let per_page = 60
    static let searchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrConstants.apiKey())&format=json&nojsoncallback=1&safe_search=1&per_page=\(FlickrConstants.per_page)&text=%@&page=%ld"
    static let thumbnailImageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_t.value).jpg"
    static let largeImageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_l.value).jpg"
    
//    static let mediumImageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_z.value).jpg"
    
        static let mediumImageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_s.value).jpg"
    
    enum size: String {
        case url_sq = "s"   //small square 75x75
        case url_q = "q"    //large square 150x150
        case url_t = "t"    //thumbnail, 100 on longest side **
        case url_s = "m"    //small, 240 on longest side
        case url_n = "n"    //small, 320 on longest side
        case url_m = "-"    //medium, 500 on longest side
        case url_z = "z"    //medium 640, 640 on longest side **
        case url_c = "c"    //medium 800, 800 on longest side† **
        case url_l = "b"    //large, 1024 on longest side **



        
        var value: String {
            return self.rawValue
        }
    }
    
  //  static let defaultColumnCount: CGFloat = 3.0
}
