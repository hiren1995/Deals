//
//  AddPost.swift
//  Deals
//
//  Created by Mohit on 08/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD



class AddPost: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var viewImages: UIView!
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textDesciption: UITextField!
    @IBOutlet weak var textPrice: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textCategory: UITextField!
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewAddress: UIView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var imageDetailsView: UIView!
    @IBOutlet weak var tempView: UIView!
    
    var strCategoryName = NSString()
    var strCategoryID = NSString()
    var strCountryName = NSString()
    var strCityArray = NSArray()
    var strCityName = NSString()
    var imgArray = [UIImage]()
    
    var imagePicker = UIImagePickerController()
    var isImage : Bool = false
    var imgScrlView = UIScrollView()
    
    @IBOutlet weak var pageControl: UIPageControl!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuView.dropShadow(scale: true)
        
        self.scrlView.contentSize = CGSize(width: self.scrlView.contentSize.width, height: 500)
        
        viewCategory.setBorder()
        viewCountry.setBorder()
        viewCity.setBorder()
        viewAddress.setBorder()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        /*
        if(udefault.value(forKey: "address_post") != nil && udefault.value(forKey: "city_post") != nil && udefault.value(forKey: "country_post") != nil)
        {
            print(String(describing: udefault.value(forKey: "address_post")))
         
            textAddress.text = String(describing: udefault.value(forKey: "address_post")!)
            textCountry.text =  String(describing: udefault.value(forKey: "country_post")!)
            textCity.text = String(describing: udefault.value(forKey: "city_post")!)
        }
         */
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
     
        self.getTempData()
        
    }
    
    func setScrollView(){
        
        //Set Scrollview for Multiple images
        
        imgScrlView.removeFromSuperview()
        imgScrlView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: viewImages.frame.size.height))
        imgScrlView.isPagingEnabled = true
        imgScrlView.alwaysBounceVertical = false
        imgScrlView.showsHorizontalScrollIndicator = false
        imgScrlView.delegate = self
        
        for i in 0..<imgArray.count{
                let xOrigin: CGFloat = CGFloat(i) * imgScrlView.frame.size.width
                let imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: imgScrlView.frame.size.width, height: imgScrlView.frame.size.height))
            
                imageView.image = imgArray[i]
            
                imageView.contentMode = .scaleToFill
                imgScrlView.addSubview(imageView)
            }
            imgScrlView.contentSize = CGSize(width: imgScrlView.frame.size.width * CGFloat((imgArray.count)), height: imgScrlView.frame.size.height)
        pageControl.numberOfPages = imgArray.count
        pageControl.currentPageIndicatorTintColor = UIColor.green
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.tempView.addSubview(imgScrlView)
        self.tempView.bringSubview(toFront: pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        self.goToHome()
    }
    
    @IBAction func getImage(_ sender: Any) {
        /*
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        */
        
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cityClicked(_ sender: Any) {
        
       
        
        /*
        if textCountry.text == ""{
            self.showAlert("Please Select Country First")
        }
        else{
            self.saveTempData()
            var SBoard = UIStoryboard()
            if isArabic{
                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            }
            else{
                SBoard = UIStoryboard(name: "Main", bundle: nil)
            }
            let cityList = SBoard.instantiateViewController(withIdentifier: "countryCity") as! CountryCityList
            cityList.strType = "City"
            cityList.cityArray = udefault.object(forKey: "TempCityArray") as! NSArray
            self.present(cityList, animated: true, completion: nil)
        }
        */
    }
    
    @IBAction func categoryClicked(_ sender: Any) {
        self.saveTempData()
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let catList = SBoard.instantiateViewController(withIdentifier: "categoryList") as! Category
        self.present(catList, animated: true, completion: nil)
    }

    @IBAction func addressClicked(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let mapItemPost = SBoard.instantiateViewController(withIdentifier: "mapItemPost") as! MapItemPost
        
        self.present(mapItemPost, animated: true, completion: nil)
        
        
    }
    @IBAction func countryClicked(_ sender: Any) {
        
        /*
        
        self.saveTempData()
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let countryList = SBoard.instantiateViewController(withIdentifier: "countryCity") as! CountryCityList
        countryList.strType = "Country"
        self.present(countryList, animated: true, completion: nil)
 
        */
    }
    
    @IBAction func postData(_ sender: Any) {
        
        if textTitle.text == ""{
            self.showAlert("Please Enter Title")
        }
        else if textDesciption.text == ""{
            self.showAlert("Please Enter Desciption")
        }
        else if textPrice.text == ""{
            self.showAlert("Please Enter Price")
        }
        else if textAddress.text == ""{
            self.showAlert("Please Enter Address")
        }
        else if textCategory.text == ""{
            self.showAlert("Please Select Category")
        }
        else if textCountry.text == ""{
            self.showAlert("Please Select Country")
        }
        else if textCity.text == ""{
            self.showAlert("Please Select City")
        }
        else if !isImage{
            self.showAlert("Please Add Image")
        }
        else{
            if Reachability.isConnectedToNetwork() == true{
                
                let tempUserid = udefault.value(forKey: MUserID) as! String
                let tempToken =  udefault.value(forKey: MUserToken) as! String
                
                //let CountryID =  udefault.value(forKey: "TempCountryID") as! String
                //let CityID =  udefault.value(forKey: "TempCityID") as! String
                
                //let parameters : Parameters = ["user_id" : tempUserid,
                //                               "token" :tempToken,
                //                               "post_title" : textTitle.text!.encodeString,
                //                               "location" : textAddress.text!.encodeString,
                //                               "post_desc" : textDesciption.text!.encodeString,
                //                               "price" : textPrice.text!,
                //                              "category_id" : strCategoryID,
                //                               "country_id" : CountryID,
                //                               "city_id" : CityID,
                //                               "latitude" : "22.3072",
                //                               "longitude" : "73.1812"]
                
                let parameters : Parameters = ["user_id" : tempUserid,
                                               "token" :tempToken,
                                               "post_title" : textTitle.text!.encodeString,
                                               "location" : textAddress.text!.encodeString,
                                               "post_desc" : textDesciption.text!.encodeString,
                                               "price" : textPrice.text!,
                                               "category_id" : strCategoryID,
                                               "country" : udefault.value(forKey: "country_post")!,
                                               "city" : udefault.value(forKey: "city_post")!,
                                               "latitude" : String(describing: udefault.value(forKey: "lat_post")!),
                                               "longitude" : String(describing: udefault.value(forKey: "long_post")!)]
                
                print(parameters)
                
                let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    
                   for i in 0..<self.imgArray.count{
                    
                    let index : String = String(i)
                    let pName = "post_images" + "\(index)"
                    print(pName)
                    multipartFormData.append(UIImageJPEGRepresentation(self.imgArray[i], 0.5)!, withName: pName, fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
//                    multipartFormData.append(UIImageJPEGRepresentation(self.imgView.image!, 0.5)!, withName: "post_images", fileName: "file.jpeg", mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }, to:addPostAPI, method: .post, headers: ["Authorization": "auth_token"])
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
                                    self.goToHome()
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
    
    //MARK:- Save, Get & Delete Data from User Defaults
    
    func saveTempData(){
        udefault.set(textTitle.text, forKey: "TempTitle")
        udefault.set(textDesciption.text, forKey: "TempDesc")
        udefault.set(textPrice.text, forKey: "TempPrice")
        
        //udefault.set(textAddress.text, forKey: "TempAddress")
        
        //udefault.set(textCountry.text, forKey: "TempCountry")
        //udefault.set(textCity.text, forKey: "TempCity")
        
        udefault.set(String(describing: udefault.value(forKey: "address_post")!), forKey: "TempAddress")
        udefault.set(String(describing: udefault.value(forKey: "country_post")!), forKey: "TempCountry")
        udefault.set(String(describing: udefault.value(forKey: "city_post")!), forKey: "TempCountry")
        
        udefault.set(textCategory.text, forKey: "TempCategory")
        udefault.set(strCategoryID, forKey: "TempCatID")
    }
    
    func getTempData(){
        
        textTitle.text = udefault.object(forKey: "TempTitle") as? String
        textDesciption.text = udefault.object(forKey: "TempDesc") as? String
        textPrice.text = udefault.object(forKey: "TempPrice") as? String
        textCategory.text = udefault.object(forKey: "TempCategory") as? String
        //textAddress.text = udefault.object(forKey: "TempAddress") as? String
        //textCountry.text = udefault.object(forKey: "TempCountry") as? String
        //textCity.text = udefault.object(forKey: "TempCity") as? String
        
        textAddress.text = udefault.object(forKey: "address_post") as? String
        textCountry.text = udefault.object(forKey: "country_post") as? String
        textCity.text = udefault.object(forKey: "city_post") as? String
        
      
        if udefault.object(forKey: "TempCatID") != nil{
            strCategoryID = (udefault.object(forKey: "TempCatID") as? NSString)!
        } else {
            print("No value in Userdefault")

        }
    }
    
    func removeTempData(){
        
        udefault.removeObject(forKey: "TempTitle")
        udefault.removeObject(forKey: "TempDesc")
        udefault.removeObject(forKey: "TempPrice")
        udefault.removeObject(forKey: "TempAddress")
        udefault.removeObject(forKey: "TempCategory")
        udefault.removeObject(forKey: "TempCountry")
        udefault.removeObject(forKey: "TempCity")
        udefault.removeObject(forKey: "TempCatID")
        udefault.removeObject(forKey: "TempCountryID")
        udefault.removeObject(forKey: "TempCityID")
        udefault.removeObject(forKey: "ImageArray")
        
        udefault.removeObject(forKey: "address_post")
        udefault.removeObject(forKey: "country_post")
        udefault.removeObject(forKey: "city_post")
    }
    
    func goToHome(){
        
        self.removeTempData()
        
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
    
    //MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imgView.image = image
            imgView.isHidden = true
            imgArray.append(image)
            isImage = true
            self.setScrollView()
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    //MARK:- Keyboard Notifier Methods
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrlView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrlView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrlView.contentInset = contentInset
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
