//
//  CalendarManager.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation

struct CalendarManager {
    static func getCalendarRange(withStartDate startDate: Date, withEndDate endDate: Date) -> [CalendarRange] {
        
        let months = Calendar.current.dateComponents([.month], from: startDate, to: endDate).month ?? 1
        
        var result: [CalendarRange] = []
        for month in 0...months {
            let dateToAdd = Calendar.current.date(byAdding: .month, value: (month * -1), to: endDate)!
            let components = Calendar.current.dateComponents([.month, .year], from: dateToAdd)
            
            let days = month == 0 ? CalendarManager.getDay(for: endDate) : CalendarManager.getDaysInMonth(for: dateToAdd)
            
            result.append(CalendarRange(month: components.month!, year: components.year!, daysInMonth: days))
        }
        
        return result
    }
    
    static func getDaysInMonth(for date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    static func getDay(for date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date).day!
    }
    
    static func getMonth(for date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date).month!
    }
    
    static func getDate(year: Int, month: Int) -> Date {
        return Calendar.current.date(from: DateComponents(year: year, month: month))!
    }
}
