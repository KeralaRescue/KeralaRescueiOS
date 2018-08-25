//
/*
ContactsViewController.swift
Created on: 23/8/18

Abstract:
 this class will show all the contact lists

*/

import UIKit
import FirebaseDatabase

final class ContactsViewController: UIViewController {
    
    // MARK: Properties
    /// PRIVATE
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var infoTitlaLabel: UILabel!
    private var contactKeys = [String]()
    private var contactsSections = [String: String]()
    private var contactsSectionDetails = [String: [Contact]]()
    private struct C {
        static let tableCellId = "contactsSectionCell"
        struct FirebaseKeys {
            static let CONTACTS_ROOT = "contacts"
            static let SECTIONS = "sections"
            static let SECTION_DETAILS = "section_details"
        }
        static let segueToList = "segueToContactList"
    }
    private var ref: DatabaseReference?

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadFromFirebase()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.segueToList {
            let vc = segue.destination as! ContactsListViewController
            vc.contacts = sender as! [Contact]
        }
    }
}

// MARK: Helper methods

private extension ContactsViewController {
    /**
     configure all UI items inside this, once its loaded.
     
     */
    func configureUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    /**
     load the contacts list from firebase
     
     - todo: implementation not done
     */
    func loadFromFirebase() {
        ref = Database.database().reference()
        ref?.child(C.FirebaseKeys.CONTACTS_ROOT).observe(DataEventType.value, with: { [weak self] (snapshot) in
            let contents = snapshot.value as? [String: AnyObject] ?? [:]
            self?.contactsSections = contents[C.FirebaseKeys.SECTIONS] as? [String: String] ?? [:]
            if let names = self?.contactsSections.keys {
                self?.contactKeys = Array(names)
            }
            
            let details = contents[C.FirebaseKeys.SECTION_DETAILS] as? [String: AnyObject] ?? [:]
            for sectionDetail in details {
                
                if let value = sectionDetail.value as? [String: AnyObject] {
                    var phones = [Contact]()
                    for contacts in value {
                        let contact = Contact(contacts.key, phone: contacts.value)
                        phones.append(contact)
                    }
                    self?.contactsSectionDetails[sectionDetail.key] = phones
                }    
            }
            
            self?.refreshUI()
        })
    }
    
    /**
     refreshes the UI, especially tableview
     
     */
    func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: ContactsViewController -> UITableViewDataSource

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: C.tableCellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: C.tableCellId)
        }
        let contact = contactsSections[contactKeys[indexPath.row]]
        cell?.textLabel?.text = contact
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionDetail = contactsSectionDetails[contactKeys[indexPath.row]]
        performSegue(withIdentifier: C.segueToList, sender: sectionDetail ?? [])
    }
}
