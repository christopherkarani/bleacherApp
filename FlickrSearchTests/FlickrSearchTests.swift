//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import XCTest
import UIKit
import TagListView
@testable import FlickrSearch

class FlickrSearchTests: XCTestCase {
    
    var viewController: FlickrViewController!

    
    func testUrlResource() {
        let url = URL(string: fakeAPIString)!
        let resource = CodableResource<FlickrImage>(url: url)
        XCTAssertEqual(url, resource.url)
    }
    
    func testResourceParseData() {
        let url = URL(string: fakeAPIString)!
        let resource = CodableResource<TestObject>(url: url)
        let entry = resource.parse(singleTestData!)!
        XCTAssertEqual(entry.api, "Cat Facts")
        XCTAssertEqual(entry.description, "Daily cat facts")
        XCTAssertEqual(entry.auth, true)
        XCTAssertEqual(entry.http, true)
        XCTAssertEqual(entry.able, "no")
        XCTAssertEqual(entry.link, "https://alexwohlbruck.github.io/cat-facts/")
        XCTAssertEqual(entry.category, "Animals")
    }
    
    func testDataTaskRequest() throws {
        let url = URL(string: realAPIString)!

        TinyHTTPStubURLProtocol.urls[url] = StubbedResponse(response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, data: multipleTestData!)

        let endpoint = CodableResource<RealObjectContainer>.init(url: url)
        let expectation = self.expectation(description: "Stubbed network call")

        URLSession.shared.load(endpoint) { result in
            switch result {
            case let .success(payload):
                let entries = payload.entries
                XCTAssertEqual(payload.count, 681)
                XCTAssertEqual(entries[2].API, "Dogs")
                XCTAssertEqual(entries[1].Description, "Pictures of cats from Tumblr")
                XCTAssertEqual(entries[0].HTTPS, true)
                
                expectation.fulfill()
            case let .failure(error):
                XCTFail(String(describing: error))
            }
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func testHasACollectionView() {
        XCTAssertNotNil(viewController.collectionView)
    }
    
    func testCollectionViewHasDelegate() {
        XCTAssertNotNil(viewController.collectionView.delegate)
    }
    
    func testCollectionViewConfromsToCollectionViewDelegateProtocol() {
        XCTAssertTrue(viewController.conforms(to: UICollectionViewDelegate.self))
    }
    
    func testCollectionViewHasDataSource() {
        XCTAssertNotNil(viewController.collectionView.dataSource)
    }
    
    func testCollectionViewConformsToCollectionViewDataSourceProtocol() {
        XCTAssertTrue(viewController.conforms(to: UICollectionViewDataSource.self))
    }
    
    func testCollectionViewConformsToSearchBarDelegateProtocol() {
        XCTAssertTrue(viewController.conforms(to: UISearchBarDelegate.self))
    }
    
    func testCollectionViewConformsToFlowLayoutDelegateProtocol() {
        XCTAssertTrue(viewController.conforms(to: UICollectionViewDelegateFlowLayout.self))
    }
    
    func testCollectionViewConformsToTagListDelegateProtocol() {
        XCTAssertTrue(viewController.conforms(to: TagListViewDelegate.self))
    }
    
    func testEnsureSearchTextIsEmptyUponViewLoad() {
        XCTAssertEqual(viewController.searchText.value, "")
    }
    
    func testEnsureKeyboardIsNotActivUponViewLoad() {
        XCTAssertEqual(viewController.keyboardIsActive.value, false)
    }
    
    func testEnsureCollectionIsEmptyUponViewLoad() {
        XCTAssertEqual(viewController.images, [])
    }
    
    func testCollectionViewSetMessage() {
        let emptyMessageString = "EmptyMessage"
        viewController.collectionView.setEmptyMessage(emptyMessageString)
        let label : UILabel = viewController.collectionView?.backgroundView as! UILabel
        XCTAssertEqual(label.text, emptyMessageString)
    }
    
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let layout = UICollectionViewLayout()
        viewController = FlickrViewController(collectionViewLayout: layout)
        viewController.viewDidLoad()
    }
    
  

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        URLProtocol.unregisterClass(TinyHTTPStubURLProtocol.self)
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
