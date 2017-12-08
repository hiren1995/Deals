//
//  ImageShow.swift
//  Deals
//
//  Created by Mohit on 06/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageShow: UIViewController {

    var scrlView = UIScrollView()
    var dataArray = NSDictionary()
    
    @IBOutlet weak var tempView: UIView!
    
    var SBoard = UIStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }

        // Do any additional setup after loading the view.
        self.setScrollView()
    }
    
    func setScrollView(){
        
        scrlView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: self.view.frame.size.height - 50))
        scrlView.isPagingEnabled = true
        scrlView.alwaysBounceVertical = false
        
        let tempimgURL = dataArray.object(forKey: "images") as? String
        let ImageArr = tempimgURL?.components(separatedBy: ",")
        
        if let arr = ImageArr{
            for i in 0..<arr.count{
                let xOrigin: CGFloat = CGFloat(i) * scrlView.frame.size.width
                let imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: scrlView.frame.size.width, height: scrlView.frame.size.height))
                
                let imgURL    = ImageArr?[i]
                
                let ProfileUrl = postImageURL + imgURL!
                print("Image URL:\(ProfileUrl)")
                let urlProfilePic = URL(string:ProfileUrl)
                let placeholder = UIImage(named: "icon_no_image")
                imageView.af_setImage(
                    withURL: urlProfilePic!,
                    placeholderImage: placeholder
                )
                
                imageView.contentMode = .scaleAspectFit
                scrlView.addSubview(imageView)
            }
            scrlView.contentSize = CGSize(width: scrlView.frame.size.width * CGFloat((ImageArr?.count)!), height: scrlView.frame.size.height)
        }
        self.tempView.addSubview(scrlView)
    }

    @IBAction func btnBack(_ sender: Any) {
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
