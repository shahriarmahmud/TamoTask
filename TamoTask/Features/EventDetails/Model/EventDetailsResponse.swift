//
//  EventDetailsResponse.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation

struct EventDetailsResponse: Decodable, CustomStringConvertible {
    var description: String{
        return ""
    }
    
    var id: String?
    var eventId: String?
    var eventComment: String?

    enum CodingKeys: String, NestableCodingKey {
        case id
        case eventId
        case eventComment
    }
}

