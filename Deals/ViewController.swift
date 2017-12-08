//
//  ViewController.swift
//  Deals
//
//  Created by Mohit on 20/09/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage
import CoreLocation
import PinterestLayout

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var menuView: UIView!
    //@IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var dataCollection: UICollectionView!

    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewAlpha: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var btnArabic: UIButton!
    
    @IBOutlet weak var lblNoProduct: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var textSearch: UITextField!
    var strCountryName = String()
    var strCityName = String()
    var strType = String()
    var cityArray = NSArray()
    
    let locationManager = CLLocationManager()
    
    var dataArray = NSArray()
    var searchArray = NSArray()
    var strDataType = String()
    
    var SBoard = UIStoryboard()
    
    var refreshControl: UIRefreshControl!
    
    var imageHeight = ["150","200","250","200","220","120","270","310","190","200","150","250","350","200","220","120","270","310","190","200","150","250","350","200","220","120","270","310","190","200"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchView.isHidden = true
        textSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        lblNoProduct.isHidden = true
        lblNoProduct.text = "No Producs found. \n Please Change your search criteria to see best products available on Deals".localized
        
        //Pull to Refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged)
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        self.dataCollection.refreshControl = refreshControl
    
        //Add side menu using UIBarButton
//        btnMenu.target = self.revealViewController()
//        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //Add side menu using Custom Button
        
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            let revealViewController = self.revealViewController()
            btnMenu.addTarget(revealViewController, action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
            
            self.btnArabic.backgroundColor = UIColor(red: 75.0/255.0, green: 175.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            self.btnEnglish.backgroundColor = UIColor.white
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
            let revealViewController = self.revealViewController()
         btnMenu.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            self.btnEnglish.backgroundColor = UIColor(red: 75.0/255.0, green: 175.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            self.btnArabic.backgroundColor = UIColor.white
        }
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        menuView.dropShadow(scale: true)
        
        //Get Current Location
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //Filter PopUp
        viewCity.setBorder()
        viewCountry.setBorder()
        viewButtons.setBorder()
        self.viewFilter.isHidden = true
        self.viewAlpha.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hideViewAction(sender:)))
        self.viewAlpha.addGestureRecognizer(gesture)
        
        //Display Filer data if Available
        if udefault.object(forKey: MCountryName) != nil{
            textCountry.text = udefault.object(forKey: MCountryName) as? String
            strType = "Filter"
        }
        if udefault.object(forKey: MCityName) != nil{
            textCity.text = udefault.object(forKey: MCityName) as? String
        }
        
        self.getPostData()
        
        //PInterest Layout
        
        let layout = PinterestLayout()
        dataCollection.collectionViewLayout = layout
        
        layout.delegate = self as PinterestLayoutDelegate
        layout.cellPadding = 5
        layout.numberOfColumns = 2
        
        dataCollection.collectionViewLayout.invalidateLayout()
}
    
    override func viewWillAppear(_ animated: Bool) {
       // self.getPostData()
        //Display Filer data if Available
        if udefault.object(forKey: MCountryName) != nil{
            textCountry.text = udefault.object(forKey: MCountryName) as? String
        }
        if udefault.object(forKey: MCityName) != nil{
            textCity.text = udefault.object(forKey: MCityName) as? String
        }
        
        //Set Notification Icon as per it
        let strNewMsg : Bool =  udefault.bool(forKey: "ISNewNotification")
        if strNewMsg{
            btnNotification.setBackgroundImage(UIImage(named:"icon_notification_dot"), for: .normal)
        }
        else{
            btnNotification.setBackgroundImage(UIImage(named:"icon_notification"), for: .normal)
        }
    }
    
    func hideViewAction(sender : UITapGestureRecognizer) {
        self.viewFilter.isHidden = true
        self.viewAlpha.isHidden = true
        self.view.endEditing(true)
    }
    
    func refreshCollectionView(_ sender: Any) {
        //  Pull to Refresh CollectionView
        self.getPostData()
        refreshControl.endRefreshing()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        searchArray = dataArray.filter({(($0 as! [String:Any])["post_title"] as! String).localizedLowercase.contains(textSearch.text!)}) as NSArray
        print("Arr is:\(searchArray)")
        strDataType = "SearchData"
        self.dataCollection.reloadData()
    }
    
    func getPostData(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        var parameters = Parameters()
        
        var tempCatId = String()
         if udefault.object(forKey: MCategoryID) != nil{
            tempCatId = udefault.object(forKey: MCategoryID) as! String
        }
         else{
            tempCatId = ""
        }
        
        if strType == "Filter"{
           
            var tempCountryId = String()
            if udefault.object(forKey: MCountryID) != nil{
                tempCountryId = udefault.object(forKey: MCountryID) as! String
            }
            else{
                tempCountryId = ""
            }
            var tempCityId = String()
            if udefault.object(forKey: MCityyID) != nil{
                tempCityId = udefault.object(forKey: MCityyID) as! String
            }
            else{
                tempCityId = ""
            }
            
            parameters = ["user_id" : tempUserid,
                          "token" :tempToken,
                          "country_id" : tempCountryId,
                          "city_id" : tempCityId,
                          "latitude" : "22.3072",
                          "longitude" : "73.1812",
                          "category_id" : tempCatId]
        }
        else{
            parameters = ["user_id" : tempUserid,
                          "token" :tempToken,
                          "latitude" : "22.3072",
                          "longitude" : "73.1812",
                          "category_id" : tempCatId]
        }
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getPost, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        self.strDataType = ""
                        self.dataArray = tempDic.object(forKey: "data") as! NSArray
                        print("Data Array is:\(self.dataArray)")
                        
                        if self.dataArray.count > 0{
                            self.lblNoProduct.isHidden = true
                            self.dataCollection.isHidden = false
                            self.dataCollection.reloadData()
                        }
                        else{
                            self.lblNoProduct.isHidden = false
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
    
    //MARK:- IBAction Methods
    
    @IBAction func goToAddPost(_ sender: Any) {
    
        let addPostView = SBoard.instantiateViewController(withIdentifier: "addPost") as! AddPost
        self.present(addPostView, animated: true, completion: nil)
    }
    
    @IBAction func goToNotification(_ sender: Any) {
        
        udefault.set(false, forKey: "ISNewNotification")
        let notificationView = SBoard.instantiateViewController(withIdentifier: "notification") as! Notifications
        self.present(notificationView, animated: true, completion: nil)
    }
    
    @IBAction func searchClicked(_ sender: Any){
        searchView.isHidden = false
        menuView.bringSubview(toFront: searchView)
        textSearch.becomeFirstResponder()
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        searchView.isHidden = true
        strDataType = ""
        textSearch.text = ""
        textSearch.resignFirstResponder()
        self.dataCollection.reloadData()
    }
    
    @IBAction func filterClicked(_ sender: Any) {
        self.viewAlpha.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: CGFloat(0.6))
        self.viewAlpha.isHidden = false
        self.viewFilter.isHidden = false
        self.view.bringSubview(toFront: viewFilter)
        
    }
    
    @IBAction func countryClicked(_ sender: Any) {
        let countryList = SBoard.instantiateViewController(withIdentifier: "countryCity") as! CountryCityList
        countryList.strType = "Country"
        countryList.strViewType = "FilterView"
        self.present(countryList, animated: true, completion: nil)
    }
    
    @IBAction func cityClicked(_ sender: Any) {
        if textCountry.text == ""{
            self.showAlert("Please Select Country First")
        }
        else{
            let cityList = SBoard.instantiateViewController(withIdentifier: "countryCity") as! CountryCityList
            cityList.strType = "City"
            cityList.strViewType = "FilterView"
            cityList.cityArray = udefault.object(forKey: MCityyArray) as! NSArray
            self.present(cityList, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneFilter(_ sender: Any) {
        udefault.removeObject(forKey: MCategoryID)
        self.viewAlpha.isHidden = true
        self.viewFilter.isHidden = true
        strType = "Filter"
        self.dataCollection.isHidden = true
        self.getPostData()
    }
    
    @IBAction func clearFilter(_ sender: Any) {
        udefault.removeObject(forKey: MCategoryID)
        udefault.removeObject(forKey: MCountryID)
        udefault.removeObject(forKey: MCityyID)
        udefault.removeObject(forKey: MCountryName)
        udefault.removeObject(forKey: MCityName)
        udefault.removeObject(forKey: MCityyArray)
        strType = ""
        strDataType = ""
        textCountry.text = ""
        textCity.text = ""
        self.dataCollection.isHidden = true
        self.getPostData()
    }
    
    @IBAction func englishSelcted(_ sender: Any) {
        self.btnEnglish.backgroundColor = UIColor(red: 75.0/255.0, green: 175.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        self.btnArabic.backgroundColor = UIColor.white
        UserDefaults.standard.set(["en", "ar"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        isArabic = false
        udefault.set(false, forKey: "IsArabic")
        self.viewAlpha.isHidden = true
        self.viewFilter.isHidden = true
        
        //Remove Filter Data from User Defaults
//        udefault.removeObject(forKey: MCategoryID)
//        udefault.removeObject(forKey: MCountryID)
//        udefault.removeObject(forKey: MCityyID)
//        udefault.removeObject(forKey: MCountryName)
//        udefault.removeObject(forKey: MCityName)
//        udefault.removeObject(forKey: MCityyArray)
        
       // self.showAlert("You need to Restart App to Change Language of App")
    }
    
    @IBAction func arabicSelected(_ sender: Any) {
        self.btnArabic.backgroundColor = UIColor(red: 75.0/255.0, green: 175.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        self.btnEnglish.backgroundColor = UIColor.white
        UserDefaults.standard.set(["ar", "en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        isArabic = true
        udefault.set(true, forKey: "IsArabic")
        self.viewAlpha.isHidden = true
        self.viewFilter.isHidden = true
        
        //Remove Filter Data from User Defaults
//        udefault.removeObject(forKey: MCategoryID)
//        udefault.removeObject(forKey: MCountryID)
//        udefault.removeObject(forKey: MCityyID)
//        udefault.removeObject(forKey: MCountryName)
//        udefault.removeObject(forKey: MCityName)
//        udefault.removeObject(forKey: MCityyArray)
        
       // self.showAlert("You need to Restart App to Change Language of App")
    }
    
    //MARK: - Collection view delegate method
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if strDataType == "SearchData"{
            return searchArray.count
        }
        else{
            return dataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // let cell = collectionView.cellForItem(at: indexPath) as! postListCell
        //        cell.postImage.frame = CGRect(x: 0.0, y: 0.0, width: (self.view.frame.size.width - 5 )/2 , height: 350.0)
//        cell.detailsView.frame = CGRect(x: 0.0, y: cell.postImage.frame.size.height, width: (self.view.frame.size.width - 5 )/2, height: 50.0)
        
        let width = (self.view.frame.size.width - 5) / 2  //some width
      //  let height = width //ratio
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! postListCell
        
        //cell.contentView.dropShadow(scale: true)
        
        
        if strDataType == "SearchData"{
            //Search Data
            //Post pic
            let tempimgURL = ((self.searchArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "images") as? String
            
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
            let tempTitle = ((self.searchArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "post_title") as? String
            cell.lblTitle.text = tempTitle?.decodeString
            
            //Post Price
            let tempPrice = ((self.searchArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "price") as? String
            cell.lblPrice.text = tempPrice! + "$"
            
            //Fav Button
            let ownUID = ((self.searchArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "owner_user_id") as? String
            let myUID = udefault.object(forKey: MUserID) as! String
            
            if ((self.searchArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "favorite_id") as? String == nil{
                cell.heartButton.setBackgroundImage(UIImage(named:"icon_heart"), for: .normal)
            }
            else{
                cell.heartButton.setBackgroundImage(UIImage(named:"icon_heart_filled"), for: .normal)
            }
            
            if ownUID == myUID{
                cell.heartButton.isHidden = true
            }
            else{
                cell.heartButton.isHidden = false
            }
            cell.heartButton.tag = indexPath.row
            cell.heartButton.addTarget(self, action: #selector(masterAction(_:)), for: .touchUpInside)
            
            //Is Sold or not
            let tempSoldId = ((self.searchArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "is_sold") as? String
            if tempSoldId == "1"{
                cell.soldImage.isHidden = false
            }
            else{
                cell.soldImage.isHidden = true
            }
        }
        else{
            //Regular Data
            //Post pic
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
            
            //Post Title
            let tempTitle = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "post_title") as? String
            cell.lblTitle.text = tempTitle?.decodeString
            
            //Post Price
            let tempPrice = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "price") as? String
            cell.lblPrice.text = tempPrice! + "$"
            
            //Fav Button
            let ownUID = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "owner_user_id") as? String
            let myUID = udefault.object(forKey: MUserID) as! String
            
            if ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "favorite_id") as? String == nil{
                cell.heartButton.setBackgroundImage(UIImage(named:"icon_heart"), for: .normal)
            }
            else{
                cell.heartButton.setBackgroundImage(UIImage(named:"icon_heart_filled"), for: .normal)
            }
            
            if ownUID == myUID{
                cell.heartButton.isHidden = true
            }
            else{
                cell.heartButton.isHidden = false
            }
            cell.heartButton.tag = indexPath.row
            cell.heartButton.addTarget(self, action: #selector(masterAction(_:)), for: .touchUpInside)
            cell.heartButton.layer.setValue(indexPath.row, forKey: "index")
            
            //Is Sold or not
            let tempSoldId = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "is_sold") as? String
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
        if strDataType == "SearchData"{
            let detailView = SBoard.instantiateViewController(withIdentifier: "postDetails") as! PostDetails
            detailView.dataArray = (self.searchArray as NSArray).object(at: indexPath.row) as! NSDictionary
            self.present(detailView, animated: true, completion: nil)
        }
        else{
            let detailView = SBoard.instantiateViewController(withIdentifier: "postDetails") as! PostDetails
            detailView.dataArray = (self.dataArray as NSArray).object(at: indexPath.row) as! NSDictionary
            self.present(detailView, animated: true, completion: nil)
        }
    }
    
    func masterAction(_ sender: UIButton){
        print("Button Clicked")
        

//        let predicate = NSPredicate(format: "(post_title == 'test')")
//        let theOne = (dataArray as NSArray).filtered(using: predicate)
//        print("One is:\(theOne)")
        
//        let arr : Array = dataArray.filter({($0["post_title"] as! String).contains("test")})
        
//        let arr = dataArray.filter({(($0 as! [String:Any])["post_title"] as! String).contains("test")})
//        print("Arr is:\(arr)")
       // let arr = dataArray.filter({(($0 as! [String:Any])["post_title", default:"na"] as! String).contains("test")})
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        var tempIsFav = ""
        var tempPostId = ""
        if strDataType == "SearchData"
        {
            tempPostId = (((self.searchArray as NSArray).object(at: sender.tag) as AnyObject).value(forKey: "post_id") as? String)!
            
            if ((self.searchArray as NSArray).object(at: sender.tag) as AnyObject).value(forKey: "favorite_id") as? String == nil{
                tempIsFav = "add"
            }
            else{
                tempIsFav = "remove"
            }
        }
        else{
            
            tempPostId = (((self.dataArray as NSArray).object(at: sender.tag) as AnyObject).value(forKey: "post_id") as? String)!
            
            if ((self.dataArray as NSArray).object(at: sender.tag) as AnyObject).value(forKey: "favorite_id") as? String == nil{
                tempIsFav = "add"
            }
            else{
                tempIsFav = "remove"
            }
        }
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "post_id" : tempPostId,
                                       "action": tempIsFav]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(FavouritePost, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
//                        var tempdic = self.dataArray[sender.tag] as! Dictionary<String,Any>
//                        print("TempDic is:\(tempdic)")
//                        tempdic["favorite_id"] = "1"
                        
                      //  self.dataCollection.reloadData()
                        
                        let point : CGPoint = sender.convert(CGPoint.zero, to:self.dataCollection)
                        let indexPath = self.dataCollection!.indexPathForItem(at: point)
                        let cell = self.dataCollection!.cellForItem(at: indexPath!) as! postListCell
                        if tempIsFav == "add"{
                            cell.heartButton.setBackgroundImage(UIImage(named:"icon_heart_filled"), for: .normal)
                        }
                        else{
                            cell.heartButton.setBackgroundImage(UIImage(named:"icon_heart"), for: .normal)
                        }
                        self.getPostData()
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
    
    //MARK:- Location Manager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        udefault.setValue(locValue.latitude, forKey: MUserLatitude)
        udefault.setValue(locValue.longitude, forKey: MUserLongitude)
    }
    
//    // MARK: - Managing the Status Bar
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
      //  let image = imageHeight[indexPath.item] as NSString
        
     //   let random = randomNumber(MIN: 100, MAX: 200)
        
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
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        //  let textFont = UIFont(name: "Arial-ItalicMT", size: 11)!
        return 70.0
    }
}

