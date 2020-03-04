//
//  DetailViewController.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/15/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    var incident: Incident?
    var coordinate: CLLocationCoordinate2D? = nil
    let distanceSpan: CLLocationDistance = 200
    @IBOutlet weak var crimeTypeLabel: UILabel!
    @IBOutlet weak var crimeDateLabel:UILabel!
    @IBOutlet weak var crimeDescriptionLabel: UILabel!
    @IBOutlet weak var crimeLocationLabel: UILabel!
    @IBOutlet weak var crimeBlockLabel:UILabel!
    @IBOutlet weak var crimeArrestLabel: UILabel!
    @IBOutlet weak var crimeDomesticLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Incident location or default location
        coordinate = CLLocationCoordinate2D(latitude: incident?.location?.latitude ?? 0, longitude: incident?.location?.longitude ?? 0)
        
        let converted = coordToLoc(coord: coordinate!)
        zoomLevel(location: converted)
        
        //Creates annonation from locations
        //var coord = converted.coordinate
        //var stringcoords = [["latitude": coord.latitude, "longitude": coord.longitude]]
        //createAnnotations(theLocations: stringcoords)
        
        //Creates annonation from incident coordinate
        createAnnotations(Incident: incident!)
        
        //Sets text in detail view
        crimeTypeLabel.text = incident?.description.type
        crimeBlockLabel.text = incident?.address
        crimeDescriptionLabel.text = incident?.description.text
        crimeLocationLabel.text = incident?.description.location
        crimeDateLabel.text = incident?.dateToString()
        
        crimeArrestLabel.text = (incident?.description.arrestMade!)! ? "TRUE" : "FALSE"
        crimeDomesticLabel.text = (incident?.description.isDomestic!)! ? "TRUE" : "FALSE"
        
    }
    
    
    //Changes coordinate object to location object
    func coordToLoc(coord: CLLocationCoordinate2D) -> CLLocation{
        let getLat: CLLocationDegrees = coord.latitude
        let getLon: CLLocationDegrees = coord.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
    //Sets zoom level
    func zoomLevel(location: CLLocation){
        //creating a zoom level
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    
    func createAnnotations(theLocations: [[String: Any]]){
        for location in theLocations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            annotation.title = "Searched Location"
            //To get image use the incident.description type with the method from incident photo
            let pinImage = IncidentPhoto.getCrimeImage(CrimeType: (incident?.description.type)!)
            mapView.addAnnotation(annotation)
        }
    }
    
    func createAnnotations(Incident incident: Incident){
            let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: incident.location?.latitude as! CLLocationDegrees, longitude: incident.location?.longitude as! CLLocationDegrees)
            annotation.title = incident.description.type
            mapView.addAnnotation(annotation)
    }
    
    @IBAction func myUnwindAction(unwindSegue:UIStoryboardSegue){
        
    }

}
