//
//  UpdateProfile.swift
//  Deals
//
//  Created by Mohit on 12/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class UpdateProfile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ratingBar: AARatingBar!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textNumber: UITextField!
    
     var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.setRoundedWithBorder()
        
        lblName.text = udefault.object(forKey: MUserName) as? String
        textName.text = udefault.object(forKey: MUserName) as? String
        textEmail.text = udefault.object(forKey: MUserEmail) as? String
     //   textNumber.text = udefault.object(forKey: MUserName) as? String
        
        //profile pic
        let tempimgURL = udefault.object(forKey: "ProfilePic") as! String
        
        let ProfileUrl = ProfileImageURL + tempimgURL
        print("Profile URL:\(ProfileUrl)")
        
        let urlProfilePic = URL(string:ProfileUrl)
        profileImage.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: nil
        )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK:- ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = image
            //isImage = true
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        
        if textName.text == ""{
            self.showAlert("Please Enter Name")
        }
        else if textEmail.text == ""{
            self.showAlert("Please Enter Email")
        }
        else if !(self.isValidEmail(testStr: textEmail.text!)){
            self.showAlert("Please Enter Valid Email Address")
        }
        else if textNumber.text == ""{
            self.showAlert("Please Enter Phone Number")
        }
        else{
            if Reachability.isConnectedToNetwork() == true{
                
                let tempUserid = udefault.value(forKey: MUserID) as! String
                let tempToken =  udefault.value(forKey: MUserToken) as! String
                
                let parameters : Parameters = ["user_id" : tempUserid,
                                               "token" :tempToken,
                                               "full_name" : textName.text!,
                                               "email" : textEmail.text!,
                                               "phone_no" : textNumber.text!,
                                               "latitude" : "0.00000",
                                               "longitude" : "0.00000"]
                
              //  let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(UIImageJPEGRepresentation(self.profileImage.image!, 0.5)!, withName: "profile_pic", fileName: "file.jpeg", mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }, to:updateProfileAPI, method: .post, headers: ["Authorization": "auth_token"])
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            // print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            //self.delegate?.showSuccessAlert()
                            //                            print(response.request)  // original URL request
                            //                            print(response.response) // URL response
                            //                            print(response.data)     // server data
                            // print("Response Result is:\(response.result.value)")   // result of response serialization
                            
                            if let JSON : NSDictionary = response.result.value as! NSDictionary {
                                print("JSON: \(JSON)")
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                let strStatus = NSString(string: JSON["status"] as! String)
                                
                                if (strStatus.isEqual(to: "success")){
                                   
                                    let tempDic = JSON.object(forKey: "data") as! NSDictionary
                                    let tempEmail = tempDic.value(forKey: "email")
                                    let tempName = tempDic.value(forKey: "full_name")
                                    let tempProfile = tempDic.value(forKey: "profile_pic")
                                    let tempLat = tempDic.value(forKey: "latitude")
                                    let tempLongi = tempDic.value(forKey: "longitude")
                                    
                                    udefault.setValue(tempEmail, forKey: MUserEmail)
                                    udefault.setValue(tempName, forKey: MUserName)
                                    udefault.setValue(tempProfile, forKey: "ProfilePic")
                                    udefault.setValue(tempLat, forKey: "UserLat")
                                    udefault.setValue(tempLongi, forKey: "UserLongi")
                                    
                                    self.dismiss(animated: true, completion: nil)
                                }
                                    
                                else{
                                    let strMSG = NSString(string: JSON["msg"] as! String)
                                    self.showAlert(strMSG as String)
                                }
                            }
                        }
                        
                    case .failure(let encodingError):
                        //self.delegate?.showFailAlert()
                        print(encodingError)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
            else{
                print("Internet Not Connected")
                self.showAlert("You are Not Connected to Internet")
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
