//
//  PostDetails.swift
//  Deals
//
//  Created by Mohit on 08/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class PostDetails: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ratingBar: AARatingBar!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblUpLocation: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDownLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCountryCity: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var imageDetailsView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrlView = UIScrollView()
    var dataArray = NSDictionary()
    var ownUser : Bool = false
    
    var shareImage = UIImage()
    var shareImageURL = String()
    let downloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let ownUID = dataArray.object(forKey: "owner_user_id") as! String
        let myUID = udefault.object(forKey: MUserID) as! String
        
        if ownUID == myUID{
            ownUser = true
        }
        
        if ownUser{
            btnFav.isHidden = true
            btnMsg.isHidden = true
            btnEdit.isHidden = false
            btnReport.isHidden = true
        }
        else{
            btnFav.isHidden = false
            btnMsg.isHidden = false
            btnEdit.isHidden = true
            btnReport.isHidden = false
        }

        // Do any additional setup after loading the view.
        self.setScrollView()
        
        print("Data Dictionary is:\(dataArray)")
     
        
        
        //var decodedResponse = dataArray.object(forKey: "category_arabic") as? String.stringByReplacingEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        //print(decodedResponse)
        
        
        if dataArray.object(forKey: "favorite_id") as? String == nil{
            btnFav.setBackgroundImage(UIImage(named:"icon_heart"), for: .normal)
        }
        else{
            btnFav.setBackgroundImage(UIImage(named:"icon_heart_filled"), for: .normal)
        }
        //User Image
        
        //profile pic
        let tempimgURL = dataArray.object(forKey: "profile_pic") as! String
        
        let ProfileUrl = ProfileImageURL + tempimgURL
        print("Image URL:\(ProfileUrl)")
        
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholder = UIImage(named: "icon_profile_default")
        userImage.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholder
        )
        
        userImage.setRoundedWithBorder()
        
        let tempTitle = dataArray.object(forKey: "post_title") as? String
        lblTitle.text = tempTitle?.decodeString
        
        //let tempCategory = dataArray.object(forKey: "category_name") as? String
        //lblCategory.text = tempCategory?.decodeString
        
        let tempLocation = dataArray.object(forKey: "location") as? String
       // lblUpLocation.text = tempLocation?.decodeString
        lblDownLocation.text = tempLocation?.decodeString
        lblUserName.text = dataArray.object(forKey: "full_name") as? String
        let tempDesc = dataArray.object(forKey: "post_desc") as? String
        lblDescription.text = tempDesc?.decodeString
        
        //lblCountryCity.text = (dataArray.object(forKey: "country_english") as? String)! + ", " + (dataArray.object(forKey: "city_english") as? String)!
        
        let tempPrice = dataArray.object(forKey: "price") as? String
        lblPrice.text = "$" + tempPrice!
        
        let ratingValue = dataArray.object(forKey: "rating") as? NSString
        if ratingValue == nil{
            ratingBar.value = 0.0
            lblRating.text = "0.0"
        }
        else{
            ratingBar.value = CGFloat((ratingValue?.floatValue)!)
            lblRating.text = String(describing: CGFloat((ratingValue?.floatValue)!))
        }
        
        if isArabic
        {
            let tempCategory = dataArray.object(forKey: "category_arabic") as? String
            lblCategory.text = tempCategory?.decodeString
            
            lblCountryCity.text = (dataArray.object(forKey: "country_arabic") as? String)! + ", " + (dataArray.object(forKey: "city_arabic") as? String)!
        }
        else
        {
            let tempCategory = dataArray.object(forKey: "category_name") as? String
            lblCategory.text = tempCategory?.decodeString
            
            lblCountryCity.text = (dataArray.object(forKey: "country_english") as? String)! + ", " + (dataArray.object(forKey: "city_english") as? String)!
        }
        
    }
    
    
    
    func setScrollView(){
        
        scrlView = UIScrollView(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: imageDetailsView.frame.size.height))
        scrlView.isPagingEnabled = true
        scrlView.alwaysBounceVertical = false
        scrlView.delegate = self
      
        let tempimgURL = dataArray.object(forKey: "images") as? String
        
        print(tempimgURL)
        
        let ImageArr = tempimgURL?.components(separatedBy: ",")
        
        if let arr = ImageArr{
        for i in 0..<arr.count{
            let xOrigin: CGFloat = CGFloat(i) * scrlView.frame.size.width
            let imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: scrlView.frame.size.width, height: scrlView.frame.size.height))
        
            let imgURL    = ImageArr?[i]
            shareImageURL = (ImageArr?[0])!
            
            let ProfileUrl = postImageURL + imgURL!
            print("Image URL:\(ProfileUrl)")
            let urlProfilePic = URL(string:ProfileUrl)
            let placeholder = UIImage(named: "icon_no_image")
            imageView.af_setImage(
                withURL: urlProfilePic!,
                placeholderImage: placeholder
            )
            
            imageView.contentMode = .scaleToFill
            scrlView.addSubview(imageView)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
        scrlView.contentSize = CGSize(width: scrlView.frame.size.width * CGFloat((ImageArr?.count)!), height: scrlView.frame.size.height)
            self.DownloadImageForShare()
        }
        pageControl.numberOfPages = (ImageArr?.count)!
        pageControl.currentPageIndicatorTintColor = UIColor.green
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.tempView.addSubview(scrlView)
        self.tempView.bringSubview(toFront: pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       let imageDetails = sBoard.instantiateViewController(withIdentifier: "imageDetails") as! ImageShow
        imageDetails.dataArray = dataArray
        self.present(imageDetails, animated: true, completion: nil)
    }
    
    func DownloadImageForShare(){
        
        let postUrl = postImageURL + shareImageURL
        let urlRequest = URLRequest(url: URL(string: postUrl)!)
        
        downloader.download(urlRequest) { response in
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print(image)
                self.shareImage = image
            }
        }
    }

    //MARK: - IBAction Methods
    
    @IBAction func shareClicked(_ sender: Any) {
        
        let tempTitle = dataArray.object(forKey: "post_title") as? String
        let tempPrice = (dataArray.object(forKey: "price") as? String)! + " $"
        
        let shareText : String = tempTitle! + "(\(tempPrice))"
    
        var objectsToShare = [AnyObject]()
        objectsToShare.append(shareText as AnyObject)
        objectsToShare.append(shareImage)
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func reportPostClicked(_ sender: Any) {
        
        /*
        
        let alert = UIAlertController(title: "Deals", message: "Are you sure you wants to Report this post?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
        
            self.reportThisPost()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
 
        */
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let reportItem = SBoard.instantiateViewController(withIdentifier: "reportitem") as! Reportitem
        reportItem.itemUrl = dataArray.object(forKey: "images") as? String
        reportItem.dataArray = dataArray
        //reportItem.strType = "Server"
        self.present(reportItem, animated: true, completion: nil);
    }
    
    @IBAction func favouriteClicked(_ sender: Any) {
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        let tempPostId = dataArray.object(forKey: "post_id") as? String
        var tempIsFav = ""
        if dataArray.object(forKey: "favorite_id") as? String == nil{
            tempIsFav = "add"
            btnFav.setBackgroundImage(UIImage(named:"icon_heart_filled"), for: .normal)
        }
        else{
            tempIsFav = "remove"
            btnFav.setBackgroundImage(UIImage(named:"icon_heart"), for: .normal)
        }
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "post_id" : tempPostId!,
                                       "action": tempIsFav]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        Alamofire.request(FavouritePost, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                       print("done")
                    }
                }
                
                break
                
            case .failure(_):
                print("Favourite Post error:\(response.result.error!)")
                
                break
                
            }
        }
    }

    @IBAction func messageClicked(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        let chatScreen = SBoard.instantiateViewController(withIdentifier: "chatScreen") as! ChatingScreen
        chatScreen.strUserName = (dataArray.object(forKey: "full_name") as! NSString) as String
        let strproductImg = dataArray.object(forKey: "images") as? String
        let ImgArr = strproductImg?.components(separatedBy: ",")
        let imgURL    = ImgArr?[0]
        chatScreen.strproductImg = imgURL!
        chatScreen.strPostId = (dataArray.object(forKey: "post_id") as! NSString) as String
        chatScreen.strotherUserId = (dataArray.object(forKey: "user_id") as! NSString) as String
        chatScreen.strProductTitle = (dataArray.object(forKey: "post_title") as! NSString) as String
        self.present(chatScreen, animated: true, completion: nil)
    }
    
    @IBAction func editPostClicked(_ sender: Any) {
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let updatePost = SBoard.instantiateViewController(withIdentifier: "updatePost") as! UpdatePost
        updatePost.dataDic = dataArray
        updatePost.strType = "Server"
        self.present(updatePost, animated: true, completion: nil);
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        let myProfile = SBoard.instantiateViewController(withIdentifier: "myProfile") as! MyProfile

        
        //let myProfile = sBoard.instantiateViewController(withIdentifier: "myProfile") as! MyProfile
        
        
        if ownUser{
            myProfile.ownUser = true
            myProfile.otherUserId = udefault.value(forKey: MUserID) as! NSString
            //myProfile.ownUserRating = dataArray.object(forKey: "rating") as! NSString
            if dataArray.object(forKey: "rating") as? NSString == nil{
                myProfile.ownUserRating = "0"
            }
            else{
                myProfile.ownUserRating = dataArray.object(forKey: "rating") as! NSString
            }
        }
        else{
            myProfile.ownUser = false
            myProfile.otherUserName = dataArray.object(forKey: "full_name") as! NSString
            myProfile.otherUserImage = dataArray.object(forKey: "profile_pic") as! NSString
            myProfile.otherUserId = dataArray.object(forKey: "user_id") as! NSString
            if dataArray.object(forKey: "rating") as? NSString == nil{
                myProfile.otherUserRating = "0"
            }
            else{
                myProfile.otherUserRating = dataArray.object(forKey: "rating") as! NSString
            }
            
        }
        self.present(myProfile, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: nil)
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let HomeView = SBoard.instantiateViewController(withIdentifier: "HomeView") as! ViewController
        
        self.present(HomeView, animated: true, completion: nil);
    }
    
    //Report Post Method
    /*
    func reportThisPost(){
        
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        let tempPostId = dataArray.object(forKey: "post_id") as? String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "post_id" : tempPostId!]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        Alamofire.request(ReportPostAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                break
                
            case .failure(_):
                print("Favourite Post error:\(response.result.error!)")
                
                break
                
            }
        }
    }
 
 */
 
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    func decodeEmojiMsg(_ s: String) -> String? {
        //let data = s.data(using: .utf8)!
        //return String(data: data, encoding: .nonLossyASCII)
        
        let data = s.data(using: .unicode)!
       
        return String(data: data, encoding: .nonLossyASCII)
        
    }
*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
