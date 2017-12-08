//
//  MarkAsSold.swift
//  Deals
//
//  Created by iosdeveloper on 01/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage

class MarkAsSold: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray = NSArray()
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var rateBtn: UIButton!
    
    var strPostImage = String()
    var strPostTile = String()
    var strPostPrice = String()
    var strPostId = String()
    var strPostDesc = String()
    
    var SBoard = UIStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }


        // Do any additional setup after loading the view.
        menuView.dropShadow(scale: true)
        self.dataTable.isHidden = true
        rateBtn.isHidden = true
        self.getBuyerList()
        
        //Post Image
        let ProfileUrl = postImageURL + (strPostImage as String)
        print("Image URL:\(ProfileUrl)")
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholder = UIImage(named: "icon_no_image")
        postImage.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholder
        )
        
        postTitle.text = strPostTile as String
        postPrice.text = strPostPrice as String + "$"
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func rateBuyer(_ sender: Any) {
        
        let chooseView = SBoard.instantiateViewController(withIdentifier: "choosebuyer") as! ChooseBuyer
        chooseView.dataArray = dataArray
        chooseView.strPostImage = strPostImage
        chooseView.strPostPrice = strPostPrice
        chooseView.strPostTitle = strPostTile
        chooseView.strPostDesc = strPostDesc
        chooseView.strPostId = strPostId
        self.present(chooseView, animated: true, completion: nil)
    }
    
    func getBuyerList(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "post_id" : strPostId]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getMessageList, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
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
                            self.dataTable.reloadData()
                            self.rateBtn.isHidden = false
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
        
        let cell : soldCell = tableView.dequeueReusableCell(withIdentifier: "soldList", for: indexPath) as! soldCell
        
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
        
        //UserName
        cell.lblName.text = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "full_name") as? String
        //Title
        cell.lblTitle.text = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "messsage") as? String
        //Date
        let tempDate = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "created_at") as? String
        cell.lblDate.text = convertDateFormater(tempDate!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //Date Format Convert Function
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd"
        return  dateFormatter.string(from: date!)
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
