//
//  ChatingScreen.swift
//  Deals
//
//  Created by iosdeveloper on 02/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage
import JSQMessagesViewController

class ChatingScreen: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var messages = [JSQMessage]()
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    var dicMessage = NSDictionary()
    let SelProfileSegueName = "selProfileSegue"
    var msgText = String()
    
    var cusView = UIView()
    
    var dataArray = NSMutableArray()
    
    var strproductImg = String()
    var strfirstMSgId = String()
    var strlastMSgId = String()
    var strUserName = String()
    var strotherUserId = String()
    var selectedSlugName = String()
    var strPostId = String()
    var strProductTitle = String()
    var strChatRandomID = String()
    var strIsBlock = String()
    
    var isUpdate : Bool = false

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if isKeyPresentInUserDefaults(key: "roomids")
        {
            // now val is not nil and the Optional has been unwrapped, so use it
            let roomids : [Int]  = UserDefaults.standard.object(forKey: "roomids") as! [Int]
            
            let readRoomids = roomids.filter{$0 != Int(strChatRandomID)}
            
            
            UserDefaults.standard.set(readRoomids, forKey: "roomids")
            UserDefaults.standard.synchronize()
        }

        if isKeyPresentInUserDefaults(key: "roomids")
        {
//            strChatRandomID
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(messageReceived(notification:)), name: NSNotification.Name("MessageNotification"), object: nil)
        
        self.getAllMessages()
        
        // Add Background Image to view
      //  self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "Chat_Bg")!)
        let bgImage = UIImageView(frame: UIScreen.main.bounds)
        bgImage.image = UIImage(named: "Chat_Bg");
        bgImage.contentMode = .scaleToFill
        self.collectionView.backgroundView = bgImage
        self.navigationController?.isNavigationBarHidden = false
        
        //Adding Custom view for Header
        
        /*
        cusView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 60))
        cusView.backgroundColor = UIColor.white
        cusView.dropShadow(scale: true)
        self.view.addSubview(cusView)
        
        var imgView = UIImageView()
        imgView = UIImageView(frame: CGRect(x: 50, y: 18.0, width: 40, height: 40))
        
        let lblName = UILabel(frame: CGRect(x: 100.0, y: 18.0, width: self.view.frame.width, height: 20.0))
        lblName.text = strUserName
        lblName.textColor = UIColor.black
        
        let lblTitle = UILabel(frame: CGRect(x: 100.0, y: 38.0, width: self.view.frame.width, height: 20.0))
        lblTitle.font = lblTitle.font.withSize(12.0)
        lblTitle.text = strProductTitle
        lblTitle.textColor = UIColor.darkGray
        
        let btn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 60, height: 60))
        btn.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        
        let pointX = UIScreen.main.bounds.width - 30
        let btnBlock = UIButton(frame: CGRect(x: pointX, y: 30.0, width: 20, height: 20))
        btnBlock.setBackgroundImage(UIImage(named:"blockUser"), for: .normal)
        btnBlock.addTarget(self, action: #selector(self.blockUserClicked(_:)), for: UIControlEvents.touchUpInside)
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backGreen"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 8, y: 30, width: 20, height: 20)
        
         */
        
        var imgView = UIImageView()
        
        if isArabic{
            
            cusView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 60))
            cusView.backgroundColor = UIColor.white
            cusView.dropShadow(scale: true)
            self.view.addSubview(cusView)
            
            let pointY = UIScreen.main.bounds.width - 80
            
            imgView = UIImageView(frame: CGRect(x: pointY, y: 18.0, width: 40, height: 40))
            
            let lblName = UILabel(frame: CGRect(x: 40, y: 20, width: self.view.frame.width - 125, height: 20.0))
            lblName.text = strUserName
            lblName.textColor = UIColor.black
            //lblName.layer.backgroundColor = UIColor.gray.cgColor
            
            let lblTitle = UILabel(frame: CGRect(x: 40, y: 35, width: self.view.frame.width - 125, height: 20.0))
            lblTitle.font = lblTitle.font.withSize(12.0)
            lblTitle.text = strProductTitle
            lblTitle.textColor = UIColor.darkGray
            //lblTitle.layer.backgroundColor = UIColor.red.cgColor
           
            
            
            //let pointX = UIScreen.main.bounds.width - 30
            let btnBlock = UIButton(frame: CGRect(x: 10, y: 30.0, width: 20, height: 20))
            btnBlock.setBackgroundImage(UIImage(named:"report"), for: .normal)
            btnBlock.addTarget(self, action: #selector(self.blockUserClicked(_:)), for: UIControlEvents.touchUpInside)
            
            let pointX = UIScreen.main.bounds.width - 30
            let btnLeftMenu: UIButton = UIButton()
            btnLeftMenu.setImage(UIImage(named: "backArabic"), for: UIControlState())
            btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
            btnLeftMenu.frame = CGRect(x: pointX, y: 30, width: 20, height: 20)
            
            let btn = UIButton(frame: CGRect(x: pointX, y: 0.0, width: 60, height: 60))
            btn.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
            
            cusView.addSubview(lblName)
            cusView.addSubview(imgView)
            cusView.addSubview(btnLeftMenu)
            cusView.addSubview(btn)
            cusView.addSubview(lblTitle)
            cusView.addSubview(btnBlock)
        }
        else
        {
            cusView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 60))
            cusView.backgroundColor = UIColor.white
            cusView.dropShadow(scale: true)
            self.view.addSubview(cusView)
            
            
            imgView = UIImageView(frame: CGRect(x: 50, y: 18.0, width: 40, height: 40))
            
            let lblName = UILabel(frame: CGRect(x: 100.0, y: 18.0, width: self.view.frame.width, height: 20.0))
            lblName.text = strUserName
            lblName.textColor = UIColor.black
            
            let lblTitle = UILabel(frame: CGRect(x: 100.0, y: 38.0, width: self.view.frame.width, height: 20.0))
            lblTitle.font = lblTitle.font.withSize(12.0)
            lblTitle.text = strProductTitle
            lblTitle.textColor = UIColor.darkGray
            
            let btn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 60, height: 60))
            btn.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
            
            let pointX = UIScreen.main.bounds.width - 30
            let btnBlock = UIButton(frame: CGRect(x: pointX, y: 30.0, width: 20, height: 20))
            btnBlock.setBackgroundImage(UIImage(named:"report"), for: .normal)
            btnBlock.addTarget(self, action: #selector(self.blockUserClicked(_:)), for: UIControlEvents.touchUpInside)
            
            let btnLeftMenu: UIButton = UIButton()
            btnLeftMenu.setImage(UIImage(named: "backGreen"), for: UIControlState())
            btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControlEvents.touchUpInside)
            btnLeftMenu.frame = CGRect(x: 8, y: 30, width: 20, height: 20)
            
            cusView.addSubview(lblName)
            cusView.addSubview(imgView)
            cusView.addSubview(btnLeftMenu)
            cusView.addSubview(btn)
            cusView.addSubview(lblTitle)
            cusView.addSubview(btnBlock)
        }
        
        
        

