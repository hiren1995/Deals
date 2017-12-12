//
//  ReportUser.swift
//  Deals
//
//  Created by APPLE MAC MINI on 11/12/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit

var UserBlockReason:String? = nil

class ReportUser: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var Header: UIView!
    
    @IBOutlet weak var ReceiverImg: UIImageView!
    
    
    var reasons:[String]? = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblFullNAme: UILabel!
    
    //variables for chatting list which we need to inilialize before going back....
    
    var StrUserName = String()
    var StrProductImg = String()
    var StrPostId = String()
    var StrOtherUserId = String()
    var StrProductTitle = String()
    var StrChatRandomID = String()
    var StrIsBlock = String()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         HeaderViewModify()
        
        if isArabic{
            
            reasons = ["فقدوا اجتماعنا","ولم يردوا على الرسائل","باعوا لي شيئا مكسورا","وهي غير مناسبة","قد تكون مخادعة","قد تكون سرقت البنود الخاصة بهم","آخر"]
            
             tableView.contentInset = UIEdgeInsetsMake(0, 0 , 0, -7)
      
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: ReceiverImg.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            ReceiverImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
        }
        else
        {
            reasons = ["They missed our meeting","They did not respond to messages","They sold me something broken","They are inappropriate","They may be a scammer","Their items may be stolen","other"]
            
            tableView.contentInset = UIEdgeInsetsMake(0, -7, 0, 0)
            
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: ReceiverImg.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            ReceiverImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
        }
        
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        
        
        
        let placeholder = UIImage(named: "icon_profile_default")
        ReceiverImg.af_setImage(
            withURL: ProfileURLReport!,
            placeholderImage: placeholder
        )
        
        lblFullNAme.text = StrUserName
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if reportUserFlag
        {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func HeaderViewModify()
    {
        
        Header.layer.shadowColor = UIColor.darkGray.cgColor
        Header.layer.shadowOpacity = 0.5
        Header.layer.shadowOffset = CGSize(width: 1, height: 1)
        Header.layer.shadowRadius = 1
        //HeaderView.layer.shadowPath = UIBezierPath(rect: HeaderView.bounds).cgPath
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ReasonCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reasonCell")
        
        ReasonCell.textLabel?.text = reasons?[indexPath.row]
        
        return ReasonCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserBlockReason = reasons?[indexPath.row]
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let reportUserDescriptionItem = SBoard.instantiateViewController(withIdentifier: "reportUserDescription") as! ReportUserDescription
        reportUserDescriptionItem.StrUserName = StrUserName
        reportUserDescriptionItem.StrProductImg = StrProductImg
        reportUserDescriptionItem.StrPostId = StrPostId
        reportUserDescriptionItem.StrOtherUserId = StrOtherUserId
        reportUserDescriptionItem.StrProductTitle = StrProductTitle
        reportUserDescriptionItem.StrChatRandomID = StrChatRandomID
        reportUserDescriptionItem.StrIsBlock = StrIsBlock
        self.present(reportUserDescriptionItem, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.28
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        let chatScreen = SBoard.instantiateViewController(withIdentifier: "chatScreen") as! ChatingScreen
        
        chatScreen.strUserName = StrUserName
        chatScreen.strproductImg = StrProductImg
        chatScreen.strPostId = StrPostId
        chatScreen.strotherUserId = StrOtherUserId
        chatScreen.strProductTitle = StrProductTitle
        chatScreen.strChatRandomID = StrChatRandomID
        chatScreen.strIsBlock = StrIsBlock
        
        self.present(chatScreen, animated: true, completion: nil)
        
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
