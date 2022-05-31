//
//  URLPaths.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/26/21.
//

import Foundation



#if DEVELOPMENT
let KBasePath = "https://6033d74f843b150017931b4a.mockapi.io"
#else
let KBasePath = "https://6033d74f843b150017931b4a.mockapi.io"
#endif

enum OauthPath: String {
    case signin                     = "/api/v1/authenticate"
    case eventList                  = "/api/v1/authenticate/"
}
