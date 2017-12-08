//
//  SelectCountryCity.swift
//  Deals
//
//  Created by Mohit on 18/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit

class SelectCountryCity: UIViewController {

    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var textCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewCountry.setWhiteBorder()
        viewCity.setWhiteBorder()
        textCountry.setPlaceHolderColor()
        textCity.setPlaceHolderColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textCountry.text = udefault.object(forKey: MCountryName) as? String
        textCity.text = udefault.object(forKey: MCityName) as? String
    }
    
    // MARK :- IBAction Methods
    
    
    @IBAction func countryClicked(_ sender: Any) {
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
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
            cityList.strViewType = "FilterView"
            self.present(cityList, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToHome(_ sender: Any) {
        
        if textCountry.text == ""{
            self.showAlert("Please Select Country First")
        }
        else  if textCity.text == ""{
            self.showAlert("Please Select City First")
        }
        else{
        //Home screen
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        let initialView = SBoard.instantiateViewController(withIdentifier: "HomeView")
        let menuView = SBoard.instantiateViewController(withIdentifier: "MenuView")
        
        let MenuView : SWRevealViewController = SWRevealViewController(rearViewController: menuView, frontViewController: initialView)
        self.present(MenuView, animated: true, completion: nil)
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
