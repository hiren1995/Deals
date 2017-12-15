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
    
    //var mapView: GMSMapView!
   
    @IBOutlet var distancelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.stopUpdatingLocation()
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let mylocation = locations.last
        
        Mapview.camera = GMSCameraPosition.camera(withLatitude: mylocation!.coordinate.latitude,longitude: mylocation!.coordinate.longitude, zoom: 18)
        Mapview.isMyLocationEnabled = true
        Mapview.delegate = self
        
        print(sliderView.value)
        
        circleView(circleRadius: Double(sliderView.value) * (22.63))
        
        //circleView(circleRadius: Double(sliderView.value))
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //Mapview.clear()
        
        print("\(position.target.latitude) \(position.target.longitude)")
        
        cirlce.position = position.target
       
        //let marker = GMSMarker()
        //marker.position = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
        //marker.map = Mapview
    }

    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        Mapview.clear()
        
        var currentvalue = Int(sender.value)
        
        distancelabel.text =  "\(currentvalue) miles"
        
        circleView(circleRadius: Double(sliderView.value) * (22.63))
        
        //circleView(circleRadius: Double(sliderView.value))
        
    }
    
    func circleView(circleRadius: Double)
    {
        
        
        //cirlce = GMSCircle(position: Mapview.camera.target, radius:0)
        
        cirlce = GMSCircle(position: Mapview.camera.target, radius: circleRadius)
        cirlce.fillColor = UIColor.blue.withAlphaComponent(0.2)
        cirlce.map = Mapview
        
        let update = GMSCameraUpdate.fit(cirlce.bounds())
        Mapview.animate(with: update)
        
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
