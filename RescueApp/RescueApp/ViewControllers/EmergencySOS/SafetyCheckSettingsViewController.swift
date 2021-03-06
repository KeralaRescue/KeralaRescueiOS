//
/*
SafetyCheckSettingsViewController.swift
Created on: 15/9/18

Abstract:
 this will include the safety check settings
 - add emergency contacts
 - set the message
 - enable location sharing
 - see the list of emergency contacts

*/

import UIKit
import ContactsUI
import CouchbaseLiteSwift
import CoreLocation

final class SafetyCheckSettingsViewController: UIViewController {
    
    // MARK: Properties
    /// IBOUTLETS
    @IBOutlet private weak var helpNeededTextView: UITextView!
    @IBOutlet private weak var markAsSafeTextView: UITextView!
    @IBOutlet private weak var canShareLocationSwitch: UISwitch!
    @IBOutlet private weak var contactsTableView: UITableView!
    @IBOutlet private weak var noContactsWarningLabel: UILabel!
    @IBOutlet private weak var addRecipientsButton: UIButton!
    @IBOutlet weak var markAsSafeLabel: UILabel!
    @IBOutlet weak var needHelpLabel: UILabel!
    @IBOutlet weak var shareLocationLabel: UILabel!
    /// iVARs
    private var contacts = [EmergencyContact]()
    private let locationManager = CLLocationManager()
    private struct C {
        static let CELL_ID = "safetyCheckCellID"
        
        // localization keys
        static let titleTextKey = "EmergencySettings"
        static let markAsSafeTextKey = "MarkAsSafeMessage"
        static let needHelpTextKey = "NeedHelpMessage"
        static let shareCurrentLocationTextKey = "ShareCurrentLocation"
        static let addEmergencyContactsTextKey = "AddEmergencyContacts"
        static let noContactsAddedTextKey = "NoContactsAdded"
        static let contactsTitleTextKey = "Contacts"
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIFromViewDidLoad()
        addTapToHideKeyboardGesture()
        fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBarColor(RAColorSet.RED)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveLocationPreference()
    }
    
    // MARK: Button Actions
    
    @IBAction func onAddRecipients(_ sender: Any) {
        let contactPicker = CNContactPickerViewController(nibName: nil, bundle: nil)
        contactPicker.delegate = self
        present(contactPicker, animated: true) { [weak self] in
            self?.setStatusBarColor(RAColorSet.STATUS_BAR_COLOR)
        }
    }
    
    @IBAction func onToggleLocationSwitch(_ sender: Any) {
        saveLocationPreference()
    }
    
    @IBAction func onEdit(_ sender: Any) {
        isEditing = !isEditing
        contactsTableView.setEditing(isEditing, animated: true)
    }
    
    @IBAction func onClearAll(_ sender: Any) {
        // implement
    }
}

private extension SafetyCheckSettingsViewController {
    func configureUIFromViewDidLoad() {
        title = NSLocalizedString(C.titleTextKey, comment: "localized")
        markAsSafeLabel.text = NSLocalizedString(C.markAsSafeTextKey, comment: "localized")
        needHelpLabel.text = NSLocalizedString(C.needHelpTextKey, comment: "localized")
        shareLocationLabel.text = NSLocalizedString(C.shareCurrentLocationTextKey, comment: "localized")
        noContactsWarningLabel.text = NSLocalizedString(C.noContactsAddedTextKey, comment: "localized")
        addRecipientsButton.setTitle(NSLocalizedString(C.addEmergencyContactsTextKey, comment: "localized"), for: .normal)
        
        helpNeededTextView.text =
            fetchCustomMessage(Constants.UserDefaultsKeys.DANGER_NEED_HELP_MESSAGE) ?? Constants.DANGER_NEED_HELP_MESSAGE
        markAsSafeTextView.text =
            fetchCustomMessage(Constants.UserDefaultsKeys.MARK_AS_SAFE_MESSAGE) ?? Constants.MARK_AS_SAFE_MESSAGE
        canShareLocationSwitch.isOn = fetchCanShareLocation()
        addRecipientsButton.backgroundColor = RAColorSet.WARNING_RED
        configureContactsUI(contacts.count > 0)
    }
    
    func fetchContacts() {
        contacts = EmergencyContactUtil.fetchContacts()
        refreshContacts()
    }
    
    func refreshContacts() {
        configureContactsUI(contacts.count > 0)
        contactsTableView.reloadData()
    }
    
    func addTapToHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        helpNeededTextView.resignFirstResponder()
        markAsSafeTextView.resignFirstResponder()
    }
    
    func fetchCustomMessage(_ key: String) -> String? {
        if let danger = UserDefaults.standard.string(forKey: key) {
            return danger
        }
        return nil
    }
    
    func saveMessage(_ message: String, key: String) {
        guard message != fetchCustomMessage(key) else {
            return
        }
        UserDefaults.standard.set(message, forKey: key)
    }
    
    func fetchCanShareLocation() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.CAN_LOCATION_SHARED)
    }
    
    func saveLocationPreference() {
        guard canShareLocationSwitch.isOn != fetchCanShareLocation() else {
            return
        }
        UserDefaults.standard.set(canShareLocationSwitch.isOn, forKey: Constants.UserDefaultsKeys.CAN_LOCATION_SHARED)
        if canShareLocationSwitch.isOn {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func configureContactsUI(_ contactsPresent: Bool) {
        contactsTableView.isHidden = !contactsPresent
        noContactsWarningLabel.isHidden = contactsPresent
    }
    
    func setStatusBarColor(_ color: UIColor) {
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
    }
    
    func removeAllContacts() {
        do {
            let database = try Database(name: "RescueApp")
            let doc = MutableDocument(id: APIConstants.CBL_KEYS.EMERGENCY_CONTACTS_ROOT_KEY)
            try database.saveDocument(doc)
        } catch {
            print("test")
        }
    }
}


extension SafetyCheckSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.CELL_ID)
        cell?.selectionStyle = .none
        let contact = contacts[indexPath.row]
        cell?.textLabel?.text = contact.displayName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(C.contactsTitleTextKey, comment: "localized")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = contacts[indexPath.row]
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            contact.delete()
            configureContactsUI(contacts.count > 0)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension SafetyCheckSettingsViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        saveMessage(textView.text,
                    key: textView == helpNeededTextView
                        ? Constants.UserDefaultsKeys.DANGER_NEED_HELP_MESSAGE
                        : Constants.UserDefaultsKeys.MARK_AS_SAFE_MESSAGE)
        return true
    }
}

extension SafetyCheckSettingsViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var tempContacts = [EmergencyContact]()
        for contact in contacts {
            if self.contacts.filter({$0.isIdentiferEqual(contact.identifier)}).count == 0 {
                let contact = EmergencyContact.init(contact)
                tempContacts.append(contact)
            }
        }
        
        for (index, contact) in tempContacts.enumerated() {
            contact.save()
            self.contacts.append(contact)
            let indexpath = IndexPath(row: index, section: 0)
            contactsTableView.insertRows(at: [indexpath], with: .automatic)
        }
        
        
        refreshContacts()
    }
}
