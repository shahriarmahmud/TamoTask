//
//  CalendarCell.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var fullDataLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currentBottomLocatorView: UIView!
    @IBOutlet weak var othersBottomLocatorView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    
    static let identifier = "calendarCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
    }
    
    private func style(){
        currentBottomLocatorView.layer.cornerRadius = 10
        othersBottomLocatorView.isHidden = true
    }

    static func register(with collectionView: UICollectionView) {
        collectionView.register(UINib.init(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath, forDay day: Int, dayName: String, data: CalendarRange) -> CalendarCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CalendarCell ?? CalendarCell()
        cell.isUserInteractionEnabled = true
        if indexPath.row == 0 && indexPath.section == 0{
            cell.initialView(cell: cell)
        }else{
            cell.normalViewView(cell: cell)
        }
        
        if dayName == "Sat" || dayName == "Sun"{
            cell.othersBottomLocatorView.backgroundColor = UIColor.ttDeepSkyBlue
        }else{
            cell.othersBottomLocatorView.backgroundColor = UIColor.white
        }
        
        let daysInSection = data.daysInMonth
        let day = daysInSection - indexPath.item
        
        
        let dateStr = "\(day)-\(data.month)-\(data.year)"
        
        cell.fullDataLbl.text = dateStr
        cell.dateLabel.text = String(format: "%02d", day)
        cell.dayNameLabel.text = dayName
        
        return cell
    }
    
    func initialView(cell: CalendarCell){
        cell.currentBottomLocatorView.isHidden = false
        cell.othersBottomLocatorView.isHidden = true
        cell.dateLabel.textColor = .white
        cell.dayNameLabel.textColor = .white
    }
    
    func selectedViewView(cell: CalendarCell){
        cell.currentBottomLocatorView.isHidden = false
        cell.othersBottomLocatorView.isHidden = true
        cell.dateLabel.textColor = .lightGray
        cell.dayNameLabel.textColor = .lightGray
    }
    
    func normalViewView(cell: CalendarCell){
        cell.currentBottomLocatorView.isHidden = true
        cell.othersBottomLocatorView.isHidden = false
        cell.dateLabel.textColor = UIColor.ttDeepSkyBlue
        cell.dayNameLabel.textColor = UIColor.ttDeepSkyBlue
    }
}
