//
//  ReportUserDescription.swift
//  Deals
//
//  Created by APPLE MAC MINI on 11/12/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

var Additional_reasonForUser:String? = nil

class ReportUserDescription: UIViewController,UITextViewDelegate {

    
    @IBOutlet weak var NoteText: UITextView!
    
    @IBOutlet weak var ReceiverImg: UIImageView!
    
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var btnBack1: UIButton!

    @IBOutlet weak var btnback2: UIButton!
    
    @IBOutlet weak var lblUserName: UILabel!
    
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

        
        if isArabic{
            
            NoteText.text = "يرجى كتابة ملاحظتك هنا ..."
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: ReceiverImg.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            ReceiverImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
            
        }
        else
        {
            NoteText.text = "Please write your note here.."
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: ReceiverImg.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            ReceiverImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
        }
        
        HeaderViewModify()
        
        //NoteText.text = "Please write your note here.."
        NoteText.textColor = UIColor.lightGray
        
        NoteText.layer.borderWidth = 1
        NoteText.layer.borderColor = UIColor.lightGray.cgColor
        NoteText.layer.cornerRadius = 10
        
        self.addDoneButtonOnKeyboard()
        
        
        btnBack1.addTarget(self, action: #selector(backFun), for: .touchUpInside)
        
        
        let placeholder = UIImage(named: "icon_profile_default")
        ReceiverImg.af_setImage(
            withURL: ProfileURLReport!,
            placeholderImage: placeholder
        )
        
        lblUserName.text = StrUserName
        
        // Do any additional setup after loading the view.
    }

    
    func HeaderViewModify()
    {
        HeaderView.layer.shadowColor = UIColor.darkGray.cgColor
        HeaderView.layer.shadowOpacity = 0.5
        HeaderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        HeaderView.layer.shadowRadius = 1
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if NoteText.textColor == UIColor.lightGray {
            NoteText.text = nil
            NoteText.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if NoteText.text.isEmpty
        {
            NoteText.text = "Please write your note here.."
            NoteText.textColor = UIColor.lightGray
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.NoteText.inputAccessoryView = doneToolbar
        
        
    }
    
    func doneButtonAction()
    {
        self.NoteText.resignFirstResponder()
        
    }
    
   
    func backFun()
    {
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let reportUser = SBoard.instantiateViewController(withIdentifier: "reportUser") as! ReportUser
        
        reportUser.StrUserName = StrUserName
        reportUser.StrProductImg = StrProductImg
        reportUser.StrPostId = StrPostId
        reportUser.StrOtherUserId = StrOtherUserId
        reportUser.StrProductTitle = StrProductTitle
        reportUser.StrChatRandomID = StrChatRandomID
        reportUser.StrIsBlock = StrIsBlock
        
        self.present(reportUser, animated: true, completion: nil);
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
        
        Additional_reasonForUser = NoteText.text
        
        NoteText.text = "Please write your note here.."
        NoteText.textColor = UIColor.lightGray
        
        reportThisPost()
    }
    func reportThisPost(){
        
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
       
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "chat_random_id" : StrChatRandomID,
                                       "reason": UserBlockReason! ,
                                       "additional_reason": Additional_reasonForUser!]
        
        print(parameters)
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        Alamofire.request(BlockUserAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
                        reportUserFlag = true
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                break
                
            case .failure(_):
                print("Report Post error:\(response.result.error!)")
                
                break
                
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
