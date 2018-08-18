//
//  ResourceNeedsMapViewController.swift
//  RescueApp
//
//  Created by Jayahari Vavachan on 8/17/18.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

import UIKit
import MapKit

class ResourceNeedsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var requests = [RequestModel]()
    
    struct C {
        static let animationIdentifier = "ResourceListViewControllerFlip"
        static let ResourceListViewController = "ResourceNeedsListViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getResources()
    }
    
    @IBAction func onTouchUpList(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: C.ResourceListViewController)
        UIView.beginAnimations(C.animationIdentifier, context: nil)
        UIView.setAnimationDuration(1.0)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(.flipFromRight, for: (navigationController?.view)!, cache: false)
        navigationController?.pushViewController(vc!, animated: true)
        UIView.commitAnimations()
    }

}


extension ResourceNeedsMapViewController {
    func getResources() {
        Overlay.shared.show()
        ApiClient.shared.getResourceNeeds { [weak self] (requests) in
            Overlay.shared.remove()
            self?.requests = requests
            DispatchQueue.main.async { [weak self] in
                self?.updateMap()
            }
        }
    }
    
    func updateMap() {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        mapView.addAnnotations(requests)
    }
}
