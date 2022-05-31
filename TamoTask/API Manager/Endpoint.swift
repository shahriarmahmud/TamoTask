//
//  Endpoint.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 4/7/20.
//  Copyright © 2020 Shahriar Mahmud. All rights reserved.
//

import Foundation
import Alamofire

/**
 *  Protocol for all endpoints to conform to.
 */
protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: Any] { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    var encoding: ParameterEncoding { get{return URLEncoding.default} set {} }
}
