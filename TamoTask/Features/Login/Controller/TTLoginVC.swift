//
//  TTLoginVC.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import UIKit

class TTLoginVC: UIViewController {
    
    @IBOutlet weak private var emailFld: UITextField!
    @IBOutlet weak private var passwordFld: UITextField!
    @IBOutlet weak private var loginBtn: UIButton!
    
    private let viewModel = TTLoginVM()
    private var activityIndicatorView: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()

    }
    
    private func setupIndicator(){
        self.activityIndicatorView = ActivityIndicatorView(title: "Processing...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
    }
    
    private func style(){
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.darkGray.cgColor
    }

    @IBAction func loginBtnAction(_ sender: Any) {
        guard let email = emailFld.text else {return}
        guard let password = passwordFld.text else {return}
        
        if viewModel.isValid(email: email, password: password){
            setupIndicator()
            self.activityIndicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            viewModel.makeLogin(email: email, password: password) {(success) in
                self.activityIndicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                if success{
                    RootVCHelper.setToDashboardVC()
                }
            }
        }
    }
}
