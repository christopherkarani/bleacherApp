//
//  File.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import Foundation

struct FlickrResponseContainer: Codable {
    var photos: FlickrResponse
    var stat: String
}

struct FlickrResponse: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [FlickrImage]
    let total: String
}