//        let btnProfile = UIButton(frame: CGRect(x: 50.0, y: 10.0, width: self.view.frame.size.width - 50, height: 50))
//        btnProfile.addTarget(self, action: #selector(self.goToProfile(_:)), for: UIControlEvents.touchUpInside)
        
        /*
        
        cusView.addSubview(lblName)
        cusView.addSubview(imgView)
        cusView.addSubview(btnLeftMenu)
        cusView.addSubview(btn)
        cusView.addSubview(lblTitle)
        cusView.addSubview(btnBlock)
        //cusView.addSubview(btnProfile)
 
        */
        
 
        imgView.setRoundedWithBorder()
        
        let ProfileUrl = postImageURL + strproductImg
        
        let urlProfilePic = URL(string:ProfileUrl)
        let placeholderImage1 = UIImage(named: "icon_profile_default")!
        imgView.af_setImage(
            withURL: urlProfilePic!,
            placeholderImage: placeholderImage1
        )
        
        if strIsBlock == "1"{
            self.inputToolbar.contentView.isHidden = true
            let lblName = UILabel(frame: CGRect(x: 0.0, y: 15.0, width: UIScreen.main.bounds.width, height: 25.0))
            lblName.text = "You are no longer continue this conversation".localized
            lblName.textAlignment = .center
            lblName.textColor = UIColor.black
            self.inputToolbar.addSubview(lblName)
        }
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.senderId = udefault.value(forKey: MUserID) as! String
        self.senderDisplayName = "Mohit"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if reportUserFlag
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        let rect = cusView.frame
        collectionView.frame = CGRect(x: 0.0, y: rect.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - rect.size.height )
        
