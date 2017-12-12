//
//  constant.swift

//
//  Created by EL-Consumer Sketch on 20/03/17.
//  Copyright © 2017 consumer-Sketch. All rights reserved.
//

import Foundation


var udefault = UserDefaults.standard

let sBoard = UIStoryboard(name: "Main", bundle: nil)
let arBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)

var isArabic : Bool = false

var reportFlag:Bool = false

var reportUserFlag:Bool = false

 //Api

var Baseurl = "http://deal4ya.com/api"
var categoryImageURL = "http://deal4ya.com/upload/category/"
var ProfileImageURL = "http://deal4ya.com/upload/user/"
var postImageURL = "http://deal4ya.com/upload/post/"
var chatImageURL = "http://deal4ya.com/upload/message/"

var SignUpAPI = "\(Baseurl)/register"
var LoginAPI = "\(Baseurl)/login"
var FBLoginAPI = "\(Baseurl)/fb-login"
var getCategory = "\(Baseurl)/category-list"
var getCountryList = "\(Baseurl)/get-county-detail"
var addPostAPI = "\(Baseurl)/add-post"
var getPost = "\(Baseurl)/search"
var updateProfileAPI = "\(Baseurl)/update-profile"
var getProfilePost = "\(Baseurl)/get-post"
var FavouritePost = "\(Baseurl)/favorite-action"
var getFavPost = "\(Baseurl)/favorite-post"
var getNotifications = "\(Baseurl)/get-notification"
var getMessageList = "\(Baseurl)/get-message-list"
var updatePost = "\(Baseurl)/update-post"
var deletePostAPI = "\(Baseurl)/delete-post"
var addRateAPI = "\(Baseurl)/add-rate"

var getMsgsAPI = "\(Baseurl)/get-message"
var sendMsgAPI = "\(Baseurl)/add-message"

var ReportPostAPI = "\(Baseurl)/report-item"
var BlockUserAPI = "\(Baseurl)/block-user"

var kOpenSansBold = "OpenSans-Bold"
var kOpenSans = "OpenSans"


//key for user default

var MLangugae = "Language"
var MDeiveToken = "Device-Token"

//Login Store Key for User Defaults
var MUserID = "User-Id"
var MUserToken = "User-Token"
var MUserEmail = "Email"
var MUserName = "FullName"

//Filter Data for UserDafaults
var MCountryName = "CountryName"
var MCountryID = "CountryID"
var MCityName = "CityName"
var MCityyID = "CityID"
var MCityyArray = "CityArray"
var MUserLatitude = "Latitude"
var MUserLongitude = "Longitude"
var MCategoryID = "CategoryId"

//SignUp
var SUserName = "full_name"
var SEmail = "email"
var SPassword = "password"
var SPhone = "phone"
var SLatitude = "latitude"
var SLongitude = "longitude"
var SToken = "device_token"
var SDeviceType = "device_type"





