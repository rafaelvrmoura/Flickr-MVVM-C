//
//  FickerService.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 09/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import AEXML
import RxSwift
import RxCocoa

enum ExtraArgument: String {
    case description
    case license
    case date_upload
    case date_taken
    case owner_name
    case icon_server
    case original_format
    case last_update
    case geo
    case tags
    case machine_tags
    case o_dims
    case views
    case media
    case path_alias
    case url_sq
    case url_t
    case url_s
    case url_q
    case url_m
    case url_n
    case url_z
    case url_c
    case url_l
    case url_o
}

class FlickrService: NSObject {

    private let baseURL: String
    private let secret: String?
    private let apiKey: String?
    
    private var session: URLSession
    
    init(with session: URLSession = .shared) {
        baseURL = "https://api.flickr.com/services/rest/"
        self.session = session
        
        // Searching for FlickrKeys.plist file to load the secret and api key.
        // If you don't have flickr keys go to https://www.flickr.com/services/apps/create/apply/? and request one
        guard let keysPlistPath = Bundle.main.path(forResource: "FlickrKeys", ofType: "plist"),    let keysDict = NSDictionary(contentsOfFile: keysPlistPath) else {
            fatalError("Missing FlickrKeys.plist file")
        }
    
        // Reading the two keys into the .plist file.
        secret = keysDict["secret"] as? String
        apiKey = keysDict["api_key"] as? String
        
        super.init()
    }
    
    func getRecent(with extras: [ExtraArgument], count: Int, page: Int) -> Observable<[FlickrRecord]>? {
        
        guard var requestURL = URL(string: baseURL) else {
            return nil
        }
        
        let params = ["method":"flickr.photos.getRecent",
                      "api_key":(apiKey ?? ""),
                      "per_page": "\(count)",
                      "extras": extras.string()]
        
        requestURL.append(params)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request).flatMap({ (data) -> Observable<[FlickrRecord]> in
            
            let xml = try? AEXMLDocument(xml: data)
            let root = xml?.root
            
            var flickrRecords: [FlickrRecord] = []
            
            if let photosElement = root?.children.first {
                
                for photoElement in photosElement.children {
                    let record = try FlickrRecord(with: photoElement)
                    flickrRecords.append(record)
                }
            }
            
            return Observable.just(flickrRecords)
        })
    }
}

// MARK: - Array with ExtrarArguments elements extension
extension Array where Element == ExtraArgument {
    func string() -> String {
        let rawValues = self.map { return $0.rawValue}
        return rawValues.joined(separator: ",")
    }
}

// MARK: - URL Parameters appending extension
extension URL {
    
    mutating func append(_ parameters: [String:String]) {
        
        var urlString = absoluteString
        if urlString.characters.last != "?" {
            urlString.append("?")
        }
        
        let paramElements = parameters.map { return "\($0)=\($1)" }
        let paramsString = paramElements.joined(separator: "&")
        
        urlString.append(paramsString)
        
        self = URL(string: urlString)!
    }
}


