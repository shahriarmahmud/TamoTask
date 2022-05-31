//
//  EventResponse.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation

struct EventResponse: Decodable, CustomStringConvertible {
    var description: String{
        return ""
    }
    
    var id: String?
    var userId: String?
    var eventDate: String?
    var eventType: String?
    var eventSubject: String?
    var eventAddress: String?
    var hasAttachment: Bool?
    var hasLabel: Bool?
    var hasVideo: Bool?
    var rating: String?
    var important: Bool?
    var eventDateEnd: String?

    enum CodingKeys: String, NestableCodingKey {
        case id
        case userId
        case eventDate
        case eventType
        case eventSubject
        case eventAddress
        case hasAttachment
        case hasLabel
        case hasVideo
        case rating
        case important
    }
}
