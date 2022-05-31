//
//  Helper.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

struct Helper{
            
    static func emptyMessageInTableView(_ tableView: UITableView,_ title: String){
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.textColor        = UIColor(red: 67, green: 67, blue: 67)
        noDataLabel.font             = UIFont(name: "Open Sans", size: 15)
        noDataLabel.textAlignment    = .center
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = .none
        noDataLabel.text = title
    }
    
    //MARK:- Alert Helpers

    static func showAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let mwindow = UIApplication.shared.keyWindow!
        guard let parentVC = mwindow.visibleViewController() else {return}
        parentVC.present(alert, animated: true, completion: nil)
    }

    static func getProfileImage()-> UIImage{
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: Constants.profileImageWidthHeight, height: Constants.profileImageWidthHeight)
        lblNameInitialize.textColor = UIColor.white
        let fName = Helper.getStringData(key: Constants.ttFName).isEmpty ? Constants.defaultUserFName: Helper.getStringData(key: Constants.ttFName)
        let lName = Helper.getStringData(key: Constants.ttLName).isEmpty ? Constants.defaultUserLName : Helper.getStringData(key: Constants.ttLName)
        guard let fFirstCharecter = fName.first else {return UIImage()}
        guard let lFirstCharecter = lName.first else {return UIImage()}
        let fNameStr = String(fFirstCharecter)
        let lNameStr = String(lFirstCharecter)
        lblNameInitialize.text = fNameStr + lNameStr
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.darkGray
        lblNameInitialize.layer.cornerRadius = 20.0
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK:- Get Local Data
    
    static func getStringData(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    static func getIntData(key: String)-> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func getBoolData(key: String)-> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    //MARK:- Save Local Data
    
    static func saveData(data: String, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func saveData(data: Int, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func saveData(data: Bool, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- DATE
    
    static func changeDateFormatter(dateStr: String, targetDateFormat: String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        guard let date = dateFormatter.date(from: dateStr) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = targetDateFormat
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    static func dateToAddedExtraTime(dateStr: String, extraTime: Int)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        guard let date = dateFormatter.date(from: dateStr) else {
            assert(false, "no date from string")
            return ""
        }
        
        let extraTime = date.adding(minutes: extraTime)
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: extraTime)
        
        return timeStamp
    }
    
    static func getConvertedDate(dateStr: String)->String{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: dateStr) ?? Date()

        dateFormatter.dateFormat = "dd-MM-yyyy"
        let finalDate = dateFormatter.string(from: date)
        return finalDate
    }
    
    static func getDate(dateStr: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: dateStr) ?? Date()
        return date
    }
    
    static func getDateStrToDate(dateStr: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: dateStr) else {
            assert(false, "no date from string")
            return Date()
        }
        return date
    }
    
    
    static func getYearMonth(dateStr: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateStr) ?? Date()

        dateFormatter.dateFormat = "yyyy MMMM"
        let monthYear = dateFormatter.string(from: date)
        return monthYear
    }
    
    static func getDayName(dateStr: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateStr) ?? Date()
        let dayName = getDay(date: date)
        return dayName
    }
    
    static func getDay(date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    static func removeAllData(){
        let pass = Helper.getStringData(key: Constants.ttPassword)
        let email = Helper.getStringData(key: Constants.ttEmail)
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        Helper.saveData(data: pass, key: Constants.ttPassword)
        Helper.saveData(data: email, key: Constants.ttEmail)
        
        RootVCHelper.setToLoginVC()
    }
}
