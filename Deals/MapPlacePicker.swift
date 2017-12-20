//
//  MapPlacePicker.swift
//  Deals
//
//  Created by APPLE MAC MINI on 14/12/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import AlamofireImage
import MBProgressHUD

var latitude_global:Double? = nil
var longitude_global:Double? = nil
var country_global:String? = nil
var city_global:String? = nil
var radius_global:Int = 1


extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/Double.pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * Double.pi/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }
}

class MapPlacePicker: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    var locationManager=CLLocationManager()
    
    @IBOutlet var Mapview: GMSMapView!
    
    var cirlce: GMSCircle!
    
    @IBOutlet var sliderView: UISlider!
    
    @IBOutlet var DistanceSelectorView: UIView!
    
    
    @IBOutlet var btnCancel: UIButton!
    
    
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet weak var btnGPSlocation: UIButton!
    
    //var mapView: GMSMapView!
    
   
    @IBOutlet var distancelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor(red: 73/255, green: 172/255, blue: 77/255, alpha: 1.0).cgColor

        btnCancel.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        btnGPSlocation.addTarget(self, action: #selector(curreentLocation), for: .touchUpInside)
        
        curreentLocation()
       
        //Mapview.camera = GMSCameraPosition.camera(withLatitude: -33.86,longitude: 151.20, zoom: 18)
        //Mapview.isMyLocationEnabled = true
        //Mapview.delegate = self
        
        //circleView(circleRadius: Double(sliderView.value))
        
        
        
        //cirlce = GMSCircle(position: Mapview.camera.target, radius: 100000)
        //cirlce.fillColor = UIColor.red.withAlphaComponent(0.5)
        //cirlce.map = Mapview
        
        /*
 
         //when we want whole view to be map view ...
         
         //let camera = GMSCameraPosition.camera(withLatitude: -33.86,longitude: 151.20, zoom: 6)
         
         //mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
         //mapView.isMyLocationEnabled = true
         //self.view = mapView
         
         //mapView.delegate = self
         
         //cirlce = GMSCircle(position: camera.target, radius: 100000)
         //cirlce.fillColor = UIColor.red.withAlphaComponent(0.5)
         //cirlce.map = mapView
         
         
         */
        
        /*
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        circleView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        view.addSubview(circleView)
        view.bringSubview(toFront: circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        view.updateConstraints()
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
            circleView.layer.cornerRadius = circleView.frame.width/2
            circleView.clipsToBounds = true
        })
 
        */
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //curreentLocation()
    }
    
    func curreentLocation()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        //locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let mylocation = locations.last
        
        Mapview.camera = GMSCameraPosition.camera(withLatitude: mylocation!.coordinate.latitude,longitude: mylocation!.coordinate.longitude, zoom: 18)
        Mapview.isMyLocationEnabled = true
        Mapview.delegate = self
        
        
        
        print(sliderView.value)
        
        circleView(circleRadius: Double(sliderView.value) * (1604))
        
        //circleView(circleRadius: Double(sliderView.value))
        
        locationManager.stopUpdatingLocation()
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //Mapview.clear()
        
        print("\(position.target.latitude) \(position.target.longitude)")
        
        getAreaDetails(lat: position.target.latitude,long: position.target.longitude)
        
        cirlce.position = position.target
       
        
    }

    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        Mapview.clear()
        
        var currentvalue = Int(sender.value)
        
        radius_global = currentvalue
        
        if isArabic
        {
            distancelabel.text =  "ميل\(currentvalue)"
        }
        else{
            distancelabel.text =  "\(currentvalue) miles"
        }
        
        
        circleView(circleRadius: Double(sliderView.value) * (1604))
        
        //circleView(circleRadius: Double(sliderView.value))
        
    }
    
    func circleView(circleRadius: Double)
    {
        
        
        //cirlce = GMSCircle(position: Mapview.camera.target, radius:0)
        
        cirlce = GMSCircle(position: Mapview.camera.target, radius: circleRadius)
        cirlce.fillColor = UIColor(red: 16/255, green: 129/255, blue: 224/255, alpha: 0.1)
        cirlce.map = Mapview
        
        let update = GMSCameraUpdate.fit(cirlce.bounds())
        Mapview.animate(with: update)
        
    }
    
    func goBack()
    {
        /*
 
        var SBoard = UIStoryboard()
        if isArabic{
            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
        }
        else{
            SBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        let SWRevealViewController = SBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealViewController, animated: true, completion: nil)
 
         */
 
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAreaDetails(lat: CLLocationDegrees,long:CLLocationDegrees)
    {
        
        var CLCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        CLCoordinate.latitude = lat
        CLCoordinate.longitude = long
        
        let ceo = GMSGeocoder()
        
        ceo.reverseGeocodeCoordinate(CLCoordinate) { (response, error) in
            
            //print(response?.results())
            
            print(response?.firstResult())
            
            if (error != nil)
            {
                print("reverse Geocode failed")
                
                return
            }
            else
            {
                
                
                latitude_global =  Double(lat)
                longitude_global = Double(long)
                
                country_global = response?.firstResult()?.country
                city_global = response?.firstResult()?.locality
                
                
                udefault.set(latitude_global, forKey: "latitude_global")
                udefault.set(longitude_global, forKey: "longitude_global")
                udefault.set(country_global, forKey: "country_global")
                udefault.set(city_global, forKey: "city_global")
                
                print(latitude_global)
                print(longitude_global)
            }
        }

        /*  //--------------- Apple Reverse Geo Coding...-------
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: lat, longitude: long)
        
       
        
        ceo.reverseGeocodeLocation(loc) { (placeMarks, error) in
            
            
            
            if (error != nil)
            {
                print("reverse Geocode failed")
                return
            }
            else
            {
                
                
                let tempplacemark = placeMarks
                
                let placemark = tempplacemark?.first
                
                print(placemark)
                
                latitude_global =  Double(lat)
                longitude_global = Double(long)
                
                country_global = placemark?.country
                city_global = placemark?.locality
                
                
                udefault.set(latitude_global, forKey: "latitude_global")
                udefault.set(longitude_global, forKey: "longitude_global")
                udefault.set(country_global, forKey: "country_global")
                udefault.set(city_global, forKey: "city_global")
                
                print(latitude_global)
                print(longitude_global)
                
                /*
                 
                 let pm = placeMarks! as [CLPlacemark]
                 
                 
                 
                 if(pm.count > 0)
                 {
                 
                    let temppm = pm[0]
                 
                    print(temppm.country)
                 
                    print(temppm.locality)
                 
                    //var placemark : CLPlacemark!
                 
                    //placemark = placeMarks?[0]
                    //print(placemark.addressDictionary!)
                 
                 
                    latitude_global =  Double(lat)
                    longitude_global = Double(long)
                 
                    country_global = temppm.country
                    city_global = temppm.locality
                 
                 
                    udefault.set(latitude_global, forKey: "latitude_global")
                    udefault.set(longitude_global, forKey: "longitude_global")
                    udefault.set(country_global, forKey: "country_global")
                    udefault.set(city_global, forKey: "city_global")
                 
                 }
                 */
                
            }
            
        }
        
        */
        
    }
   
    @IBAction func btnDone(_ sender: Any) {
        
        let tempUserid = udefault.value(forKey: MUserID) as! String
        
        let tempToken =  udefault.value(forKey: MUserToken) as! String
        
        var  tempCatId = String()
        
        if udefault.object(forKey: MCategoryID) != nil{
            tempCatId = udefault.object(forKey: MCategoryID) as! String
            
        }
        else{
            tempCatId = ""
        }
        
        let parameters:[String:Any] = ["user_id" : tempUserid,
                      "token" :tempToken,
                      "country_id" : "",
                      "city_id" : "",
                      "latitude" : latitude_global!,
                      "longitude" : longitude_global!,
                      "category_id" : tempCatId,
                      "radius": radius_global]
        print(parameters)
        
        let headers: HTTPHeaders = [ "Accept": "text/html", "Content-Type" : "application/x-www-form-urlencoded" ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(getPost, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.value)
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let tempDic = response.result.value as! NSDictionary
                    print("Response is:\(tempDic)")
                    let strStatus = NSString(string: tempDic["status"] as! String)
                    
                    if (strStatus.isEqual(to: "success"))
                    {
                        var SBoard = UIStoryboard()
                        if isArabic{
                            SBoard = UIStoryboard(name: "Main_Arabic", bundle: nil)
                        }
                        else{
                            SBoard = UIStoryboard(name: "Main", bundle: nil)
                        }
                        
                            let SWRevealViewController = SBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        
                            self.present(SWRevealViewController, animated: true, completion: nil)
                        
                    }
                }
                
                break
                
            case .failure(_):
                print("Category List error:\(response.result.error!)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
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
