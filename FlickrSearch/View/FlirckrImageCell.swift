//
//  FlirckrImageCell.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import UIKit
import Kingfisher


class FlirckrImageCell: UICollectionViewCell {
    var flickrImage: FlickrImage! {
        didSet {
            setupUI()
        }
    }
    let imageView = UIImageView()
    let errorLabel = UILabel()
    
    
    private func setupUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(errorLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.text = "Error"
        errorLabel.isHidden = true
        
        imageView.kf.indicatorType = .activity
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: topAnchor),
            errorLabel.leftAnchor.constraint(equalTo: leftAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        do {
            let url =  try flickrImage.imageUrl(size: .thumbnail)
            imageView.kf.setImage(with: url)
        } catch let error as WebserviceError {
            imageView.isHidden = true
            errorLabel.isHidden = false
            
            #if DEBUG
            fatalError(error.debugDescription)
            #endif
        } catch {
            print("Error at \(#file): \(error.localizedDescription)")
        }
    }
}


extension FlirckrImageCell {
    static let cellID = "FlirckrImageCell.id"
}

