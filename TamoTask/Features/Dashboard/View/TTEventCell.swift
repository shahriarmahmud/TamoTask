//
//  TTEventCell.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/26/21.
//

import UIKit

class TTEventCell: UITableViewCell {
    
    static let identifier = "TTEventCell"
    
    @IBOutlet weak private var dashDividerView: DashedLineView!
    @IBOutlet weak private var ratingLbl: UILabel!
    @IBOutlet weak private var hasVideoImageView: UIImageView!
    @IBOutlet weak private var scndDivider: UIView!
    @IBOutlet weak private var hasattachmentImageView: UIImageView!
    @IBOutlet weak private var fstDivider: UIView!
    @IBOutlet weak private var hasLbl: UILabel!
    @IBOutlet weak private var eventAddressLbl: UILabel!
    @IBOutlet weak private var eventSubjctLbl: UILabel!
    @IBOutlet weak private var eventTypeLbl: UILabel!
    @IBOutlet weak private var timeToLbl: UILabel!
    @IBOutlet weak private var timeFromLbl: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        style()
    }
    
    private func style(){
        containerView.layer.cornerRadius = 10
        hasLbl.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: TTDashboardVM, index: Int){
        let rating = viewModel.getEventRating(index: index)
        let eventDate = viewModel.getEventDate(index: index)
        let eventType = viewModel.getEventType(index: index)
        let eventSubject = viewModel.getEventSubject(index: index)
        let eventAddress = viewModel.getEventAddress(index: index)
        let hasAttachment = viewModel.getEventHasAttachment(index: index)
        
        let hasLabel = viewModel.getEventHasLabel(index: index)
        let hasVideo = viewModel.getEventHasVideo(index: index)
        _ = viewModel.getEventImportant(index: index)
        
        ratingLbl.text = rating
        timeToLbl.text = Helper.changeDateFormatter(dateStr: eventDate, targetDateFormat: "hh:mm a")
        timeFromLbl.text = Helper.dateToAddedExtraTime(dateStr: eventDate, extraTime: 45) // default event enterval
        eventTypeLbl.text = eventType
        eventSubjctLbl.text = eventSubject
        eventAddressLbl.text = eventAddress
        
        hasattachmentImageView.isHidden = !hasAttachment
        hasLbl.isHidden = !hasLabel
        hasVideoImageView.isHidden = !hasVideo
        
        fstDivider.isHidden = !hasAttachment
        scndDivider.isHidden = !hasVideo
    }
}

