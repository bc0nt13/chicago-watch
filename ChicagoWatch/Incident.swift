//
//  Incident.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/11/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//

import Foundation
import MapKit

class Incident{
    
    init(Location location:Location?, Description description:IncidentDescription, Date date:Date?, Address address: String) {
        self.location = location
        self.description = description
        self.date = date
        self.address = address
    }
    let location:Location?
    let description:IncidentDescription
    let date:Date?
    let address: String
    
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let dateString = self.date != nil ? dateFormatter.string(from: self.date!) : ""
        return dateString
    }
    
    func distanceStringFrom(currCoordinate: CLLocationCoordinate2D) -> String{
        var distanceFromUser: String?;
        
        if( location != nil){
            let currCoordinate = CLLocation(latitude: currCoordinate.latitude, longitude: currCoordinate.longitude)
            let incidentCoordinate = CLLocation(latitude: self.location!.latitude, longitude: self.location!.longitude)

            distanceFromUser = "\(String(format: "%.2f",currCoordinate.distance(from: incidentCoordinate) * 0.000621371)) mi"
            return distanceFromUser!
        }
        return "N/A"
    }
    
    
    
}

struct Location{
    
    let latitude:Double
    let longitude:Double
    
    init(Latitude latitude: Double, Longitude longitude: Double){
        self.latitude=latitude
        self.longitude=longitude
    }
}


struct IncidentDescription{
    
    let type:String
    let text:String
    let location:String
    let arrestMade:Bool?
    let isDomestic:Bool?
    
    init(Type type: String, Description text: String, LocationDescription location: String, ArrestMade arrestMade: Bool?, IsDomestic isDomestic: Bool?) {
        self.type = type
        self.text = text
        self.location = location
        self.arrestMade = arrestMade
        self.isDomestic = isDomestic
    }
    
}

