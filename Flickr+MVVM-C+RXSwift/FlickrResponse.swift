//
//  FlickrResponse.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 14/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import AEXML

enum FlickrResponseStatus: String {
    case success = "ok"
    case fail = "fail"
}

class FlickrResponse: AEXMLDocument {
    
    var status: FlickrResponseStatus {
        
        guard let attributeString = self.root.attributes["stat"], let status = FlickrResponseStatus(rawValue: attributeString) else { return .fail }
        
        return status
    }
    
    var photosRecords: [FlickrRecord]? {
        
        let root = self.root
        var flickrRecords: [FlickrRecord] = []
        
        // Wether the response wasn't from a photos request.
        guard let photosElement = root.children.first, photosElement.name == "photos" else { return nil
        }
            
        for photoElement in photosElement.children {
            if let record = try? FlickrRecord(with: photoElement) {
                flickrRecords.append(record)
            }
        }
    
        return flickrRecords
    }
}
