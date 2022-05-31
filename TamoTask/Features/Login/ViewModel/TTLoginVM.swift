//
//  TTLoginVM.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 2/25/21.
//

import Foundation
import SVProgressHUD

class TTLoginVM{
    
    func makeLogin(email: String, password: String, completion: @escaping (_ success: Bool) -> Void){
        SVProgressHUD.show()
        APIClient.shared.objectAPICall(apiEndPoint: LoginEndPoint.login(email: email, password: password), modelType: LoginResponse.self) { (response) in
            switch response {
            case .success(let value):
                SVProgressHUD.dismiss()
                self.saveData(result: value, password: password)
                completion(true)
            case .failure((let code, let data, let err)):
                SVProgressHUD.dismiss()
                DLog("code = \(code)")
                DLog("data = \(String(describing: data))")
                DLog("error = \(err.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func saveData(result: LoginResponse, password: String){
        Helper.saveData(data: result.email ?? "", key: Constants.ttEmail)
        Helper.saveData(data: password, key: Constants.ttPassword)
        Helper.saveData(data: result.authToken ?? "", key: Constants.ttToken)
        Helper.saveData(data: result.userId ?? "", key: Constants.ttUserID)
        Helper.saveData(data: result.firstName ?? "", key: Constants.ttFName)
        Helper.saveData(data: result.lastName ?? "", key: Constants.ttLName)
        Helper.saveData(data: result.avatar ?? "", key: Constants.ttAvatar)
    }
    
    func isValid(email: String, password: String)-> Bool{
        
        if email.isEmpty {
            Helper.showAlert(msg: "Please insert email")
            return false
        }
        if !email.isValidEmail{
            Helper.showAlert(msg: "Invalid email")
            return false
        }
        if password.isEmpty {
            Helper.showAlert(msg: "Please insert password")
            return false
        }
        if password.count < 6 {
            Helper.showAlert(msg: "Password must grater then 6 digit")
            return false
        }
        
        return true
    }
}
