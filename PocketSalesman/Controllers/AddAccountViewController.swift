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

class AddAccountViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView?
    
    let imagePickerController = UIImagePickerController()
    
    weak var delegate: ReceivesAccountDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        avatar?.contentMode = .scaleAspectFill
    }
    
    @IBAction func saveAccount(_ sender: Any) {
        guard let accountFormVC = getAccountFormViewController() else {return}
        guard accountFormVC.form.validate().count == 0 else {return} // Show something useful?

        let accountValues = accountFormVC.formValues(forTagType: .account)
        let miscValues = accountFormVC.formValues(forTagType: .misc)
        
        var contactValues = [String:String]()
        for (key, value) in accountFormVC.formValues(forTagType: .contact) {
            contactValues[key] = value as? String
        }
        
        var supervisorValues = [String:String]()
        for (key, value) in accountFormVC.formValues(forTagType: .contact) {
            supervisorValues[key] = value as? String
        }
        
        let contact = Account.Contact(values: contactValues)
        let supervisor = Account.Supervisor(values: supervisorValues)
        
        let avatarImageData: Data? = avatar?.image !== nil
            ? UIImagePNGRepresentation((avatar?.image)!)
            : nil
        
        let account = Account(
            avatar: avatarImageData,
            name: accountValues["name"] as! String,
            contact: contact,
            supervisor: supervisor,
            notes: miscValues["notes"] as! String,
            monthlySales: (0, miscValues["monthlyGoal"] as! Double),
            annualSales: (0, miscValues["annualGoal"] as! Double)
        )
        
        delegate?.receive(account: account)
        navigationController?.popViewController(animated: true)
    }
    
    func getAccountFormViewController() -> AccountFormViewController? {
        return childViewControllers.first as? AccountFormViewController
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
    
    @IBAction func importContact(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
    
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
    
}
