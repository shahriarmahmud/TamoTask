//
//  TTEventDetailsVC.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class TTEventDetailsVC: UIViewController {
    
    @IBOutlet weak private var tblView: UITableView!
    
    @IBOutlet weak private var eventDateLbl: UILabel!
    @IBOutlet weak private var eventAddressLbl: UILabel!
    @IBOutlet weak private var eventSubjctLbl: UILabel!
    @IBOutlet weak private var eventTypeLbl: UILabel!
    private var activityIndicatorView: ActivityIndicatorView!
    private var refreshControl = UIRefreshControl()

    
    var viewModel: TTDashboardVM?
    var eventId = "1"
    var selectedIndex = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Event details"
        setupPullToRefresh()
        setData()
        getData()
    }
    
    private func setupPullToRefresh(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        getData()
    }

    
    private func setupIndicator(){
        self.activityIndicatorView = ActivityIndicatorView(title: "Processing...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
    }
    
    private func setData(){
        guard let vm = viewModel else {return}
        let eventDate = vm.getEventDate(index: selectedIndex)
        let eventType = vm.getEventType(index: selectedIndex)
        let eventSubject = vm.getEventSubject(index: selectedIndex)
        let eventAddress = vm.getEventAddress(index: selectedIndex)
        
        eventAddressLbl.text = eventAddress
        eventSubjctLbl.text = eventSubject
        eventTypeLbl.text = eventType
        eventDateLbl.text = Helper.changeDateFormatter(dateStr: eventDate, targetDateFormat: "MMM d YYYY, h:mm a")
    }
    
    private func getData(){
        guard let vm = viewModel else {return}
        setupIndicator()
        self.activityIndicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        vm.getEventDetails(eventId: eventId) {[weak self] (success) in
            self?.activityIndicatorView.stopAnimating()
            self?.view.isUserInteractionEnabled = true
            if success{
                self?.tblView.reloadData()
            }
        }
    }
}

extension TTEventDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.getEventDetailsList()?.count == 0{
            Helper.emptyMessageInTableView(tableView, "No event details available")
        }else{
            tableView.backgroundView = nil
        }
        return viewModel?.getEventDetailsList()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TTEventDetailsCell.identifire, for: indexPath) as! TTEventDetailsCell
        cell.selectionStyle = .none
        guard let vm = viewModel else {return cell}
        cell.configureCell(viewModel: vm, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
