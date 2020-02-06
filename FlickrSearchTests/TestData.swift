//
//  TestData.swift
//  FlickrSearchTests
//
//  Created by Chris Karani on 06/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//
import Foundation


let fakeAPIString: String = "https://fake.api.com/images"
let realAPIString: String = "https://api.publicapis.org/entries"

struct RealObjectContainer: Codable {
    let count: Int
    let entries: [RealObject]
}

struct RealObject: Codable {
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: String
    let Category: String
}

struct TestObject: Codable {
    let api: String
    let description: String
    let auth: Bool
    let http: Bool
    let able: String
    let link: String
    let category: String
}


let singleTestData = """
    {
        "api": "Cat Facts",
        "description": "Daily cat facts",
        "auth": true,
        "http": true,
        "able": "no",
        "link": "https://alexwohlbruck.github.io/cat-facts/",
        "category": "Animals"
    }
""".data(using: .utf8)

let multipleTestData = """
        {
    "count":3,
    "entries":[
       {
          "API":"Cat Facts",
          "Description":"Daily cat facts",
          "Auth":"",
          "HTTPS":true,
          "Cors":"no",
          "Link":"https://alexwohlbruck.github.io/cat-facts/",
          "Category":"Animals"
       },
       {
          "API":"Cats",
          "Description":"Pictures of cats from Tumblr",
          "Auth":"apiKey",
          "HTTPS":true,
          "Cors":"unknown",
          "Link":"https://docs.thecatapi.com/",
          "Category":"Animals"
       },
       {
          "API":"Dogs",
          "Description":"Based on the Stanford Dogs Dataset",
          "Auth":"",
          "HTTPS":true,
          "Cors":"yes",
          "Link":"https://dog.ceo/dog-api/",
          "Category":"Animals"
       }]}
""".data(using: .utf8)
