//
//  MyProfile.swift
//  Deals
//
//  Created by Mohit on 08/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage
import PinterestLayout

class MyProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var ratingBar: AARatingBar!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var ownSaleView: UIView!
    @IBOutlet weak var userSaleView: UIView!
    @IBOutlet weak var lblOwnSale: UILabel!
    @IBOutlet weak var lblOwnSaved: UILabel!
    @IBOutlet weak var lblUserSale: UILabel!
    @IBOutlet weak var dataCollection: UICollectionView!
    @IBOutlet weak var addPostView: UIView!
    
    @IBOutlet weak var viewDeleteMarkSold: UIView!
    @IBOutlet weak var viewAlpha: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMarkSold: UIButton!
    
    var deletePostValue = NSString()
    var markAsSoldValue = Int()
    var otherUserName = NSString()
    var otherUserImage = NSString()
    var otherUserId = NSString()
    var otherUserRating = NSString()
    var ownUserRating = NSString()
    
    var ownUser : Bool = false
    var dataArray = NSArray()
    var favDataArray = NSArray()
    
    
    var strCollectionType = "Sale"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.setRoundedWithBorder()
        self.viewDeleteMarkSold.isHidden = true
        self.viewAlpha.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hideViewAction(sender:)))
        self.viewAlpha.addGestureRecognizer(gesture)
        self.btnDelete.roundButton()
        self.btnMarkSold.roundButton()
        
        //PInterest Layout
        
        let layout = PinterestLayout()
        dataCollection.collectionViewLayout = layout
        
        layout.delegate = self as PinterestLayoutDelegate
        layout.cellPadding = 5
        layout.numberOfColumns = 2
        
        dataCollection.collectionViewLayout.invalidateLayout()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dataCollection.isHidden = true
        self.getDatafromAPI()
        
        if ownUser{
            self.getFavouritePost()
            userName.text = udefault.object(forKey: MUserName) as? String
            
            //profile pic
            let tempimgURL = udefault.object(forKey: "ProfilePic") as! String
            
            let ProfileUrl = ProfileImageURL + tempimgURL
            print("Profile URL:\(ProfileUrl)")
            
            let urlProfilePic = URL(string:ProfileUrl)
            profileImage.af_setImage(
                withURL: urlProfilePic!,
                placeholderImage: nil
            )
            ratingBar.value = CGFloat(ownUserRating.floatValue)
            editButton.isHidden = false
            ownSaleView.isHidden = false
            userSaleView.isHidden = true
            addPostView.isHidden = false
        }
        else{
            userName.text = otherUserName as String
            
            let ProfileUrl = ProfileImageURL + (otherUserImage as String)
            print("Profile URL:\(ProfileUrl)")
            
            let urlProfilePic = URL(string:ProfileUrl)
            profileImage.af_setImage(
                withURL: urlProfilePic!,
                placeholderImage: nil
            )
            ratingBar.value = CGFloat(otherUserRating.floatValue)
            editButton.isHidden = true
            ownSaleView.isHidden = true
            userSaleView.isHidden = false
            addPostView.isHidden = true
        }
    }
    
    func hideViewAction(sender : UITapGestureRecognizer) {
        self.viewDeleteMarkSold.isHidden = true
        self.viewAlpha.isHidden = true
    }
    
    func getDatafromAPI(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! NSString
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "other_user_id" : otherUserId]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        print("URL is:\(getProfilePost)")
        print("Parameters are:\(parameters)")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getProfilePost, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
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
                            self.lblOwnSale.text = String(self.dataArray.count)
                            self.lblUserSale.text = String(self.dataArray.count)
                            self.dataCollection.isHidden = false
                            self.dataCollection.reloadData()
                        }
                    }
                }
                
                break
                
            case .failure(_):
                print("Profile Post List error:\(response.result.error!)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
                break
                
            }
        }
    }
    
    func getFavouritePost(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! NSString
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        print("URL is:\(getFavPost)")
        print("Parameters are:\(parameters)")
    
        Alamofire.request(getFavPost, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
                        self.favDataArray = tempDic.object(forKey: "data") as! NSArray
                        print("Favoutrite data Array is:\(self.favDataArray)")
                        
                        if self.favDataArray.count > 0{
                            self.lblOwnSaved.text = String(self.favDataArray.count)
                            self.dataCollection.isHidden = false
                            //self.dataCollection.reloadData()
                        }
                    }
                }
                
                break
                
            case .failure(_):
                print("Profile Post List error:\(response.result.error!)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
                break
                
            }
        }
    }
    
    //MARK:- IBAction Methods

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToAddPost(_ sender: Any) {
        
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
    
    @IBAction func editMyProfile(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let updateView = SBoard.instantiateViewController(withIdentifier: "updateProfile") as! UpdateProfile
        self.present(updateView, animated: true, completion: nil)
    }
    
    @IBAction func ownSavedClicked(_ sender: Any) {
        strCollectionType = "Saved"
        self.dataCollection.reloadData()
    }
    
    @IBAction func ownSaleClicked(_ sender: Any) {
        strCollectionType = "Sale"
        self.dataCollection.reloadData()
    }
    
    @IBAction func Postdelete(_ sender: Any) {
        self.deletePost(deletePostValue as String)
    }
    
    @IBAction func markasSoldPost(_ sender: Any) {
        self.markAsSold(markAsSoldValue)
    }
    
    //MARK: - Collection view delegate method
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if strCollectionType == "Sale"{
            return dataArray.count
        }
        else{
            return favDataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.view.frame.size.width - 5) / 2  //some width
        //let height = width //ratio
        return CGSize(width: width, height: 200);
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilepostCell", for: indexPath) as! ProfilePostListCell
        
        if strCollectionType == "Sale"{
            //Post Pic
            let tempimgURL = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "images") as? String
            
            let ImgArr = tempimgURL?.components(separatedBy: ",")
            let imgURL    = ImgArr?[0]
            
            let ProfileUrl = postImageURL + imgURL!
            print("Image URL:\(ProfileUrl)")
            
            let urlProfilePic = URL(string:ProfileUrl)
            let placeholder = UIImage(named: "icon_no_image")
            cell.postImage.af_setImage(
                withURL: urlProfilePic!,
                placeholderImage: placeholder
            )
            cell.postImage.contentMode = .scaleAspectFill
            cell.postImage.layer.masksToBounds = true
            
            //Post Title
            let tempTitle = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "post_title") as? String
            cell.lblTitle.text = tempTitle?.decodeString
            //Post Price
            let tempPrice = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "price") as? String
            cell.lblPrice.text = tempPrice! + "$"
            
            //Is Sold or not
            let tempSoldId = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "is_sold") as? String
            if tempSoldId == "1"{
                cell.soldImage.isHidden = false
                cell.deleteButton.isHidden = true
            }
            else{
                cell.soldImage.isHidden = true
                cell.deleteButton.isHidden = false
            }
            //Delete Button
            if ownUser{
                cell.deleteButton.isHidden = false
                cell.deleteButton.tag = indexPath.row
                cell.deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
            }
            else{
                cell.deleteButton.isHidden = true
            }
        }
        else{
            //Post Pic
            let tempimgURL = ((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "images") as? String
            
            let ImgArr = tempimgURL?.components(separatedBy: ",")
            let imgURL    = ImgArr?[0]
            
            let ProfileUrl = postImageURL + imgURL!
            print("Image URL:\(ProfileUrl)")
            
            let urlProfilePic = URL(string:ProfileUrl)
            let placeholder = UIImage(named: "icon_no_image")
            cell.postImage.af_setImage(
                withURL: urlProfilePic!,
                placeholderImage: placeholder
            )
            cell.deleteButton.isHidden = true
            //Post Title
            let tempTitle = ((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "post_title") as? String
            cell.lblTitle.text = tempTitle?.decodeString
            //Post Price
            let tempPrice = ((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "price") as? String
            cell.lblPrice.text = tempPrice! + "$"
            //Is Sold or not
            let tempSoldId = ((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "is_sold") as? String
            if tempSoldId == "1"{
                cell.soldImage.isHidden = false
            }
            else{
                cell.soldImage.isHidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let detailView = SBoard.instantiateViewController(withIdentifier: "postDetails") as! PostDetails
        if strCollectionType == "Sale"{
            detailView.dataArray = (self.dataArray as NSArray).object(at: indexPath.row) as! NSDictionary
        }
        else{
            detailView.dataArray = (self.favDataArray as NSArray).object(at: indexPath.row) as! NSDictionary
        }
        self.present(detailView, animated: true, completion: nil)
    }
    
    func deleteAction(_ sender: UIButton){
        print("Delete Button Clicked")
        let tempPostId = ((self.dataArray as NSArray).object(at: sender.tag) as AnyObject).value(forKey: "post_id") as? String
        self.deletePostValue = tempPostId! as NSString
        self.markAsSoldValue = sender.tag
        self.viewAlpha.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: CGFloat(0.6))
        self.viewAlpha.isHidden = false
        self.viewDeleteMarkSold.isHidden = false
        self.view.bringSubview(toFront: viewDeleteMarkSold)
    }
    
    func deletePost(_ index : String){
        
        self.viewDeleteMarkSold.isHidden = true
        self.viewAlpha.isHidden = true
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "post_id" : index]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(deletePostAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        self.getDatafromAPI()
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
    
    func markAsSold(_ index : Int){
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let markSoldView = SBoard.instantiateViewController(withIdentifier: "soldList") as! MarkAsSold
        //Post Image
        let tempimgURL = ((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "images") as? String
        
        let ImgArr = tempimgURL?.components(separatedBy: ",")
        let imgURL    = ImgArr?[0]

        markSoldView.strPostImage = imgURL! as String
        //Post Title 
        markSoldView.strPostTile = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "post_title") as? String)!
        //Post Price 
        markSoldView.strPostPrice = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "price") as? String)!
        //Post Id 
        markSoldView.strPostId = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "post_id") as? String)!
        //PostDesc 
        markSoldView.strPostDesc = (((self.dataArray as NSArray).object(at: index) as AnyObject).value(forKey: "post_desc") as? String)!
        
        self.present(markSoldView, animated: true, completion: nil)
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
extension MyProfile: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        //  let image = imageHeight[indexPath.item] as NSString
        
        //var random = String()
        
        if strCollectionType == "Sale"{
            
            
            
            
            let randomNo = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "random_number") as? String)!
            
            
            let imageHeightn = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "height")as? String)
            
            if imageHeightn?.characters.count == 0
            {
                
                return CGFloat(Float(randomNo)!)
            }
            else
            {
                
                let imageWidthn = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "width")as? String)
                let width = (self.view.frame.size.width - 5) / 2
                
                let height  = width  * CGFloat(Float(imageHeightn!)!/Float(imageWidthn!)!)
                
                
                return CGFloat(height-20)
            }

           // random = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "random_number") as? String)!
        }
        else{
            
            
            
            let randomNo = (((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "random_number") as? String)!
            
            
            let imageHeightn = (((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "height")as? String)
            
            if imageHeightn?.characters.count == 0
            {
                
                return CGFloat(Float(randomNo)!)
            }
            else
            {
                
                let imageWidthn = (((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "width")as? String)
                let width = (self.view.frame.size.width - 5) / 2
                
                let height  = width  * CGFloat(Float(imageHeightn!)!/Float(imageWidthn!)!)
                
                
                return CGFloat(height-20)
            }

//            random = (((self.favDataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "random_number") as? String)!
        }

       // return CGFloat(Float(random)!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        //  let textFont = UIFont(name: "Arial-ItalicMT", size: 11)!
        return 70.0
    }
}
