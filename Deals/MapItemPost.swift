//
//  MapItemPost.swift
//  Deals
//
//  Created by APPLE MAC MINI on 20/12/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import AlamofireImage
import MBProgressHUD

class MapItemPost: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    var locationManager=CLLocationManager()
    
    
    @IBOutlet weak var Mapview: GMSMapView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnGPSlocation: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var lbAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor(red: 73/255, green: 172/255, blue: 77/255, alpha: 1.0).cgColor
        
        btnCancel.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        btnGPSlocation.addTarget(self, action: #selector(curreentLocation), for: .touchUpInside)
        
        curreentLocation()

        // Do any additional setup after loading the view.
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
        
        
        //circleView(circleRadius: Double(sliderView.value))
        
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        print("\(position.target.latitude) \(position.target.longitude)")
        getAreaDetails(lat: position.target.latitude ,long: position.target.longitude)
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
                
                
                self.lbAddress.text = nil
                
                return
            }
            else
            {
                let strrep = response?.firstResult()?.lines?.joined()
                self.lbAddress.text = strrep
                
                udefault.set(strrep, forKey: "address_post")
                udefault.set(response?.firstResult()?.locality, forKey: "city_post")
                udefault.set(response?.firstResult()?.country, forKey: "country_post")
                udefault.set(lat, forKey: "lat_post")
                udefault.set(long, forKey: "long_post")
            }
        }

        /*
         
         // Apple Reverse Geo Coding...
         
         //let ceo: CLGeocoder = CLGeocoder()
         //let loc: CLLocation = CLLocation(latitude: lat, longitude: long)
         
         
         
        ceo.reverseGeocodeLocation(loc) { (placeMarks, error) in
            
            
            
            if (error != nil)
            {
                print("reverse Geocode failed")
                
                self.lblCity.text = nil
                self.lblCountry.text = nil
                self.lbAddress.text = nil
                
                return
            }
            else
            {
                
                
                let tempplacemark = placeMarks
                
                let placemark = tempplacemark?.first
                
                print(placemark)
                
                print(placemark?.country)
                print(placemark?.locality)
                print(placemark?.subLocality)
                
                self.lblCity.text = placemark?.locality
                self.lblCountry.text = placemark?.country
                self.lbAddress.text = placemark?.subLocality
            }
            
        }
        */
    }
    
    
    func goBack()
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
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
