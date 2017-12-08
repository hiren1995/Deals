//
//  WebViewScreen.swift
//  Deals
//
//  Created by iosdeveloper on 27/10/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit

class WebViewScreen: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var menuView: UIView!
    
    var strTitle = NSString()
    var strType = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuView.dropShadow(scale: true)
        lblTitle.text = strTitle as String
        
        if strType == "About"{
            webView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "About_English", ofType: "html")!)))
        }
        else{
            webView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Terms_English", ofType: "html")!)))
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
