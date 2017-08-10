//
//  ViewController.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 04/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         FlickrService.shared.getRecent(with: [.url_t], count: 10, page: 1) { (flickrRecords, error) in
            
            print(flickrRecords)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

