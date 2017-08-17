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
import Moya

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = RxMoyaProvider<Flickr>()
        let results = provider.request(.rest(.getRecent(extras: [.url_t], perPage: 10, page: 1)))
        
        results.map { (response) -> [FlickrRecord] in
        
            guard let flickrResponse = try? FlickrResponse(xml: response.data), let photos = flickrResponse.photosRecords  else {
                return []
            }
            
            return photos
            
        }.bindTo(collectionView.rx.items(cellIdentifier: "photoCell", cellType: GalleryViewCell.self)) { indexPath, flickrRecord, cell in
                
                guard let photoURL = flickrRecord.thumbnailURL, let thumbnailData = try? Data(contentsOf: photoURL) else {
                    return
                }
                cell.photoView.image = UIImage(data: thumbnailData)
                
        }.disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

