//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import TagListView



class FlickrViewController: UICollectionViewController {
    lazy var searchBar = UISearchBar(frame: .zero)
    let searchHistoryView = SearchHistoryView()
    var searchTermHistory: [String] = []
    private(set) var photoArray = [FlickrImage]()
    let searchText = BehaviorRelay(value: "")
    private var pageNumbers = (first: 1, next: 2)
    private let disposeBag = DisposeBag()
    var searchHistoryViewBottomAnchor: NSLayoutConstraint!
    var keyboardIsActive = BehaviorRelay(value: false)
    var keyboardHeightValue: CGFloat = 0

        // data source
        var images = [FlickrImage]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.backgroundColor = .white
            navigationItem.titleView = searchBar
            searchBar.delegate = self
            setupCells()
            rxSearchBarSetup()
            setupSearchHistoryiew()
            setupRxKeyboard()
            searchHistoryView.taglistView.delegate = self
        }
    
    private func setupSearchHistoryiew()  {
        view.addSubview(searchHistoryView)
        searchHistoryView.backgroundColor = .init(white: 0.94, alpha: 1)
        searchHistoryView.translatesAutoresizingMaskIntoConstraints = false
        searchHistoryViewBottomAnchor = searchHistoryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            searchHistoryViewBottomAnchor!,
            searchHistoryView.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchHistoryView.heightAnchor.constraint(equalToConstant: 50),
            searchHistoryView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
        
        /// Register Custom Cells
        private func setupCells() {
            collectionView.register(FlirckrImageCell.self, forCellWithReuseIdentifier: FlirckrImageCell.cellID)
        }
    
    
    private func setupRxKeyboard() {
        keyboardIsActive.asObservable()
            .distinctUntilChanged()
            .bind { (active) in
                if active {
                    self.searchHistoryView.isHidden = false
                    print(-self.keyboardHeightValue)
                    self.searchHistoryViewBottomAnchor.isActive = false
                    self.searchHistoryViewBottomAnchor.constant = -self.keyboardHeightValue + 31
                    self.searchHistoryViewBottomAnchor.isActive = true
                } else {
                    self.searchHistoryView.isHidden = true
                    self.searchHistoryViewBottomAnchor.isActive = false
                    self.searchHistoryViewBottomAnchor.constant = 0
                    self.searchHistoryViewBottomAnchor.isActive = true
                }
        }.disposed(by: disposeBag)
        
        keyboardHeight()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .bind(onNext: { (height) in
                self.keyboardHeightValue = height
            })
            .disposed(by: disposeBag)
    }
    
    
    private func rxSearchBarSetup() {
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .throttle(3, scheduler: MainScheduler.instance)// Wait 3 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { $0.count > 2 } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.searchText.accept(query)
                self.searchHistoryView.addTagToStack(string: query)
                self.retrieveData(searchText: query, nextPage: false) // We now do our "API Request" to find cities.
            })
            .disposed(by: disposeBag)
        
    }
        
        
        /// used to retrieve data from the API.
    private func retrieveData(searchText: String, nextPage: Bool) {
        let page = nextPage ? pageNumbers.first : pageNumbers.next
        let resource = CodableResource<FlickrResponseContainer>(searchText: searchText, pageNumber: page)
            // very quickly we've devloped a scalable api for handle our network requests
            URLSession.shared.load(resource) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    let photos = response.photos.photo
                    if !nextPage {
                         self.images.removeAll()
                    }
                   
                    self.images.append(contentsOf: photos)
                    
                    // back to the main thread
                    DispatchQueue.main.async { [unowned self] in
                        self.collectionView.reloadData()
                    }
                    print(self.images.count)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                print("done")
            }
        }
    }




    extension FlickrViewController: UICollectionViewDelegateFlowLayout {
        /// number of cells to display
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print(images.count)
            return images.count
        }
        
        /// handles cell sizing, currently has an arbitrary size
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfColumns : CGFloat = 3
            return CGSize(width: (collectionView.bounds.width - 2)/numberOfColumns, height: (collectionView.bounds.width - 2)/numberOfColumns)
        }
        /// rendering of the cell
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let flickrImage = images[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlirckrImageCell.cellID, for: indexPath) as! FlirckrImageCell
            cell.flickrImage = flickrImage
            
            if indexPath.row == (images.count - 10) {
                retrieveData(searchText: searchText.value, nextPage: true)
            }
            return cell
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let image = images[indexPath.item]
            let viewcontroller = FlickrImageDetailViewController()
            viewcontroller.flckrImage = image
            navigationController?.pushViewController(viewcontroller, animated: true)
        }
}



extension FlickrViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        keyboardIsActive.accept(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        keyboardIsActive.accept(false)
        searchBar.searchTextField.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 2 {
            searchHistoryView.addTagToStack(string: text)
        }
        searchBar.searchTextField.text = nil
        searchBar.resignFirstResponder()
        keyboardIsActive.accept(false)
    }
}

extension FlickrViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        searchBar.searchTextField.text = title
        tagView.isSelected = true
        searchText.accept(title)
    }
}
