//
//  FlickrImageDetailViewController.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import UIKit

class FlickrImageDetailViewController: UIViewController {
    
    let imageView = UIImageView()
    var flckrImage : FlickrImage! {
        didSet {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: try! flckrImage.imageUrl(size: .large))
            imageView.contentMode = .scaleAspectFit
            navigationItem.title = flckrImage.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
