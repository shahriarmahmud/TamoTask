//
//  TTDashboardVM.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation
import UIKit

class TTDashboardVM{
    
    private var eventList: [EventResponse]?
    private var tempEventList: [EventResponse]?
    private var eventDetailsList: [EventDetailsResponse]?
    
    func getEventList(completion: @escaping (_ success: Bool) -> Void){

        let id = Helper.getStringData(key: Constants.ttUserID)
        
        let url = KBasePath + OauthPath.signin.rawValue + "/\(id)/events"
        APIClient.shared.objectAPICall(url: url, modelType: [EventResponse].self, method: .get, parameters: [String: Any]()) { (response) in
            switch response {
            case .success(let value):
                
                self.eventList = value
                self.filteredEvent(date: Date())
                completion(true)
            case .failure((let code, let data, let err)):

                DLog("code = \(code)")
                DLog("data = \(String(describing: data))")
                DLog("error = \(err.localizedDescription)")
                completion(false)
            }
        }
    }

    func getEventDetails(eventId: String, completion: @escaping (_ success: Bool) -> Void){
        let id = Helper.getStringData(key: Constants.ttUserID)
        let url = KBasePath + OauthPath.signin.rawValue + "/\(id)/events/\(eventId)/event"
        
        APIClient.shared.objectAPICall(url: url, modelType: [EventDetailsResponse].self, method: .get, parameters: [String: Any]()) { (response) in
            switch response {
            case .success(let value):
                self.eventDetailsList = value
                completion(true)
            case .failure((let code, let data, let err)):
                DLog("code = \(code)")
                DLog("data = \(String(describing: data))")
                DLog("error = \(err.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func filteredEvent(date: Date){
        guard let evntLst = eventList else {return}
        
        let filteredData = evntLst.filter({ (model) -> Bool in
            let selectedDate = Helper.getConvertedDate(dateStr: date.toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            let convertedDate = Helper.changeDateFormatter(dateStr: model.eventDate ?? "", targetDateFormat: "dd-MM-yyyy")
            return (selectedDate == convertedDate)
        })
        
        self.tempEventList = self.sortDate(value: filteredData)
        
        guard let filteredEventList = tempEventList else {return}
        
        getDataForBlankEvent(filteredEventList: filteredEventList)
    }
    
    private func getDataForBlankEvent(filteredEventList: [EventResponse]){
        for count in 0..<filteredEventList.count{
            if (filteredEventList.count - count) != 1{
                let firstDateStr = filteredEventList[count].eventDate ?? ""
                let scndDateStr = filteredEventList[count + 1].eventDate ?? ""
                
                let fstDate = Helper.getDateStrToDate(dateStr: firstDateStr)
                let scndDate = Helper.getDateStrToDate(dateStr: scndDateStr)
                
                let calendar = Calendar.current
                let difference = calendar.dateComponents([.hour, .minute], from: fstDate, to: scndDate)
                let hours = difference.hour!
                DLog("Time interval: \(hours)")
                
                // MARK:- 1 hour interval for showing blank cell
                if hours > 1 {
                    let blankItem = EventResponse(id: "0", userId: "0", eventDate: firstDateStr, eventType: "Blank", eventSubject: "", eventAddress: "", hasAttachment: false, hasLabel: false, hasVideo: false, rating: "0", important: false, eventDateEnd: scndDateStr)
                    tempEventList?.insert(blankItem, at: count + 1)
                }
            }
        }
    }
    
    private func sortDate(value: [EventResponse])-> [EventResponse]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let output = value.sorted { model1, model2 in
            guard let date1 = dateFormatter.date(from: model1.eventDate ?? "") else { return true }
            guard let date2 = dateFormatter.date(from: model2.eventDate ?? "") else { return false }
            return date1 < date2
        }
        return output
    }
    
    func getEventList()-> [EventResponse]?{
        return tempEventList
    }
    
    func getEventDetailsList()-> [EventDetailsResponse]?{
        return eventDetailsList
    }
    
    func getEventId(index: Int)-> String{
        guard let id = tempEventList?[index].id else {return ""}
        return id
    }
    
    func getEventUserId(index: Int)-> String{
        guard let userId = tempEventList?[index].userId else {return ""}
        return userId
    }
    
    func getEventDate(index: Int)-> String{
        guard let eventDate = tempEventList?[index].eventDate else {return ""}
        return eventDate
    }
    
    func getEventType(index: Int)-> String{
        guard let eventType = tempEventList?[index].eventType else {return ""}
        return eventType
    }
    
    func getEventSubject(index: Int)-> String{
        guard let eventSubject = tempEventList?[index].eventSubject else {return ""}
        return eventSubject
    }
    
    func getEventAddress(index: Int)-> String{
        guard let eventAddress = tempEventList?[index].eventAddress else {return ""}
        return eventAddress
    }
    
    func getEventHasAttachment(index: Int)-> Bool{
        guard let hasAttachment = tempEventList?[index].hasAttachment else {return false}
        return hasAttachment
    }
    
    func getEventHasLabel(index: Int)-> Bool{
        guard let hasLabel = tempEventList?[index].hasLabel else {return false}
        return hasLabel
    }
    
    func getEventHasVideo(index: Int)-> Bool{
        guard let hasVideo = tempEventList?[index].hasVideo else {return false}
        return hasVideo
    }
    
    func getEventRating(index: Int)-> String{
        guard let rating = tempEventList?[index].rating else {return "0"}
        return rating
    }
    
    func getEventImportant(index: Int)-> Bool{
        guard let eventImportant = tempEventList?[index].important else {return false}
        return eventImportant
    }
    
    func getEventEndTime(index: Int)-> String{
        guard let endDate = tempEventList?[index].eventDateEnd else {return ""}
        return endDate
    }
    
    func getEventDetailsComment(index: Int)-> String{
        guard let comment = eventDetailsList?[index].eventComment else {return ""}
        return comment
    }
}
