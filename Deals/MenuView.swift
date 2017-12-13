//
//  MenuView.swift
//  Deals
//
//  Created by Mohit on 29/09/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import AlamofireImage



class MenuView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let titleArray = ["My Profile","Browse","Post","Chat","Categories","About","Logout"]
    let imageArray = ["icon_profile","icon_home","icon_post","icon_chat","icon_profile","icon_about","icon_log_out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblName.text = udefault.object(forKey: MUserName) as? String
        
        //profile pic
        let tempimgURL = udefault.object(forKey: "ProfilePic") as! String
        
        let ProfileUrl = ProfileImageURL + tempimgURL
        print("Profile URL:\(ProfileUrl)")
        
        let urlProfilePic = URL(string:ProfileUrl)
        profileImage.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: nil
        )
        profileImage.setRoundedWithBorder()
        
        if isArabic{
            
            profileImage.frame.origin.x = 230
            profileImage.frame.origin.y = 35
        }
        else
        {
            profileImage.frame.origin.x = 10
            profileImage.frame.origin.y = 35
        }
       
    }
    
    //MARK: - UITableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! menuCell
        if indexPath.row == 3{
         
            let strNewMsg : Bool =  udefault.bool(forKey: "ISNewMSG")
            if strNewMsg{
                cell.imgIcon.image = UIImage(named: "icon_chat_dot")
            }
            else{
                cell.imgIcon.image = UIImage(named: imageArray[indexPath.row])
            }
        }
        else{
            cell.imgIcon.image = UIImage(named: imageArray[indexPath.row])
        }
        cell.lblTitle.text = titleArray[indexPath.row].localized
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            var SBoard = UIStoryboard()
            if isArabic{
                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            }
            else{
                SBoard = UIStoryboard(name: "Main", bundle: nil)
            }
            let myProfile = SBoard.instantiateViewController(withIdentifier: "myProfile") as! MyProfile
            myProfile.ownUser = true
            myProfile.otherUserId = udefault.value(forKey: MUserID) as! NSString
            
            
            var tempRating:NSString? = nil
            
            if(udefault.value(forKey: "OwnUserRatingMenuView") != nil)
            {
                tempRating = udefault.value(forKey: "OwnUserRatingMenuView") as! NSString
            }
            
            print(tempRating)
            
           
            if tempRating == nil{
                myProfile.ownUserRating = "0"
            }
            else{
                myProfile.ownUserRating = tempRating!
            }
            
            
                
            self.present(myProfile, animated: true, completion: nil)
        }
        else if indexPath.row == 1{
            
            udefault.removeObject(forKey: MCategoryID)
            self.goToHome()
        }
        else if indexPath.row == 2{
            var SBoard = UIStoryboard()
            if isArabic{
                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            }
            else{
                SBoard = UIStoryboard(name: "Main", bundle: nil)
            }
            let addPostView = SBoard.instantiateViewController(withIdentifier: "addPost") as! AddPost
            self.present(addPostView, animated: true, completion: nil)
        }
        else if indexPath.row == 3{
            var SBoard = UIStoryboard()
            if isArabic{
                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            }
            else{
                SBoard = UIStoryboard(name: "Main", bundle: nil)
            }
            udefault.set(false, forKey: "ISNewMSG")
            let catList = SBoard.instantiateViewController(withIdentifier: "chatList") as! ChatList
            catList.strIsUpdate = true
            self.present(catList, animated: true, completion: nil)
        }
        else if indexPath.row == 4{
            var SBoard = UIStoryboard()
            if isArabic{
                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            }
            else{
                SBoard = UIStoryboard(name: "Main", bundle: nil)
            }
            let catList = SBoard.instantiateViewController(withIdentifier: "categoryList") as! Category
            catList.openType = "Menu"
            self.present(catList, animated: true, completion: nil)
        }
        else if indexPath.row == 5{
            var SBoard = UIStoryboard()
            if isArabic{
                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            }
            else{
                SBoard = UIStoryboard(name: "Main", bundle: nil)
            }
            let aboutView = SBoard.instantiateViewController(withIdentifier: "about") as! About
            self.present(aboutView, animated: true, completion: nil)
        }
        else if indexPath.row == 6{
            //Logout User
            udefault.removeObject(forKey: MLangugae)
            udefault.removeObject(forKey: MDeiveToken)
            udefault.removeObject(forKey: MUserID)
            udefault.removeObject(forKey: MUserToken)
            udefault.removeObject(forKey: MUserEmail)
            udefault.removeObject(forKey: MUserName)
            udefault.removeObject(forKey: MCountryName)
            udefault.removeObject(forKey: MCountryID)
            udefault.removeObject(forKey: MCityName)
            udefault.removeObject(forKey: MCityyID)
            udefault.removeObject(forKey: MCityyArray)
            udefault.removeObject(forKey: MUserLatitude)
            udefault.removeObject(forKey: MUserLongitude)
            udefault.removeObject(forKey: MCategoryID)
            udefault.removeObject(forKey: "Login")
            
            let langView = sBoard.instantiateViewController(withIdentifier: "LanguageView") as! SelectLanguage
            self.present(langView, animated: true, completion: nil)
        }
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
