//
//  ViewController.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    var marker = GMSMarker()
    var viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isMyLocationEnabled = false
        LocationService.shared.delegate = self
        LocationService.shared.start()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        let historyViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryTableViewController") as? HistoryTableViewController
        historyViewController?.delegate = self
        navigationController?.pushViewController(historyViewController!, animated: true)
    }
}

extension MapViewController: LocationServiceDelegate {
    
    func trackingLocation(coordinate: CLLocationCoordinate2D, shouldSave: Bool) {
        let camera = GMSCameraPosition(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude,
                                       zoom: 10)
        self.mapView.animate(to: camera)
        reverseGeoCode(position: coordinate, shouldSave: shouldSave)
    }
    
    private func configureMarker(_ coordinate: CLLocationCoordinate2D) {
        viewModel.configureMarker(coordinate).map = mapView
    }
    
    private func reverseGeoCode(position: CLLocationCoordinate2D, shouldSave: Bool) {
        GoogleMapService.getAddressFromLatLong(position: position, handler: { (response) in
            self.configureMarker(position)
            self.handleDataBase(response, shouldSave: shouldSave)
        })
    }
    
    private func handleDataBase(_ response: GMSAddress, shouldSave: Bool) {
        guard let locality = response.locality, shouldSave else { return }
        viewModel.insertPlace(response, locality: locality)
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        trackingLocation(coordinate: place.coordinate, shouldSave: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error in auto complete ==>> ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: HistoryDelegate {
    func DidSelectHistoryResponse(places: Places) {
        if let latitude = places.latitude, let longitude = places.longitude {
            trackingLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), shouldSave: false)
        }
    }
}
