//
//  Notifications.swift
//  Deals
//
//  Created by iosdeveloper on 27/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage

class Notifications: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var lblNoNotification: UILabel!
    
    var dataArray = NSArray()
    
    var SBoard = UIStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        udefault.set(false, forKey: "ISNewNotification")
        
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }

        // Do any additional setup after loading the view.
        menuView.dropShadow(scale: true)
        dataTable.isHidden = true
        lblNoNotification.isHidden = true
        lblNoNotification.text = "No notifications found. \n Please start selling/buying to get notifications".localized
        self.getDataFromAPI()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnBack(_ sender: Any) {
        self.goToHome()
    }
    
    func goToHome(){
        
        let initialView = SBoard.instantiateViewController(withIdentifier: "HomeView")
        let menuView = SBoard.instantiateViewController(withIdentifier: "MenuView")
        
        let mainView : SWRevealViewController = SWRevealViewController(rearViewController: menuView, frontViewController: initialView)
        mainView.rightViewController = menuView
        self.present(mainView, animated: true, completion: nil)
    }
    
    func getDataFromAPI (){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "page" :  0]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getNotifications, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
                        self.dataArray = tempDic.object(forKey: "data") as! NSArray
                        print("data Array is:\(self.dataArray)")
                        
                        if self.dataArray.count > 0{
                            self.dataTable.isHidden = false
                            self.lblNoNotification.isHidden = true
                            self.dataTable.reloadData()
                        }
                        else{
                            self.lblNoNotification.isHidden = false
                        }
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
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : notificationCell = tableView.dequeueReusableCell(withIdentifier: "notifyCell", for: indexPath) as! notificationCell
        
        let dic = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "notification_object") as? NSDictionary
        
        let type = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "notification_type") as? String
        
        if type == "rating"{
            
            let tempimgURL = dic?.object(forKey: "profile_pic") as! String
            let ProfileUrl = ProfileImageURL + tempimgURL
            
            let urlProfilePic = URL(string:ProfileUrl)
            let placeholder = UIImage(named: "icon_profile_default")
            cell.imgView.af_setImage(
                withURL: urlProfilePic!,
                placeholderImage: placeholder
            )
            cell.imgView.setRoundedWithBorder()
            
            let tempUserid = udefault.value(forKey: MUserID) as! String
            let ownerId = dic?.object(forKey: "owner_user_id") as! String
            
            if isArabic{
                
                if tempUserid == ownerId{
                    //Notification Text
                    let tempName = dic?.object(forKey: "full_name") as! String
                    let tempRating = dic?.object(forKey: "rating_star") as! String
                    cell.lblName.text = tempName + " قيّمك" + tempRating + ". "
                }
                else{
                    //Notification Text
                    let tempName = dic?.object(forKey: "full_name") as! String
                    let tempRating = dic?.object(forKey: "rating_star") as! String
                    cell.lblName.text = tempName + " قيّمك " + tempRating + ". " + "الرجاء تقييم تجربتك"
                }

                
            }
            else
            {
                if tempUserid == ownerId{
                    //Notification Text
                    let tempName = dic?.object(forKey: "full_name") as! String
                    let tempRating = dic?.object(forKey: "rating_star") as! String
                    cell.lblName.text = tempName + " rate you" + tempRating + ". "
                }
                else{
                    //Notification Text
                    let tempName = dic?.object(forKey: "full_name") as! String
                    let tempRating = dic?.object(forKey: "rating_star") as! String
                    cell.lblName.text = tempName + " rate you " + tempRating + ". " + "Please rate your experience."
                }
            }
            /*
            if tempUserid == ownerId{
                //Notification Text
                let tempName = dic?.object(forKey: "full_name") as! String
                let tempRating = dic?.object(forKey: "rating_star") as! String
                cell.lblName.text = tempName + " rate you" + tempRating + ". "
            }
            else{
                //Notification Text
                let tempName = dic?.object(forKey: "full_name") as! String
                let tempRating = dic?.object(forKey: "rating_star") as! String
                cell.lblName.text = tempName + " rate you " + tempRating + ". " + "Please rate your experience."
            }
             */
            
            let tempStrDate = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "created_at") as? String
          //  print("Date from server is:\(tempStrDate)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let tempdate = dateFormatter.date(from: tempStrDate!)!
           // print("Date is:\(tempdate)")
            let tempTime = tempdate.getElapsedInterval()
            //print("Converted Time:\( tempTime)")
            //Time
            cell.lblText.text = tempTime + " ago"
        }
        else{
            cell.imgView.image = UIImage(named: "icon_Notification")
            cell.lblName.text = dic?.object(forKey: "admin_message") as? String
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "notification_object") as? NSDictionary
        let type = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "notification_type") as? String
        
        if type == "rating"{
            let tempUserid = udefault.value(forKey: MUserID) as! String
            let ownerId = dic?.object(forKey: "owner_user_id") as! String
            
            if tempUserid != ownerId{
                
                let rateView = SBoard.instantiateViewController(withIdentifier: "rateBuyer") as! RateBuyer
                
                let tempNotificationId = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "notification_id") as? String
                rateView.strnotificationID = tempNotificationId!
                let tempPostId = dic?.object(forKey: "post_id") as! String
                rateView.strPostId = tempPostId
                let tempPostTitle = dic?.object(forKey: "post_title") as! String
                rateView.strPostTitle = tempPostTitle
                let tempPostOwnerId = dic?.object(forKey: "owner_user_id") as! String
                rateView.strUserId = tempPostOwnerId
                let tempPostDesc = dic?.object(forKey: "post_desc") as! String
                rateView.strPostDesc = tempPostDesc
                let tempPostPrice = dic?.object(forKey: "price") as! String
                rateView.strPostPrice = tempPostPrice
                let tempPostImages = dic?.object(forKey: "images") as! String
                //Post Image
                let ImgArr = tempPostImages.components(separatedBy: ",")
                let imgURL    = ImgArr[0]
                rateView.strPostImage = imgURL
                let tempUserId = dic?.object(forKey: "user_id") as! String
                rateView.strUserId = tempUserId
                let tempUserName = dic?.object(forKey: "full_name") as! String
                rateView.strUserName = tempUserName
                let tempProfilePic = dic?.object(forKey: "profile_pic") as! String
                rateView.strUserImage = tempProfilePic
                
                self.present(rateView, animated: true, completion: nil)
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
