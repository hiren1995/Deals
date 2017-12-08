//
//  Category.swift
//  Deals
//
//  Created by Mohit on 08/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage

class Category: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var menuView: UIView!
    
    var dataArray = NSArray()
    var openType = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.dropShadow(scale: true)
        // Do any additional setup after loading the view.
        
        self.getCategoryList()
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        if openType == "Menu"{
            self.goToHome()
        }
        else{
            self.dismiss(animated: true, completion: nil)
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
    
    func getCategoryList(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
    
        Alamofire.request(getCategory, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
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
                            self.collectionView.reloadData()
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
    
    //MARK: - Collection view delegate method
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.view.frame.size.width - 1) / 2  //some width
       // let height = width //ratio
        return CGSize(width: width, height: 120);
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as! categoryCell
        
        //profile pic
        let tempimgURL = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "category_image") as? String
        
        let ProfileUrl = categoryImageURL + tempimgURL!
        
        let urlProfilePic = URL(string:ProfileUrl)
        cell.imgView.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: nil
        )
        
        var tempTitle = ""
        
        if isArabic{
            let  temp = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "category_arabic") as? String)!
            tempTitle = temp.decodeString
        }
        else{
            tempTitle = (((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "category_name") as? String)!
        }
        
        cell.lblTitle.text = tempTitle
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if openType == "Menu"{
            let tempID = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "category_id") as? String
            udefault.setValue(tempID, forKey: MCategoryID)
            self.goToHome()
        }
        else{
//            var SBoard = UIStoryboard()
//            if isArabic{
//                SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
//            }
//            else{
//                SBoard = UIStoryboard(name: "Main", bundle: nil)
//            }
//            
//            let postView = SBoard.instantiateViewController(withIdentifier: "addPost") as! AddPost
            let tempTitle = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "category_name") as? String
            let tempID = ((self.dataArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "category_id") as? String
            udefault.set(tempTitle, forKey: "TempCategory")
            udefault.set(tempID, forKey: "TempCatID")
            self.dismiss(animated: true, completion: nil)
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
