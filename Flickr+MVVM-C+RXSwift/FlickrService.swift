//
//  FickerService.swift
//  Flickr+MVVM-C+RXSwift
//
//  Created by Rafael Moura on 09/08/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import AEXML

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

    static let shared = FlickrService()
    private let baseURL: String
    private let secret: String?
    private let apiKey: String?
    
    private override init() {
        baseURL = "https://api.flickr.com/services/rest/"
        
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
    
    func getRecent(with extras: [ExtraArgument], count: Int, page: Int, completionHandler: @escaping ([FlickrRecord], Error?) -> ()) {
        
        guard var requestURL = URL(string: baseURL) else {
            return
        }
        
        let params = ["method":"flickr.photos.getRecent",
                      "api_key":(apiKey ?? ""),
                      "per_page": "\(count)",
                      "extras": extras.string()]
        
        requestURL.append(params)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else { return }
            
            let xml = try? AEXMLDocument(xml: data)
            let root = xml?.root
            
            var flickerRecords: [FlickrRecord] = []
            
            if let photosElement = root?.children.first {
                
                for photoElement in photosElement.children {
                    do {
                        let record = try FlickrRecord(with: photoElement)
                        flickerRecords.append(record)
                    }catch {
                        completionHandler([], error)
                    }
                }
            }
            
            completionHandler(flickerRecords, nil)
        }
        
        task.resume()
    }
}

// MARK: - Array extension with ExtrarArguments elements
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


