//
//  SearchHistoryView.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//

import RxSwift
import RxCocoa
import TagListView


class SearchHistoryView: UIView {
    let taglistView = TagListView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(taglistView)
        taglistView.tagBackgroundColor = .systemOrange
        
        taglistView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taglistView.topAnchor.constraint(equalTo: topAnchor),
            taglistView.leadingAnchor.constraint(equalTo: leadingAnchor),
            taglistView.bottomAnchor.constraint(equalTo: bottomAnchor),
            taglistView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    public func addTagToStack(string: String) {
        taglistView.addTag(string)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
