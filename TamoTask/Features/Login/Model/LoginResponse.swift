//
//  LoginResponse.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 12/30/20.
//

import Foundation

struct LoginResponse: Decodable, CustomStringConvertible {
    var description: String{
        return ""
    }
    
    var userId: String?
    var authToken: String?
    var avatar: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?

    enum CodingKeys: String, NestableCodingKey {
        case userId
        case authToken
        case avatar
        case firstName
        case lastName
        case email
        case password
    }
}
