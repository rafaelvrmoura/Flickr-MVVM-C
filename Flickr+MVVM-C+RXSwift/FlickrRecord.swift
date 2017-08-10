//
//  FlickrRecord.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 10/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import AEXML

enum XMLPArseError: Error {
    
    case badXMLFormat(message: String)
}

struct FlickrRecord {

    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: String
    var title: String
    
    var thumbnailURL: URL?
    
    init(with xmlElement: AEXMLElement) throws {
        
        let attributes = xmlElement.attributes
        
        guard let id = attributes["id"] else {
            throw XMLPArseError.badXMLFormat(message: "Missing expected 'id' attribute")
        }
        
        guard let owner = attributes["owner"] else {
            throw XMLPArseError.badXMLFormat(message: "Missing expected 'owner' attribute")
        }
        
        guard let secret = attributes["secret"] else {
            throw XMLPArseError.badXMLFormat(message: "Missing expected 'secret' attribute")
        }
        
        guard let server = attributes["server"] else {
            throw XMLPArseError.badXMLFormat(message: "Missing expected 'server' attribute")
        }
        
        guard let farm = attributes["farm"] else {
            throw XMLPArseError.badXMLFormat(message: "Missing expected 'farm' attribute")
        }
        
        guard let title = attributes["title"] else {
            throw XMLPArseError.badXMLFormat(message: "Missing expected 'title' attribute")
        }
        
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        
        if let thumbnailURLString = attributes["url_t"] {
            self.thumbnailURL = URL(string: thumbnailURLString)
        }
    }
}
