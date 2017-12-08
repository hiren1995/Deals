//
//  SignUp.swift
//  Deals
//
//  Created by Mohit on 20/09/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class SignUp: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textNumber.setPlaceHolderColor()
        textEmail.setPlaceHolderColor()
        textName.setPlaceHolderColor()
        textPassword.setPlaceHolderColor()
    }
    
    //MARK: - IBAction Methods

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        if textName.text == ""{
            self.showAlert("Please Enter Name")
        }
        else if textEmail.text == ""{
            self.showAlert("Please Enter Email")
        }
        else if !(self.isValidEmail(testStr: textEmail.text!)){
            self.showAlert("Please Enter Valid Email Address")
        }
        else if textPassword.text == ""{
            self.showAlert("Please Enter Password")
        }
        else if textNumber.text == ""{
            self.showAlert("Please Enter Phone No.")
        }
        else{
            
            if Reachability.isConnectedToNetwork() == true{
                print("Internet connection OK")
                
                let deviceToken = udefault.object(forKey: "DeviceToken") as! String
                
                let parameters : Parameters = [SUserName:self.textName.text!,
                                               SEmail:self.textEmail.text!,
                                               SPassword:self.textPassword.text!,
                                               SPhone:self.textNumber.text!,
                                               SDeviceType:"2",
                                               SToken:deviceToken,
                                               "latitude" : 0.00000,
                                               "longitude" : 0.00000]
                
                let headers: HTTPHeaders =  ["Authorization": "auth_token"]
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                print(SignUpAPI)
                print(parameters)
                
                Alamofire.request(SignUpAPI, method: .post, parameters: parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
                    
                    switch(response.result)
                    {
                    case .success(_):
                        if response.result.value != nil{
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            let dataDic = response.result.value as! NSDictionary
                            print("Sign Up Response is:\(dataDic)")
                            
                           let strStatus = NSString(string: dataDic["status"] as! String)
                    
                            if (strStatus.isEqual(to: "success")){
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                let tempDic = dataDic.object(forKey: "data") as! NSDictionary
                                let tempuserid = tempDic.value(forKey: "user_id")!
                                let tempToken = tempDic.value(forKey: "token")!
                                let tempEmail = tempDic.value(forKey: "email")
                                let tempName = tempDic.value(forKey: "full_name")
                                let tempProfile = tempDic.value(forKey: "profile_pic")
                                let tempLat = tempDic.value(forKey: "latitude")
                                let tempLongi = tempDic.value(forKey: "longitude")
                                
                                udefault.setValue(tempuserid, forKey: MUserID)
                                udefault.setValue(tempToken, forKey: MUserToken)
                                udefault.setValue(tempEmail, forKey: MUserEmail)
                                udefault.setValue(tempName, forKey: MUserName)
                                udefault.setValue(tempProfile, forKey: "ProfilePic")
                                udefault.setValue(tempLat, forKey: "UserLat")
                                udefault.setValue(tempLongi, forKey: "UserLongi")
                                udefault.set(true, forKey: "Login")
                                
                                //Home screen
                                
                                let initialView = sBoard.instantiateViewController(withIdentifier: "HomeView")
                                let menuView = sBoard.instantiateViewController(withIdentifier: "MenuView")
                                
                                let MenuView : SWRevealViewController = SWRevealViewController(rearViewController: menuView, frontViewController: initialView)
                                self.present(MenuView, animated: true, completion: nil)                                
                            }
                            else{
                                let strMsg = NSString(string: dataDic["msg"] as! String)
                                self.showAlert(strMsg as String)
                            }
                        }
                        break
                        
                    case .failure(_):
                        print(response.result.error!)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        break
                        
                    }
                }
            }
            else{
                print("Internet Not Connected")
                self.showAlert("You are Not Connected to Internet")
            }
        }
    }
    
    //MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Managing the Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
