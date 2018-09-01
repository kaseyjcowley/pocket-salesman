//
//  AddAccountViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/21/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import SwiftIcons
import ContactsUI
import Eureka

class AddAccountViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var contentView: UIView?
    
    var accountType: AccountType? {
        didSet {
            if accountType == .individual {
                activeViewController = IndividualAccountFormViewController()
                addImportContactBarButton()
            } else if accountType == .organization {
                activeViewController = OrganizationAccountFormViewController()
                navigationItem.title = "Add Organization"
            }
        }
    }
    
    weak var delegate: ReceivesAccountDataDelegate?
    
    private let imagePickerController = UIImagePickerController()
    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        avatar?.contentMode = .scaleAspectFill
        
        updateActiveViewController()
    }
    
    @IBAction func saveAccount(_ sender: Any) {
        guard
            let activeVC = activeViewController as? HasForm,
            activeVC.form.validate().count == 0
        else {
            return
        }
        
        var values = activeVC.form.values()
        
        values["avatar"] = avatar?.image != nil
            ? UIImagePNGRepresentation((avatar?.image)!)
            : nil
        
        let account: BaseAccount = accountType == .individual
            ? Account(values)
            : Organization(values: values)

        delegate?.receive(account: account)
        navigationController?.popViewController(animated: true)
    }
    
    func getAccountFormViewController() -> IndividualAccountFormViewController? {
        return childViewControllers.first as? IndividualAccountFormViewController
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = contentView!.bounds
            contentView?.addSubview(activeVC.view)
            activeVC.didMove(toParentViewController: self)
        }
    }
    
}

// Handle editing the profile photo by an action sheet
extension AddAccountViewController {
    
    @IBAction func editPhotoButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(alert) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "From Photo Library", style: .default, handler: {(alert) -> Void in
            self.openPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
}

// Handle a selected/taken photo
extension AddAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatar?.image = pickedImage
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}

// Handle importing a contact
extension AddAccountViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        guard let accountFormVC = getAccountFormViewController() else {return}
        
        if let imageData = contact.imageData, contact.imageDataAvailable {
            avatar?.image = UIImage(data: imageData)
        }
        
        let postalAddress = contact.postalAddresses.first?.value
        
        accountFormVC.form.setValues([
            FormTags.Account.name: contact.organizationName,
            
            FormTags.Contact.name: contact.givenName + " " + contact.familyName,
            FormTags.Contact.phone: (contact.phoneNumbers.first?.value)?.value(forKey: "digits") as? String,
            FormTags.Contact.email: contact.emailAddresses.first?.value,
            FormTags.Contact.address: postalAddress?.street,
            FormTags.Contact.city: postalAddress?.city,
            FormTags.Contact.state: postalAddress?.state,
            FormTags.Contact.zip: postalAddress?.postalCode,
            
            FormTags.Miscellaneous.notes: contact.note,
        ])
        
        accountFormVC.tableView.reloadData()
    }
    
    private func addImportContactBarButton() {
        let importIcon = UIImage.init(icon: .dripicon(.download), size: CGSize(width: 30, height: 30))
        let importIconButton = UIBarButtonItem(image: importIcon, style: .plain, target: self, action: #selector(importContact(_:)))
        navigationItem.rightBarButtonItems?.append(importIconButton)
    }
    
    @objc private func importContact(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
    
}

protocol HasForm {
    var form: Form { get }
}
