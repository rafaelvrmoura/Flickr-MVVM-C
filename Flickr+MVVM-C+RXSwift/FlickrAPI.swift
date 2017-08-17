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
import Moya

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

// Flickr API endpoints
enum Flickr {
    case services
    case rest(FlickrMethod)
}

// Flickr API methods
enum FlickrMethod {
    
    var methodParameters: [String: Any] {
        
        var parameters: [String: Any] = [:]
        
        switch self {
        case .getRecent(let extras, let count, let page):
            parameters["method"] = "flickr.photos.getRecent"
            parameters["extras"] = extras.string()
            parameters["per_page"] = count
            parameters["page"] = page
        }
        
        return parameters
    }
    
    // Resturns the latest uploaded photos
    case getRecent(extras: [ExtraArgument], perPage: Int, page: Int)
}

// MARK: - Flickr extension that provides lazy static attributes to API keys.
extension Flickr {
    private static var keysDict: NSDictionary = {
        guard let keysPlistPath = Bundle.main.path(forResource: "FlickrKeys", ofType: "plist"),    let keysDict = NSDictionary(contentsOfFile: keysPlistPath) else {
            fatalError("Missing FlickrKeys.plist file")
        }
        
        return keysDict
    }()
    
    static var apiKey: String? = {
        return keysDict["api_key"] as? String
    }()
    
    static var secret: String? = {
        return keysDict["secret"] as? String
    }()
}

// MARK: - Flickr implementation for Moya's TargetType protocol
extension Flickr: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.flickr.com")!
    }
    
    var path: String {
        
        switch self {
        case .services:
            return "/services"
        case .rest:
            return "/services/rest"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        
        var parameters: [String: Any] = ["api_key": Flickr.apiKey ?? ""]
        
        switch self {
        case .services:
            return nil
        case .rest(let flickrMethod):
            parameters += flickrMethod.methodParameters
        }
        
        return parameters
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }

    var validate: Bool {
        return false
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

// MARK: - Operators overloading for dictionaries.
func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    
    var map = Dictionary<K,V>()
    
    for (k, v) in left {
        map[k] = v
    }
    
    for (k, v) in right {
        map[k] = v
    }
    
    return map
}

func += <K,V>(left: inout Dictionary<K,V>, right: Dictionary<K,V>) {
    
    right.forEach { (key, value) in
        left[key] = value
    }
}


