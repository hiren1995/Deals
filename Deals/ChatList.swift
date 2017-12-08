//
//  ChatList.swift
//  Deals
//
//  Created by Mohit on 08/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ChatList: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataArray = NSArray()
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var dataTable: UITableView!
    
    @IBOutlet weak var lblNoMSG: UILabel!
    
    var strIsUpdate : Bool = false
    var strChatRandomID = String()
    var roomids = [Int]()
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if isKeyPresentInUserDefaults(key: "roomids")
        {
            // now val is not nil and the Optional has been unwrapped, so use it
             roomids  = UserDefaults.standard.object(forKey: "roomids") as! [Int]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

          NotificationCenter.default.addObserver(self, selector: #selector(messageReceived(notification:)), name: NSNotification.Name("MessageNotification"), object: nil)
        
        lblNoMSG.isHidden = true
        lblNoMSG.text = "No user has contact you.\n Please start selling to get response from other users".localized
        
        menuView.dropShadow(scale: true)
        self.dataTable.isHidden = true
        self.getMessages()
        if strIsUpdate{
            self.getMessages()
        }
        
        udefault.set(false, forKey: "ISNewMSG")
        
//        if udefault.object(forKey: "ChatIDArray") != nil{
//            let arr = udefault.object(forKey: "ChatIDArray")
//            print("Chat ID Array :\(arr)")
//        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnBack(_ sender: Any) {
        self.goToHome()
    }
    
    func goToHome(){
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        let initialView = SBoard.instantiateViewController(withIdentifier: "HomeView")
        let menuView = SBoard.instantiateViewController(withIdentifier: "MenuView")
        
        let mainView : SWRevealViewController = SWRevealViewController(rearViewController: menuView, frontViewController: initialView)
        mainView.rightViewController = menuView
        self.present(mainView, animated: true, completion: nil)
    }
    
    func getMessages(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
       // MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getMessageList, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Message List Response is:\(tempDic)")
                    
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
                        self.dataArray = tempDic.object(forKey: "data") as! NSArray
                        print("Message Array is:\(self.dataArray)")
                        
                        if self.dataArray.count > 0{
                            self.dataTable.isHidden = false
                            self.lblNoMSG.isHidden = true
                            self.dataTable.reloadData()
                        }
                        else{
                            self.lblNoMSG.isHidden = false
                        }
                    }
                }
                
                break
                
            case .failure(_):
                print("Category List error:\(response.result.error!)")
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
        
       let cell : msgListCell = tableView.dequeueReusableCell(withIdentifier: "msgList", for: indexPath) as! msgListCell
        
        //profile pic
        let tempimgURL = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "profile_pic") as? String
        
        let ProfileUrl = ProfileImageURL + tempimgURL!
        
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholder = UIImage(named: "icon_profile_default")
        cell.imgView.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholder
        )
        cell.imgView.setRoundedWithBorder()
        
        let chatRID = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "chat_random_id") as? String
        if chatRID == strChatRandomID{
            self.goToChatingScreen(indexPath.row)
        }
        
       
        //UserName
        cell.lblName.text = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "full_name") as? String
        //Title
        cell.lblTitle.text = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "post_title") as? String
        
        //Date
        /*
            let tempDate = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "created_at") as? String
            let tempDate = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "sent") as? String
         */
        
        
        let tempDate = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "sent" ) as? String
        print(tempDate)
        
        let tempIntDate:Int = (tempDate as! NSString).integerValue
        
        print(tempIntDate)
       
        print(milliSecondsToDate(tempIntDate))
        
        let convertedDateStr = milliSecondsToDate(tempIntDate)
       
        cell.lblDate.text = convertDateFormater(convertedDateStr)
        
        cell.lblName.textColor = UIColor.darkGray
        
        for var i in 0..<roomids.count
        {
            if (roomids[i] == Int(chatRID!)!)
            {
                cell.lblName?.font = UIFont.boldSystemFont(ofSize: 17)
                cell.lblName.textColor = UIColor(red: 57/255.0, green: 146.0/255.0, blue: 76/255.0, alpha: 1.0)
                cell.lblDate?.font = UIFont.boldSystemFont(ofSize: 17)
                cell.lblDate.textColor = UIColor.black
            }
           
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToChatingScreen(indexPath.row)
    }
    
    
    func messageReceived (notification : NSNotification)
    {
        print(notification)
        print("Notification Received")
        if isKeyPresentInUserDefaults(key: "roomids")
        {
            // now val is not nil and the Optional has been unwrapped, so use it
            roomids  = UserDefaults.standard.object(forKey: "roomids") as! [Int]
        }
        
        self.dataTable.reloadData()
       
    }

    //Date Format Convert Function
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd"
        return  dateFormatter.string(from: date!)
    }
    
    func milliSecondsToDate(_ milliseconds : Int) -> String
    {
        let date = NSDate(timeIntervalSince1970: TimeInterval(milliseconds/1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        let x = formatter.string(from: date as Date)
        print(x)
        
        return x
    }
    
    func goToChatingScreen(_ index : Int){
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        let chatScreen = SBoard.instantiateViewController(withIdentifier: "chatScreen") as! ChatingScreen
        chatScreen.strUserName = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "full_name") as? String)!
        let strproductImg = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "images") as? String)!
        let ImgArr = strproductImg.components(separatedBy: ",")
        let imgURL    = ImgArr[0]
        chatScreen.strproductImg = imgURL
        chatScreen.strPostId = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "post_id") as? String)!
        chatScreen.strotherUserId = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "user_id") as? String)!
        chatScreen.strProductTitle = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "post_title") as? String)!
        chatScreen.strChatRandomID = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "chat_random_id") as? String)!
        chatScreen.strIsBlock = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "is_block") as? String)!
        self.present(chatScreen, animated: true, completion: nil)
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
