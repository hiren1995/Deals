//
//  RateBuyer.swift
//  Deals
//
//  Created by iosdeveloper on 01/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage

class RateBuyer: UIViewController {
    
    @IBOutlet weak var ratingBar: AARatingBar!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var strPostId = String()
    var strPostImage = String()
    var strPostTitle = String()
    var strPostPrice = String()
    var strPostDesc = String()
    var strUserId = String()
    var strUserName = String()
    var strUserImage = String()
    var strRating = String()
    var strnotificationID = String()
    
    var SBoard = UIStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        menuView.dropShadow(scale: true)
        
        //Post Image
        let ProfileUrl = postImageURL + (strPostImage as String)
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholder = UIImage(named: "icon_no_image")
        postImage.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholder
        )
        
        postTitle.text = strPostTitle as String
        postPrice.text = strPostPrice as String + "$"
        postDesc.text = strPostDesc as String
        userName.text = strUserName as String
        
        //User Image
        let userProfileUrl = ProfileImageURL + (strUserImage as String)
        let userProfilePic = URL(string:userProfileUrl)
        let userplaceholder = UIImage(named: "icon_no_image")
        userImage.af_setImage(
            withURL: userProfilePic!,
            placeholderImage: userplaceholder
        )
        userImage.setRoundedWithBorder()
        
        ratingBar.ratingDidChange = { ratingValue in
            // get current selected rating
            self.strRating = String(describing: ratingValue)
            print("Rating Value is:\(self.strRating)")
        }
    }
    //MARK: - IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateBuyer(_ sender: Any) {
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "receiver_user_id" :  strUserId,
                                       "rating" : strRating,
                                       "post_id" : strPostId,
                                       "notification_id" : strnotificationID]
        
        print("Parameters for Add Rate are:\(parameters)")
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(addRateAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                    
                            let initialView = self.SBoard.instantiateViewController(withIdentifier: "HomeView")
                            let menuView = self.SBoard.instantiateViewController(withIdentifier: "MenuView")
                            
                            let mainView : SWRevealViewController = SWRevealViewController(rearViewController: menuView, frontViewController: initialView)
                            mainView.rightViewController = menuView
                            self.present(mainView, animated: true, completion: nil)
                    }
                }
                
                break
                
            case .failure(_):
                print("Notifications List error:\(response.result.error!)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
                break
                
            }
        }
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
