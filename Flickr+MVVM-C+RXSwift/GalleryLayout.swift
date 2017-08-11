//
//  GalleryLayout.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 11/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit

class GalleryLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var collectionViewContentSize: CGSize {
        return .zero
    }
    
    override func prepare() {
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return nil
    }
}

protocol GalleryLayoutDelegate {
    
}
