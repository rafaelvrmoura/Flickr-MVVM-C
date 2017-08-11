//
//  ViewController.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 04/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryViewController: UICollectionViewController {

    var flickrRecords: [FlickrRecord] = []
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = FlickrService()
        let results = service.getRecent(with: [.url_t], count: 10, page: 1)
        results?.subscribe({ (event) in
            print(event.element ?? "Nothing")
        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

