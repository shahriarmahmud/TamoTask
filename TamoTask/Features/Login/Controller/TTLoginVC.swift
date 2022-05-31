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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()

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
            viewModel.makeLogin(email: email, password: password) { (success) in
                if success{
                    RootVCHelper.setToDashboardVC()
                }
            }
        }
    }
}
