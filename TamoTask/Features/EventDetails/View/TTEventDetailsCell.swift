//
//  TTEventDetailsCell.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/27/21.
//

import UIKit

class TTEventDetailsCell: UITableViewCell {
    
    static let identifire = "TTEventDetailsCell"
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var commentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(viewModel: TTDashboardVM, index: Int){
        let comment = viewModel.getEventDetailsComment(index: index)
        commentLbl.text = "Comment: \(comment)"
    }

}
