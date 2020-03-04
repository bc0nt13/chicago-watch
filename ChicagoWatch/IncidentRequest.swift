//
//  IncidentRequest.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/11/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//

import Foundation

enum IncidentError:Error {
    case noDataAvailable
    case canNotProcessData
}


struct IncidentRequest{
    let resourceURL:URL
    let API_KEY = "J6kkuuqCBVhYGuo7WJpY57IKK"
    
    init(){
        
        let resourceString = "https://data.cityofchicago.org/resource/ijzp-q8t2.json?$$app_token=\(API_KEY)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    init(latitude:Double, longitude:Double, radius:Int, pageSize:Int, page:Int){
    
        let resourceString = "https://data.cityofchicago.org/resource/ijzp-q8t2.json?$limit=\(pageSize)&$offset=\(page)&$where=within_circle(location,\(latitude),\(longitude),\(radius))&$$app_token=\(API_KEY)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    init(startDate: Date, endDate: Date){
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS"
        let startDateString = df.string(from:startDate)
        let endDateString = df.string(from:endDate)
        
        
        let dateString = "date between '\(startDateString)' and '\(endDateString)'"
        let resourceString = "https://data.cityofchicago.org/resource/ijzp-q8t2.json?$$app_token=\(API_KEY)&$where=\(dateString)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    init(startDate: Date, endDate: Date, latitude:Double, longitude:Double, radius:Int){
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS"
        let startDateString = df.string(from:startDate)
        let endDateString = df.string(from:endDate)
        
        
        let dateString = "date between '\(startDateString)' and '\(endDateString)'"
        let resourceString = "https://data.cityofchicago.org/resource/ijzp-q8t2.json?$$app_token=\(API_KEY)&$where=within_circle(location,\(latitude),\(longitude),\(radius)AND\(dateString)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func getIncidents( completion: @escaping(Result<[Incident],IncidentError>) -> Void ){
        var incidents : [Incident] = []
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                /*
                let decoder = JSONDecoder();
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let incidentsResponse = try decoder.decode([Incident].self, from: jsonData)
                let incidents = incidentsResponse
                completion(.success(incidents))
                */
                
                
                if let jsonData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String:Any]]{
                    for jsonObject in jsonData {

                        
                        let latitudeRequest = jsonObject["latitude"] as! String
                        let longitudeRequest = jsonObject["longitude"] as! String
                        let latitude = Double(latitudeRequest)
                        let longitude = Double(longitudeRequest)
                        
                        let incidentLocation = (latitude != nil && longitude != nil) ? Location(Latitude: Double(latitude!), Longitude: Double(longitude!)) : nil
                        
                        let type = jsonObject["primary_type"] as? String ?? "N/A"
                        let description = jsonObject["description"] as? String ?? "N/A"
                        let locationDescripton = jsonObject["location_description"] as? String ?? "N/A"
                        let arrestMade = jsonObject["arrest"] as? Bool ?? false
                        let isDomestic = jsonObject["domestic"] as? Bool ?? false
                        
                        let incidentDescription = IncidentDescription(Type: type, Description: description, LocationDescription: locationDescripton, ArrestMade: arrestMade, IsDomestic: isDomestic)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                        
                        let dateResponse = jsonObject["date"] as? String
                        let date:Date? = dateResponse != nil ? dateFormatter.date(from: dateResponse!) : nil
                        
                        let address = jsonObject["block"] as? String ?? "N/A"
                        
                        let incident = Incident(Location: incidentLocation, Description: incidentDescription, Date: date, Address: address)
                         
                        incidents.append(incident)
                    }
                }
                completion(.success(incidents))
            } catch {
                completion(.success(incidents))
            }
        }
        dataTask.resume()
    }

}
