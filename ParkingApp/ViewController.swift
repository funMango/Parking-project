//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}

