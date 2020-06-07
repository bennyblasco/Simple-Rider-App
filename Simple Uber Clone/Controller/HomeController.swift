//
//  HomeController.swift
//  Uber
//
//  Created by Diego Oruna on 1/9/20.
//  Copyright © 2020 Diego Oruna. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import SwiftUI

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    fileprivate let mapView = MKMapView()
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate let inputActivationView = LocationInputActivationView()
    fileprivate let locationInputView = LocationInputView()
    
    fileprivate let locationInputViewHeight:CGFloat = 200
    
    fileprivate let tableView = UITableView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #warning("Verify Later")
        checkIfUserIsLoggedIn()
    }
    
    //MARK: - API
    fileprivate func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            presentLoginController()
        }else{
            configureUI()
        }
    }
    
    fileprivate func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    fileprivate func signOut(){
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0))
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 1.5) {
            self.inputActivationView.alpha = 1
        }
        
        configureTableView()
    }
    
    fileprivate func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        mapView.overrideUserInterfaceStyle = .dark
    }
    
    fileprivate func configureLocationInputView(){
        
        locationInputView.delegate = self
        
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: locationInputViewHeight))
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { (_) in
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                self.tableView.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height - self.locationInputViewHeight))
                self.tableView.frame.origin.y = self.locationInputViewHeight
            })
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private let cellID = "cellId"
    
    fileprivate func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = 60
        
        let height = view.frame.height - locationInputView.frame.height
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
}

// MARK: - Location Services

extension HomeController:CLLocationManagerDelegate{
    
    func enableLocationServices(){
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {

        case .notDetermined:
            print("Not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("Auth always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Auth when in use")
            locationManager.requestAlwaysAuthorization()
        @unknown default:  
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}

extension HomeController:LocationInputActivationViewDelegate{
    
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
    
}

extension HomeController:LocationInputViewDelegate{
    func dismissLocationInputView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        }) { (_) in
            self.locationInputView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}

//MARK:- UITableViewDelegate/Datasource

extension HomeController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0{
            return 18
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0 {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.8, alpha: 1)
            return view
        }else{
            return UIView()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LocationCell
        return cell
        
    }
}