//        if (self.automaticallyScrollsToMostRecentMessage) {
//            self.scrollToBottom(animated: true)
//        }
        self.scrollToBottom(animated: true)
    }
    
    //Block User Methods
    
    @IBAction func blockUserClicked(_ sender: Any) {
        
        /*
        
        let alert = UIAlertController(title: "Deals", message: "Are you sure you wants to Block this User?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.blockThisUser()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
        */
        
        
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let reportUser = SBoard.instantiateViewController(withIdentifier: "reportUser") as! ReportUser
        
        reportUser.StrUserName = strUserName
        reportUser.StrProductImg = strproductImg
        reportUser.StrPostId = strPostId
        reportUser.StrOtherUserId = strotherUserId
        reportUser.StrProductTitle = strProductTitle
        reportUser.StrChatRandomID = strChatRandomID
        reportUser.StrIsBlock = strIsBlock
        
        
        self.present(reportUser, animated: true, completion: nil);
    }
    
    func blockThisUser(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
    
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "chat_random_id" : strChatRandomID]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        Alamofire.request(BlockUserAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    if (strStatus.isEqual(to: "success")){
                        self.goToHome()
                    }
                }
                break
                
            case .failure(_):
                print("Favourite Post error:\(response.result.error!)")
                break
            }
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
    
    func messageReceived (notification : NSNotification)
    {
        print(notification)
        print("Notification Received")
        
        let dataDic = notification.object as? NSDictionary
        let fromId = dataDic?["chat_random_id"] as? String
        print("Notification Chat Random id:\(fromId)")
        print("Chat Random Id is:\(strChatRandomID)")
        if fromId == strChatRandomID
        {
            getAllMessages()
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    //Date Format Convert Function
    func convertDateFormater(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateFormat = "MMM dd hh:mm"
        return  dateFormatter.string(from: date)
    }
    
    func displayDateFormatter(_ date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: date)
    }
    
    func convertDateToString(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateFormat = "MMM dd hh:mm"
        return dateFormatter.date(from: date)!
    }
    
    func changeDateFormater(_ date: Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let dt = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMM dd hh:mm"
        let tempDate = dateFormatter.string(from: date)
        return  dateFormatter.date(from: tempDate)!
    }
    
    func getAllMessages(){
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "to_user_id" : strotherUserId,
                                       "post_id" : strPostId,
                                       "last_id" : "-1"]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        print(parameters)
        
      //  MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getMsgsAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    self.dicMessage = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success")){
                        MBProgressHUD.hide(for: self.view, animated: true)
                        var dicList = self.dicMessage.object(forKey: "data") as! NSArray
                        self.messages.removeAll()
                        
                        //Reverse Array
                       // dicList = dicList.reversed() as NSArray
                        
                        if (dicList.count != 0){
                            for element in dicList{
                                let dic : NSDictionary = element as! NSDictionary
                                print("Dic is : \(dic)")
                                
                                let strIsText = dic.value(forKey:"is_image") as? String
                                let strId = dic.value(forKey: "from_user_id") as! String
                                let strname = dic.value(forKey: "to_user_id")
                                let strtxt = dic.value(forKey: "messsage") as! String
                                
                                let strTime = dic.value(forKey: "sent") as! String
                                let tempTime = Int(strTime)
                                let result = tempTime?.dateFromMilliseconds()
                                
                                let msgDate = self.convertDateFormater(result!)
                                print("Message Date:\(msgDate)")
                                let messageDate = self.convertDateToString(msgDate)
                                
                                let strMsg = strtxt.decodeString
                                if(strIsText == "0"){
                                    print("Text")
                                    self.addMessage(withId: strId , name: strname as! String, text: strMsg, time:  messageDate)
                                }
                                else{
                                    print("Image")
                                    let imgURL  = dic.value(forKey: "messsage") as! String!
                                    let chatImgURL = chatImageURL + imgURL!
                                    print("Chat Image URL:\(chatImgURL)")
                                    
                                    if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: strId == self.senderId)
                                    {
                                        self.addPhotoMessage(withId: strId, key: chatImgURL, mediaItem: mediaItem, time: messageDate)
                                        
                                        self.fetchImageDataAtURL(chatImgURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                                    }
                                }
                                self.collectionView.reloadData()
                                self.scrollToBottom(animated: true)
                            }}}}
                
                break
                
            case .failure(_):
                print("Category List error:\(response.result.error!)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
                break
                
            }
        }
    }
    
    func sendMessageToServer(_ strMsg : String){
        
        let currentTime = getCurrentMillis()
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "to_user_id" : strotherUserId,
                                       "post_id" : strPostId,
                                       "messsage" : strMsg.decodeString,
                                       "is_image" : "0",
                                       "sent" : currentTime]
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        Alamofire.request(sendMsgAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let tempDic = response.result.value as! NSDictionary
                    print("Message List Response is:\(tempDic)")
                }
                break
                
            case .failure(_):
                print("Category List error:\(response.result.error!)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
                break
            }}
    }
    
    func sendImageToServer(_img : UIImage){
        let currentTime = getCurrentMillis()
        let timeString = String(currentTime)
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        let parameters : Parameters = ["user_id" : tempUserid,
                                       "token" :tempToken,
                                       "to_user_id" : strotherUserId,
                                       "post_id" : strPostId,
                                       "is_image" : "1",
                                       "sent" : timeString]
    
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(_img, 0.5)!, withName: "messsage", fileName: "file.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:sendMsgAPI, method: .post, headers: ["Authorization": "auth_token"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    // print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    //                            print(response.request)  // original URL request
                    //                            print(response.response) // URL response
                    //                            print(response.data)     // server data
                    // print("Response Result is:\(response.result.value)")   // result of response serialization
                    
                    if let JSON : NSDictionary = response.result.value as! NSDictionary {
                        print("Image Send in Chat - JSON: \(JSON)")
                    }}
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func onClcikBack(){
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let chatList = SBoard.instantiateViewController(withIdentifier: "chatList") as! ChatList
        chatList.strIsUpdate = isUpdate
        self.present(chatList, animated: true, completion: nil)
    }
    
    //Select Image and send
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    //MARK:- ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let tempUserid = udefault.value(forKey: MUserID) as! String
            let date = NSDate()
            let msgDate = self.changeDateFormater(date as Date)
            print("Send Message date:\(msgDate)")
            
            let photoItem = JSQPhotoMediaItem(image: image)
            self.addPhotoMessage(withId: tempUserid, key: "", mediaItem: photoItem!, time: msgDate)
            self.sendImageToServer(_img: image)
            
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    // Send Message
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        [self.inputToolbar.contentView.textView.resignFirstResponder()]
        
        let tempUserid = udefault.value(forKey: MUserID)
        let strText = text
        
        msgText = (strText?.encodeString)!
        print(msgText)
        //itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
        
        let date = NSDate()
        print("Msg date:\(date)")
        let msgDate = self.changeDateFormater(date as Date)
        print("Msg date:\(msgDate)")
        
        addMessage(withId: tempUserid as! String, name: "Mohit", text: text, time: msgDate)
        self.collectionView.reloadData()
        self.sendMessageToServer(msgText)
    }
    
    //JSQ CollectionView Methods
    
    private func addMessage(withId id: String, name: String, text: String, time: Date)
    {
//        if let message = JSQMessage(senderId: id, displayName: name, text: text, Date: time) {
//            messages.append(message)
//        }
        //With Date
        if let msg = JSQMessage(senderId: id, senderDisplayName: name, date: time, text: text){
            messages.append(msg)
        }
        
        isUpdate = true
    }
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem, time: Date)
    {
//        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
//            messages.append(message)
//            
//            if (mediaItem.image == nil) {
//                photoMessageMap[key] = mediaItem
//            }
//            collectionView.reloadData()
//        }
        //With Date
        if let msg = JSQMessage(senderId: id, senderDisplayName: "", date: time, media: mediaItem){
            messages.append(msg)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            collectionView.reloadData()
        }
        isUpdate = true
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?)
    {
        let url = URL(string: photoURL)
        print("URL is:\(url)")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async
                {
                    mediaItem.image = UIImage(data: data!)
                    mediaItem.mediaView().contentMode = .scaleAspectFit
                    self.collectionView.reloadData()
            }
        }
        // self.photoMessageMap.removeValue(forKey: key!)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage
    {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor(red: 75.0/255.0, green: 175.0/255.0, blue: 77.0/255.0, alpha: 1.0))
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage
    {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
       
        let tempDate = self.displayDateFormatter(message.date)
        cell.cellBottomLabel.text = tempDate
        
        if isArabic{
            
            if message.senderId == senderId {
                
                cell.cellBottomLabel.textAlignment = NSTextAlignment.left
                
            } else {
                
                cell.cellBottomLabel.textAlignment = NSTextAlignment.right
            }
            
            
        }
        else
        {
            if message.senderId == senderId {
                
                cell.cellBottomLabel.textAlignment = NSTextAlignment.right
                
            } else {
                
                cell.cellBottomLabel.textAlignment = NSTextAlignment.left
            }
        }
        
        cell.cellBottomLabel.textColor = UIColor.black
        if message.senderId == senderId
        {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        self.view.endEditing(true)
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
