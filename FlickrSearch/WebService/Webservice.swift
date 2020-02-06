//
//  Webservice.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import Foundation
import RxSwift

extension URLSession {
    
    /// Loads an endpoint by creating (and directly resuming) a data task.
    ///
    /// - Parameters:
    ///   - R: The resource.
    ///   - onComplete: The completion handler.
    func load<R: Resource>(_ resource: R, onComplete: @escaping (Result<R.T, WebserviceError>) -> ()) {
        let request = URLRequest(resource: resource)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Result<R.T, WebserviceError>
            guard let parsed = data.flatMap (resource.parse) else {
                // incase the data in corrupted
                onComplete(.failure(WebserviceError.other(description: "Data parsing Error")))
                return
            }
            result = .success(parsed)
            DispatchQueue.main.async { onComplete(result) }
        }.resume()
    }
    
    func loadObservable<R: Resource>(_ resource: R, onComplete: @escaping (Observable<R.T>) -> ()) {
        let request = URLRequest(resource: resource)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Observable<R.T>
            guard let parsed = data.flatMap (resource.parse) else {
                // incase the data in corrupted
                return
            }
            
            result = Observable.just(parsed)
        
            DispatchQueue.main.async { onComplete(result) }
        }.resume()
    }
}
