//
//  TTBlankEventCell.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/27/21.
//

import UIKit

class TTBlankEventCell: UITableViewCell {
    
    @IBOutlet weak private var startTimeLbl: UILabel!
    @IBOutlet weak private var dividerView: DashedLineView!
    @IBOutlet weak private var endTimeLbl: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    static let identifire = "TTBlankEventCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: TTDashboardVM, index: Int){
        let startTime = viewModel.getEventDate(index: index)
        let endTime = viewModel.getEventEndTime(index: index)
        
        startTimeLbl.text = Helper.changeDateFormatter(dateStr: startTime, targetDateFormat: "hh:mm a")
        endTimeLbl.text = Helper.changeDateFormatter(dateStr: endTime, targetDateFormat: "hh:mm a")
    }

}
