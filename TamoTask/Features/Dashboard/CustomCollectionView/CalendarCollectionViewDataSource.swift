//
//  CalendarCollectionViewDataSource.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class CalendarCollectionViewDataSource : NSObject, UICollectionViewDataSource {

	private var calendarRange: [CalendarRange] = []
    private var currentCalendarRange: [CalendarRange] = []
    private var monthLbl: UILabel?

    init(calendarRange: [CalendarRange], _ monthLbl: UILabel) {
		super.init()
        self.monthLbl = monthLbl
		self.calendarRange = calendarRange
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return calendarRange.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return calendarRange[section].daysInMonth
	}


	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let section = calendarRange[indexPath.section]
		let daysInSection = section.daysInMonth
		let day = daysInSection - indexPath.item
        
        let dateStr = "\(day)-\(section.month)-\(section.year)"
        
        let dayName = Helper.getDayName(dateStr: dateStr)

        let cell = CalendarCell.dequeue(from: collectionView, at: indexPath, forDay: day, dayName: dayName, data: section)
        monthLbl?.text = Helper.getYearMonth(dateStr: dateStr)
		return cell
	}
}
