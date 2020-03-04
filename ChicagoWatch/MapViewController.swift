//
//  MapViewController.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/15/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//


// Luna -
// Once I get the location data of the crimes
// I'll be able to update this section
import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var currCoordinate: CLLocationCoordinate2D?
    var incidents:[Incident] = [Incident]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding annotations by calling function
        createAnnotations(theLocations: locations)
        
        //Sets the location to the current location or the default if currCoordinate is nil
        locationLtdLng = CLLocation(latitude: currCoordinate?.latitude ?? 39.818249, longitude: currCoordinate?.longitude ?? -86.1529958 )
        
        //Setting the zoom level
        zoomLevel(location: locationLtdLng)
        
        // Addes annonation from incident objects
        createAnnotations(incidents: incidents)
        
    }
    
    
    
    
    var locationLtdLng = CLLocation(latitude: 39.818249, longitude: -86.152995)
    let distanceSpan: CLLocationDistance = 200
    //The locations of the annotations stored in an array of dictionaries
    let locations = [["title": "practice1", "latitude": 40.003252,"longitude": -86.0655897]]
    
    
    
    
    func zoomLevel(location: CLLocation){
        //creating a zoom level
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    
    
    
    
    
    func createAnnotations(theLocations:[[String : Any]]){
        for location in theLocations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
           
            mapView.addAnnotation(annotation)
        }
    }
    
    //Adds annonation from incidents
    func createAnnotations(incidents:[Incident]){
        for incident in incidents {
            if(incident.location != nil){
                let annotation = MKPointAnnotation()
                annotation.title = incident.description.type
                
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: incident.location?.latitude as! CLLocationDegrees, longitude: incident.location?.longitude as! CLLocationDegrees)
                mapView.addAnnotation(annotation)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //erase if doesnt work
    
}

