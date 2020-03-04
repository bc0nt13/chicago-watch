//
//  ViewController.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/11/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Amount of incidents loaded per request
    let pageSize:Int = 50
    //Current page of incidents
    var page:Int = 0;
    //Is there any more incidents able to be loaded
    var canUpdate = false;
    //This represent the current incident selected from the tableView
    var detailIncident:Incident?
    //Default radius for the incidents loaded
    var radius:Int = 150

    //When ever the incidents list is updated the table is reloaded
    var incidents = [Incident]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //When ever the coordinates are set the incidents are updated with the current page and pageSize
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D( latitude: 41.8781, longitude: 87.6298) {
        didSet {
            DispatchQueue.main.async {
                let incidentRequest = IncidentRequest(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude, radius: self.radius, pageSize: self.pageSize, page: 0)
                incidentRequest.getIncidents { [weak self] result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let incidents):
                        if( incidents.count == self?.pageSize){self?.canUpdate = true}
                        self?.page = 0;
                        self?.incidents = incidents
                    }
                    
                }
            }
        }
    }
    
    //Function that runs view is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adds a swipe listener that calls handeSwipe()
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    //Function that handles swipe input from user
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            //If the swipe is from the right a segue is performed to the showMap
            if sender.direction == .right {
                self.performSegue(withIdentifier: "showMap", sender: self)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidents.count
    }
    
    //Sets the text in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let incident = incidents[indexPath.row]
        //TODO handle null
        let type = incident.description.type
        cell.crimeTypeLabel.text = type
        
        cell.crimeDate.text = incident.dateToString()
        
            
        cell.crimeDistance.text = incident.distanceStringFrom(currCoordinate: coordinate)
    
        cell.crimeImage.image = IncidentPhoto.getCrimeImage(CrimeType: incident.description.type)
        return cell
    }
    
    //Allows the cells to automatically resize
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    //Updates with incidents when bottom of page is reached
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && canUpdate {
            canUpdate = false
            DispatchQueue.main.async {
                
                let incidentRequest = IncidentRequest(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude, radius: self.radius, pageSize: self.pageSize, page: self.page+1)
                incidentRequest.getIncidents { [weak self] result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let incidents):
                        
                        if(incidents.count > 0){
                            self?.canUpdate = true
                            self?.page+=1
                            self?.incidents.append(contentsOf: incidents)
                        }
                    }
                    
                }
            }
        }
    }
    
    ///Fills the Address Bar with a address found from the Map SDK
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let address = searchBar.text ?? ""
        if( address == ""){
            incidents.removeAll();
        } else {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    self.incidents.removeAll();
                    return
                }
                let placemark = placemarks.first
                //Handle Null values TODO
                self.searchBar.text = "\(placemark!.subThoroughfare!) \(placemark!.thoroughfare!) \(placemark!.locality!), \(placemark!.postalCode!)"
                self.coordinate = location.coordinate
                
            }
        }
    }
    
    //If the table is selected a segue is performed into the detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          detailIncident = incidents[indexPath.row]
          self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
    //This function prepares the variables for the transistion between view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //This sends the current incident clicked on the TableView
        if segue.identifier == "showDetail" {
            let sg = segue.destination as! DetailViewController
            sg.incident = detailIncident
        }
        //This sends the incidents loaded as well as the current coordinate
        else if segue.identifier == "showMap" {
            let sg = segue.destination as! MapViewController
            
            /*
                let group = DispatchGroup()
                group.enter()
                //Loads the rest of the coordinates
                    print("hello")
                    while(self.canUpdate){
                        let incidentRequest = IncidentRequest(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude, radius: self.radius, pageSize: self.pageSize, page: self.page+1)
                        incidentRequest.getIncidents { [weak self] result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let incidents):
                                
                                if(incidents.count > 0){
                                    self?.canUpdate = true
                                    self?.page+=1
                                    self?.incidents.append(contentsOf: incidents)
                                } else {
                                    self?.canUpdate = false
                                }
                                
                            }
                            
                        }
                }
                group.wait()*/
                sg.incidents = incidents
                sg.currCoordinate = coordinate
        }
    }
    

}

