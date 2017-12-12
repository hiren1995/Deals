//
//  ReportitemDescription.swift
//  Deals
//
//  Created by APPLE MAC MINI on 08/12/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

var Additional_reason:String? = nil



class ReportitemDescription: UIViewController,UITextViewDelegate {

    
    var itemUrl:String? = nil
    
    var dataArray = NSDictionary()
    
    @IBOutlet weak var NoteText: UITextView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    
    @IBOutlet weak var itemImg: UIImageView!
    
    
    @IBOutlet weak var lblItem: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isArabic{
            
            NoteText.text = "يرجى كتابة ملاحظتك هنا ..."
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: itemImg.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            itemImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
            
        }
        else
        {
            NoteText.text = "Please write your note here.."
            
            //---------------- code  for making only top left and bottom left corners round
            
            let bezierpath = UIBezierPath(roundedRect: itemImg.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierpath.cgPath
            itemImg.layer.mask = maskLayer
            //------------------------------------------------------------------------------
        }
        
        HeaderViewModify()

        //NoteText.text = "Please write your note here.."
        NoteText.textColor = UIColor.lightGray
        
        NoteText.layer.borderWidth = 1
        NoteText.layer.borderColor = UIColor.lightGray.cgColor
        NoteText.layer.cornerRadius = 10
        
        self.addDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
        
        
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
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func HeaderViewModify()
    {
        HeaderView.layer.shadowColor = UIColor.darkGray.cgColor
        HeaderView.layer.shadowOpacity = 0.5
        HeaderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        HeaderView.layer.shadowRadius = 1
        
        
    }
    
    @IBAction func btnBackReport(_ sender: Any) {
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let reportItem = SBoard.instantiateViewController(withIdentifier: "reportitem") as! Reportitem
        reportItem.dataArray = dataArray
        reportItem.itemUrl = itemUrl
      
        self.present(reportItem, animated: true, completion: nil);
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
    
        Additional_reason = NoteText.text
        
        NoteText.text = "Please write your note here.."
        NoteText.textColor = UIColor.lightGray
        
        reportThisPost()
        
    }
    
    func reportThisPost(){
        
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        let tempPostId = dataArray.object(forKey: "post_id") as? String
        
        print(tempPostId)
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "post_id" : tempPostId!,
                                       "reason": Reason! ,
                                       "additional_reason": Additional_reason!]
        
        print(parameters)
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        Alamofire.request(ReportPostAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        
                        //reportFlag = true
                        
                        //self.dismiss(animated: true, completion: nil)
                        
                        var SBoard = UIStoryboard()
                        if isArabic{
                            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
                        }
                        else{
                            SBoard = UIStoryboard(name: "Main", bundle: nil)
                        }
                        let SWRevealViewController = SBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                       
                        self.present(SWRevealViewController, animated: true, completion: nil);
                    }
                }
                
                break
                
            case .failure(_):
                print("Report Post error:\(response.result.error!)")
                
                break
                
            }
        }
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
