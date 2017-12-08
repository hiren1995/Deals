//
//  ChooseBuyer.swift
//  Deals
//
//  Created by iosdeveloper on 01/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage

class ChooseBuyer: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray = NSArray()
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var staticView: UIView!
    var strPostId = String()
    var strPostImage = String()
    var strPostTitle = String()
    var strPostPrice = String()
    var strPostDesc = String()
    var strUserId = String()
    var strUserImage = String()
    var strUserName = String()
    
    var selectedIndex = -1
    
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
        staticView.dropShadow(scale: true)
        
        //Post Image
        let ProfileUrl = postImageURL + (strPostImage as String)
        print("Image URL:\(ProfileUrl)")
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholder = UIImage(named: "icon_no_image")
        postImage.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholder
        )
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateBuyer(_ sender: Any) {
        
        let rateView = SBoard.instantiateViewController(withIdentifier: "rateBuyer") as! RateBuyer
        rateView.strPostImage = strPostImage
        rateView.strPostPrice = strPostPrice
        rateView.strPostTitle = strPostTitle
        rateView.strPostDesc = strPostDesc
        rateView.strUserId = strUserId
        rateView.strUserName = strUserName
        rateView.strUserImage = strUserImage
        rateView.strPostId = strPostId
        rateView.strnotificationID = ""
        self.present(rateView, animated: true, completion: nil)
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : chooseBuyerCell = tableView.dequeueReusableCell(withIdentifier: "chooseList", for: indexPath) as! chooseBuyerCell
        
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
        
        if indexPath.row == selectedIndex {
            cell.btnSelect.setBackgroundImage(UIImage(named:"radio-on-button"), for: .normal)
        } else {
            cell.btnSelect.setBackgroundImage(UIImage(named:"circle-outline"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row;
        dataTable.reloadData()
        strUserId = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "user_id") as? String)!
        strUserName = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "full_name") as? String)!
        strUserImage = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "profile_pic") as? String)!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
