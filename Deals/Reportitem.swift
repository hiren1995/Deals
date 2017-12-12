//
//  Reportitem.swift
//  Deals
//
//  Created by APPLE MAC MINI on 08/12/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit

var Reason:String? = nil


class Reportitem: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var itemUrl:String? = nil
    
    var dataArray = NSDictionary()
  
    @IBOutlet weak var itemImg: UIImageView!
    
    @IBOutlet weak var lblItem: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var HeaderView: UIView!
    
    
    var reasons:[String]? = nil
    
    //let reasons=["It's prohibited on Deals","It's offensive to me","It's not Real Post","It's a duplicate post","It's in wrong Category","It may be a scam","It may be a stolen","other"]
 
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if isArabic{
            
            reasons = ["يحظر على العروض","انها مسيئة بالنسبة لي","انها ليست وظيفة حقيقية","إنها مشاركة مكررة","هو في فئة خاطئة","قد يكون عملية احتيال","قد تكون مسروقة","آخر"]
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: itemImg.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            itemImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
        }
        else
        {
            reasons = ["It's prohibited on Deals","It's offensive to me","It's not Real Post","It's a duplicate post","It's in wrong Category","It may be a scam","It may be a stolen","other"]
            
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: itemImg.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            itemImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
        }
        
        
        
        HeaderViewModify()
        
        //tableView.layer.borderColor = UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 89/255).cgColor
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        tableView.contentInset = UIEdgeInsetsMake(0, -7, 0, 0)
        
       
        
        let tempimgURL =  itemUrl
        let ImageArr = tempimgURL?.components(separatedBy: ",")
        let imgURL    = ImageArr?[0]
        let ProfileUrl = postImageURL + imgURL!
        
        
        print("Image URL:\(ProfileUrl)")
        
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholder = UIImage(named: "icon_profile_default")
        itemImg.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholder
        )
        
        let tempTitle = dataArray.object(forKey: "post_title") as? String
        lblItem.text = tempTitle?.decodeString
        
        lblName.text = dataArray.object(forKey: "full_name") as? String
        
        // Do any additional setup after loading the view.
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func HeaderViewModify()
    {
        
        HeaderView.layer.shadowColor = UIColor.darkGray.cgColor
        HeaderView.layer.shadowOpacity = 0.5
        HeaderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        HeaderView.layer.shadowRadius = 1
        //HeaderView.layer.shadowPath = UIBezierPath(rect: HeaderView.bounds).cgPath
        
        
    }
    
    @IBAction func btnbackToPost(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let postDetails = SBoard.instantiateViewController(withIdentifier: "postDetails") as! PostDetails
        postDetails.dataArray = dataArray
        //postDetails.strType = "Server"
        
        
        
        self.present(postDetails, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reasons!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //reasonCell
        let ReasonCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reasonCell")
        
      
        
        ReasonCell.textLabel?.text = reasons?[indexPath.row]
        
        
        
        return ReasonCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Reason = reasons?[indexPath.row]
        
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let reportitemDescriptionItem = SBoard.instantiateViewController(withIdentifier: "reportitemDescription") as! ReportitemDescription
        reportitemDescriptionItem.dataArray = dataArray
        reportitemDescriptionItem.itemUrl = itemUrl
        self.present(reportitemDescriptionItem, animated: true, completion: nil);
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 52.75
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
