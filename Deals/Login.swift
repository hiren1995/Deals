//
//  Login.swift
//  Deals
//
//  Created by Mohit on 20/09/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class Login: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var btnFacebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textEmail.setPlaceHolderColor()
        textPassword.setPlaceHolderColor()
        
        btnFacebook.addTarget(self, action: #selector(self.loginFacebookAction), for: UIControlEvents.touchUpInside)
    }
    
    //MARK: - IBAction Methods
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if textEmail.text == ""{
            self.showAlert("Please Enter Email")
        }
        else if !(self.isValidEmail(testStr: textEmail.text!)){
            self.showAlert("Please Enter Valid Email Address")
        }
        else if textPassword.text == ""{
            self.showAlert("Please Enter Password")
        }
        else{
        if Reachability.isConnectedToNetwork() == true{
            print("Internet connection OK")
            
            var deviceToken = "ajhsajjjasjhsj"
            
            if udefault.object(forKey: "DeviceToken") as? String != nil{
                deviceToken = udefault.object(forKey: "DeviceToken") as! String
            }
            else{
                deviceToken = "ajhsajjjasjhsj"
            }
    
            let parameters : Parameters = [SEmail:self.textEmail.text!,
                                           SPassword:self.textPassword.text!,
                                           SDeviceType:"2",
                                           SToken:deviceToken]
            
            print("Login Parameters are:\(parameters)")
            
            let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            print(LoginAPI)
            print(parameters)
            
            Alamofire.request(LoginAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        let dataDic = response.result.value as! NSDictionary
                        print("Login Response is:\(dataDic)")
                        
                        let strStatus = NSString(string: dataDic["status"] as! String)
                        
                        if (strStatus.isEqual(to: "success"))
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            let tempDic = dataDic.object(forKey: "data") as! NSDictionary
                            let tempuserid = tempDic.value(forKey: "user_id")!
                            let tempToken = tempDic.value(forKey: "token")!
                            let tempEmail = tempDic.value(forKey: "email")
                            let tempName = tempDic.value(forKey: "full_name")
                            let tempProfile = tempDic.value(forKey: "profile_pic")
                            let tempLat = tempDic.value(forKey: "latitude")
                            let tempLongi = tempDic.value(forKey: "longitude")
                            
                            
                            
                            if tempDic.value(forKey: "rating") is NSNull
                            {
                                
                                udefault.set(nil, forKey: "OwnUserRatingMenuView")
                            }
                            else
                            {
                                udefault.set(tempDic.value(forKey: "rating"), forKey: "OwnUserRatingMenuView")
                                
                            }
                            
                            udefault.setValue(tempuserid, forKey: MUserID)
                            udefault.setValue(tempToken, forKey: MUserToken)
                            udefault.setValue(tempEmail, forKey: MUserEmail)
                            udefault.setValue(tempName, forKey: MUserName)
                            udefault.setValue(tempProfile, forKey: "ProfilePic")
                            udefault.setValue(tempLat, forKey: "UserLat")
                            udefault.setValue(tempLongi, forKey: "UserLongi")
                            udefault.set(true, forKey: "Login")
                            
                            //Select Country & City screen
                            
                            var SBoard = UIStoryboard()
                            if isArabic{
                                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
                            }
                            else{
                                SBoard = UIStoryboard(name: "Main", bundle: nil)
                            }
                            
                            let countryCityView = SBoard.instantiateViewController(withIdentifier: "SelCountryCity")
                            self.present(countryCityView, animated: true, completion: nil)
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
                }}
        }
        else{
            print("Internet Not Connected")
            self.showAlert("You are Not Connected to Internet")
        }}
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let forgotPassView = sBoard.instantiateViewController(withIdentifier: "ForgotView") as! ForgotPassword
        self.present(forgotPassView, animated: true, completion: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            let signUpView = SBoard.instantiateViewController(withIdentifier: "SignUpView") as! SignUp
            self.present(signUpView, animated: true, completion: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
            let signUpView = SBoard.instantiateViewController(withIdentifier: "SignUpView") as! SignUp
            self.present(signUpView, animated: true, completion: nil)
        }
        
        /*
        let signUpView = sBoard.instantiateViewController(withIdentifier: "SignUpView") as! SignUp
        self.present(signUpView, animated: true, completion: nil)
        */
    }
    
    @IBAction func btnTemrsCondition(_ sender: Any) {
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let webView = SBoard.instantiateViewController(withIdentifier: "webview") as! WebViewScreen
        webView.strType = "Temrs"
        webView.strTitle = "Terms of Service"
        self.present(webView, animated: true, completion: nil)
    }
    
    @IBAction func btnPrivacy(_ sender: Any) {
    }
    
    //MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK: - Facebook Login Methods
    
    // Once the button is clicked, show the login dialog
    @IBAction func loginFacebookAction(sender: AnyObject)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")){
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    
                    //Store Data on Server and go to Home
                    
                    let deviceToken = udefault.object(forKey: "DeviceToken") as! String
                    
                    let parameters : Parameters = [SEmail:info["email"] as! String,
                                                   SUserName : info["name"] as! String,
                                                   "fb_id" : info["id"] as! String ,
                                                   "latitude" : "0.000000",
                                                   "longitude" : "0.00000",
                                                   SDeviceType:"2",
                                                   SToken:deviceToken]
                    
                    let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
                    
                    print(FBLoginAPI)
                    print(parameters)
                    
                    Alamofire.request(FBLoginAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
                        
                        switch(response.result)
                        {
                        case .success(_):
                            if response.result.value != nil{
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                let dataDic = response.result.value as! NSDictionary
                                print("Login Response is:\(dataDic)")
                               
                                
                                
                                let strStatus = NSString(string: dataDic["status"] as! String)
                                
                                
                                if (strStatus.isEqual(to: "success"))
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    
                                    let tempDic = dataDic.object(forKey: "data") as! NSDictionary
                                    let tempuserid = tempDic.value(forKey: "user_id")!
                                    let tempToken = tempDic.value(forKey: "token")!
                                    let tempEmail = tempDic.value(forKey: "email")
                                    let tempName = tempDic.value(forKey: "full_name")
                                    let tempProfile = tempDic.value(forKey: "profile_pic")
                                    let tempLat = tempDic.value(forKey: "latitude")
                                    let tempLongi = tempDic.value(forKey: "longitude")
                                    
                                    
                                    if tempDic.value(forKey: "rating") is NSNull
                                    {
                                        
                                       udefault.set(nil, forKey: "OwnUserRatingMenuView")
                                    }
                                    else
                                    {
                                        udefault.set(tempDic.value(forKey: "rating"), forKey: "OwnUserRatingMenuView")
                                        
                                    }
                                    
                                    
                                    
                                    udefault.setValue(tempuserid, forKey: MUserID)
                                    udefault.setValue(tempToken, forKey: MUserToken)
                                    udefault.setValue(tempEmail, forKey: MUserEmail)
                                    udefault.setValue(tempName, forKey: MUserName)
                                    udefault.setValue(tempProfile, forKey: "ProfilePic")
                                    udefault.setValue(tempLat, forKey: "UserLat")
                                    udefault.setValue(tempLongi, forKey: "UserLongi")
                                    udefault.set(true, forKey: "Login")
                                    
                                    //Select Country & City screen
                                    
                                    var SBoard = UIStoryboard()
                                    if isArabic{
                                        SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
                                    }
                                    else{
                                        SBoard = UIStoryboard(name: "Main", bundle: nil)
                                    }
                                    
                                    let countryCityView = SBoard.instantiateViewController(withIdentifier: "SelCountryCity")
                                    self.present(countryCityView, animated: true, completion: nil)
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
            })
        }
    }
    
    // MARK: - Managing the Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
