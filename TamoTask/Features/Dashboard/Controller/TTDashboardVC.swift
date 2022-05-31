//
//  TTDashboardVC.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class TTDashboardVC: UIViewController {
    
    @IBOutlet weak private var monthYearLbl: UILabel!
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var clcView: UICollectionView!
    @IBOutlet weak private var tblView: UITableView!
    
    private var startDate: Date = CalendarManager.getDate(year: 2020, month: 01)
    private var endDate: Date = Date()
    private let viewModel = TTDashboardVM()
    private let loginVM = TTLoginVM()
    private var refreshControl = UIRefreshControl()
    
    private var activityIndicatorView: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 20
        
        setupPullToRefresh()
        setupCollectionView()
        getData()
        getProfileImage()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapProfilePic(_:)))
        profileImageView.addGestureRecognizer(tap)
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
    
    @objc func handleTapProfilePic(_ sender: UITapGestureRecognizer? = nil) {
        switchUser()
    }
    
    private func switchUser(){
        let defaultEmail = Constants.defaultEmail
        let defaultPassword = Constants.defaultPassword
        loginVM.makeLogin(email: defaultEmail, password: defaultPassword) {[weak self] (success) in
            if success{
                self?.getData()
                self?.getProfileImage()
            }
        }
    }

    private func setupIndicator(){
        self.activityIndicatorView = ActivityIndicatorView(title: "Processing...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
    }
    
    private func setupCollectionView(){
        clcView.dataSource = self.collectionViewDataSource
        clcView.delegate = self.collectionViewFlowLayout
        clcView.allowsMultipleSelection = false
        CalendarCell.register(with: clcView)
        clcView.backgroundColor = UIColor.white
        clcView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func getProfileImage(){
        let avater = Helper.getStringData(key: Constants.ttAvatar)
        if avater.isEmpty{
            let profileImage = Helper.getProfileImage()
            profileImageView.image = profileImage
        }else{
            profileImageView.downloaded(from: avater)
        }

    }
    
    lazy var collectionViewFlowLayout : CalendarCollectionViewFlowLayout = {
        let layout = CalendarCollectionViewFlowLayout()
        layout.didSelectItemAt = { (clcView, indexPath) in
            let cell = clcView.cellForItem(at: indexPath) as! CalendarCell
            cell.selectedViewView(cell: cell)
            let data = cell.fullDataLbl.text ?? ""
            let dateStr = Helper.getDate(dateStr: data)
            self.viewModel.filteredEvent(date: dateStr)
            self.tblView.reloadData()
        }
        
        layout.didDeSelectItemAt = { (clcView, indexPath) in
            let cell = clcView.cellForItem(at: indexPath) as! CalendarCell
            cell.normalViewView(cell: cell)
        }
        return layout
    }()
    
    lazy var collectionViewDataSource: CalendarCollectionViewDataSource = {
        let range = CalendarManager.getCalendarRange(withStartDate: startDate, withEndDate: endDate)
        let collectionView = CalendarCollectionViewDataSource(calendarRange: range, monthYearLbl)
        return collectionView
    }()
    
    private func getData(){
        setupIndicator()
        self.activityIndicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        viewModel.getEventList {[weak self] (success) in
            
            self?.activityIndicatorView.stopAnimating()
            self?.view.isUserInteractionEnabled = true
            
            if success{
                if self?.viewModel.getEventList()?.count == 0{
                    self?.getDefaultData()
                }else{
                    self?.tblView.reloadData()
                }
            }
        }
    }
    
    private func getDefaultData(){
        // MARK:- default data
        self.activityIndicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        Helper.saveData(data: "1", key: Constants.ttUserID)
        
        viewModel.getEventList {[weak self] (success) in
            self?.activityIndicatorView.stopAnimating()
            self?.view.isUserInteractionEnabled = true
            
            if success{
                self?.tblView.reloadData()
            }
        }
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        Helper.removeAllData()
    }
}

extension TTDashboardVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getEventList()?.count == 0 {
            Helper.emptyMessageInTableView(tableView, "No event available")
        }else{
            tableView.backgroundView = nil
        }

        return viewModel.getEventList()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.getEventType(index: indexPath.row) == "Blank"{
            let blankCell = tableView.dequeueReusableCell(withIdentifier: TTBlankEventCell.identifire, for: indexPath) as! TTBlankEventCell
            blankCell.selectionStyle = .none
            blankCell.configureCell(viewModel: viewModel, index: indexPath.row)
            return blankCell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TTEventCell.identifier, for: indexPath) as! TTEventCell
            cell.configureCell(viewModel: viewModel, index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.getEventType(index: indexPath.row) == "Blank"{
            return 70
        }else{
            return 180
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEventDetailsVC(index: indexPath.row)
    }
    
    private func showEventDetailsVC(index: Int){
        let storyboard = UIStoryboard(storyboard: .dashboard)
        let vc = storyboard.instantiateViewController(withIdentifier: TTEventDetailsVC.self)
        vc.viewModel = self.viewModel
        vc.eventId = self.viewModel.getEventId(index: index)
        vc.selectedIndex = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
