//
//  HomeViewController.swift
//  RescueApp
//
//  Created by Jayahari Vavachan on 8/17/18.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    ///PRIVATE
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var subHeadingLabel: UILabel!
    @IBOutlet private weak var headingContainer: UIView!
    @IBOutlet private weak var tableView: UITableView!
    // FileConstants
    private struct C {
        struct SEGUE {
            static let EMERGENCY_SOS = "segueToEmergencySOS"
            static let SURVEY = "segueToSurvey"
            static let CONTACTS = "segueToContacts"
            static let PHOTO_GALLERY = "segueToPhotoGallery"
            static let HOW_TO_PREPARE = "segueToHowToPrepare"
        }
        static let foodSegueID = "foodRequest"
        static let waterSegueID = "waterRequest"
        static let medicineSegueID = "medicineRequest"
        static let clothesSegueID = "clothesRequest"
        // QUOTES on HOME PAGE
        static let headingLabelText = "HomeHeading"
        static let subHeadingLabelText = "HomeSubHeading"
        static let TOP_QUOTES = "HOME_TOP_QUOTES_KERALA_RESCUE"
        static let BOTTOM_QUOTES = "HOME_BOTTOM_QUOTES_KERALA_RESCUE"
        static let alertTitle = "FirstAlert"
        static let LoadingDataFromServer = "LoadingDataFromServer"
        // Button Labels
        static let emergencySOSTextKey = "EmergencySOS"
        static let prepareTextKey = "Prepare"
        static let afterAFloodTextKey = "AfterAFlood"
        static let emergencyContactsTextKey = "EmergencyContacts"
        static let rescuePhotosTextKey = "RescuePhotos18"
        struct HomeCellKeys {
            static let title = "title"
            static let color = "color"
        }
    }
    private var homeCells: [[String: AnyObject]] {
        return [
            [C.HomeCellKeys.title: NSLocalizedString(C.emergencySOSTextKey, comment: "localized"), C.HomeCellKeys.color: RAColorSet.RED],
            [C.HomeCellKeys.title: NSLocalizedString(C.prepareTextKey, comment: "localized"), C.HomeCellKeys.color: RAColorSet.GREEN],
            [C.HomeCellKeys.title: NSLocalizedString(C.afterAFloodTextKey, comment: "localized"), C.HomeCellKeys.color: RAColorSet.LIGHT_BLUE],
            [C.HomeCellKeys.title: NSLocalizedString(C.emergencyContactsTextKey, comment: "localized"), C.HomeCellKeys.color: RAColorSet.PURPLE],
            [C.HomeCellKeys.title: NSLocalizedString(C.rescuePhotosTextKey, comment: "localized"), C.HomeCellKeys.color: RAColorSet.YELLOW]
        ] as [[String: AnyObject]]
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: Helper functions

extension HomeViewController {
    
    func configureUI() {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        // back button
        navigationItem.backBarButtonItem = UIBarButtonItem()
        
        // set texts
        headingLabel.text = NSLocalizedString(C.TOP_QUOTES, comment: "localized")
        subHeadingLabel.text = NSLocalizedString(C.BOTTOM_QUOTES, comment: "localized")
        
        titleLabel.text = NSLocalizedString("AppTitle", comment: "localized")
    }

    func updateUI() {
        navigationController?.navigationBar.barTintColor = RAColorSet.DARK_BLUE
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.isNavigationBarHidden = true
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = RAColorSet.DARK_BLUE
        }
    }
}

// MARK: HomeViewController -> UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell")
        let homeCellInfo = homeCells[indexPath.section]
        cell?.textLabel?.text = homeCellInfo[C.HomeCellKeys.title] as? String
        cell?.backgroundColor = homeCellInfo[C.HomeCellKeys.color] as? UIColor
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var identifier: String!
        switch indexPath.section {
        case 0:
            identifier = C.SEGUE.EMERGENCY_SOS
        case 1:
            identifier = C.SEGUE.HOW_TO_PREPARE
        case 2:
            let guideViewController = GuidelineContentController()
            self.navigationController?.pushViewController(guideViewController, animated: true)
            return
        case 3:
            identifier = C.SEGUE.CONTACTS
        case 4:
            identifier = C.SEGUE.PHOTO_GALLERY
        default:
            abort()
        }
        performSegue(withIdentifier: identifier, sender: nil)
    }
}
