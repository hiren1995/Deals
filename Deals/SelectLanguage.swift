//
//  SelectLanguage.swift
//  Deals
//
//  Created by Mohit on 20/09/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit

class SelectLanguage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnEnglish(_ sender: Any) {
        udefault.set("English", forKey: MLangugae)
        UserDefaults.standard.set(["en", "ar"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        udefault.set(false, forKey: "IsArabic")
        self.goToLoginView()
    }
    
    @IBAction func btnArabic(_ sender: Any) {
        udefault.set("Arabic", forKey: MLangugae)
        UserDefaults.standard.set(["ar", "en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        udefault.set(true, forKey: "IsArabic")
        self.goToLoginView()
    }
    
    func goToLoginView(){
        
        if isArabic{
            
            let SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            let loginView = SBoard.instantiateViewController(withIdentifier: "LoginView") as! Login
            self.present(loginView, animated: true, completion: nil)
        }
        else
        {
            let SBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = SBoard.instantiateViewController(withIdentifier: "LoginView") as! Login
            self.present(loginView, animated: true, completion: nil)
        }
        
        /*
        let SBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = SBoard.instantiateViewController(withIdentifier: "LoginView") as! Login
        self.present(loginView, animated: true, completion: nil)
        */
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
