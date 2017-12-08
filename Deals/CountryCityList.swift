//
//  CountryCityList.swift
//  Deals
//
//  Created by Mohit on 12/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class CountryCityList: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var menuView: UIView!
    
    var strType = NSString()
    var strViewType = NSString()
    var countryArray = NSArray()
    var cityArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        menuView.dropShadow(scale: true)
        dataTable.tableFooterView = UIView(frame: CGRect.zero)
        dataTable.separatorInset = UIEdgeInsets.zero
    
        if strType == "Country"{
            lblType.text = "Country".localized
            self.getdata()
            dataTable.isHidden = true
        }
        else{
            lblType.text = "City".localized
            dataTable.isHidden = false
            dataTable.reloadData()
        }
        
    }
    
    func getdata(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken]
      //  print("Parameters are :\(parameters)")
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getCountryList, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Full Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
                        let dataDic = tempDic.object(forKey: "data") as! NSDictionary
                        
                        self.countryArray = dataDic.object(forKey: "country") as! NSArray
                        print("Country Array is:\(self.countryArray)")
                        
                        if self.countryArray.count > 0{
                            self.dataTable.reloadData()
                            self.dataTable.isHidden = false
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
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if strType == "Country"{
            return countryArray.count
        }
        else{
            return cityArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.dataTable.dequeueReusableCell(withIdentifier: "listCell") as UITableViewCell!
        
        if strType == "Country"{
            
            var tempCountry = ""
            if isArabic{
                let temp = (((self.countryArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "name_arabic") as? String)!
                tempCountry = temp.decodeString
            }
            else{
                tempCountry = (((self.countryArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "name_english") as? String)!
            }
            cell.textLabel?.text = tempCountry
        }
        else{
            var tempCity = ""
            if isArabic{
                let temp = (((self.cityArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "city_arabic") as? String)!
                tempCity = temp.decodeString
            }
            else{
                tempCity = (((self.cityArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "city_english") as? String)!
            }
            
            cell.textLabel?.text = tempCity
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let postView = SBoard.instantiateViewController(withIdentifier: "addPost") as! AddPost
        
        if strType == "Country"
        {
            let tempArray : NSArray = (((self.countryArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "city") as? NSArray)!
            udefault.set(tempArray, forKey: "TempCityArray")
            var tempCountry = ""
            if isArabic{
                let temp = (((self.countryArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "name_arabic") as? String)!
                tempCountry = temp.decodeString
            }
            else{
                tempCountry = (((self.countryArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "name_english") as? String)!
            }
    
            let tempID = ((self.countryArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "id") as? String
            //Save UserDefaults for Filterview
            if strViewType == "FilterView"{
                udefault.setValue(tempCountry, forKey: MCountryName)
                udefault.setValue(tempID, forKey: MCountryID)
                udefault.setValue(tempArray, forKey: MCityyArray)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                udefault.setValue(tempCountry, forKey: "TempCountry")
                udefault.setValue(tempID, forKey: "TempCountryID")
                self.dismiss(animated: true, completion: nil)
            }
        }
        else
        {
            var tempCity = ""
            if isArabic{
                let temp = (((self.cityArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "city_arabic") as? String)!
                tempCity = temp.decodeString
            }
            else{
                tempCity = (((self.cityArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "city_english") as? String)!
            }
            let tempID = ((self.cityArray as NSArray).object(at: indexPath.row) as AnyObject).value(forKey: "id") as? String
            //Save UserDefaults for Filterview
            if strViewType == "FilterView"{
                udefault.setValue(tempCity, forKey: MCityName)
                udefault.setValue(tempID, forKey: MCityyID)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                udefault.setValue(tempCity, forKey: "TempCity")
                udefault.setValue(tempID, forKey: "TempCityID")
                self.dismiss(animated: true, completion: nil)
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
