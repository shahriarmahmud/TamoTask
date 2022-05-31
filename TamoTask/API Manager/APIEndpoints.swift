//
//  APIEndpoints.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 4/7/20.
//  Copyright © 2020 Shahriar Mahmud. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


//MARK:- Login
enum LoginEndPoint: Endpoint {
    
    case login(email:String, password:String)
    case eventList(id: String)
    case eventDetails(id: String, eventId: String)
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .eventList, .eventDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return KBasePath + OauthPath.signin.rawValue
        case .eventList(let id):
            return KBasePath + OauthPath.signin.rawValue + "/\(id)/events"
        case .eventDetails(let id, let eventId):
            return KBasePath + OauthPath.signin.rawValue + "/\(id)/events/\(eventId)/event"
        }
    }
    
    var query: [String: Any]  {
        switch self {
        case .login(let email, let pass):
            return ["email": email, "password": pass]
        case .eventList, .eventDetails:
            return [String: Any]()
        }
    }
}
