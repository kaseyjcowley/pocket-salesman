//
//  AddAccountViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/21/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import SwiftIcons

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
        guard let accountFormVC = childViewControllers.first as? AccountFormViewController else {return}

        let accountValues = accountFormVC.formValues(forTagType: .account)
        let contactValues = accountFormVC.formValues(forTagType: .contact)
        let supervisorValues = accountFormVC.formValues(forTagType: .supervisor)
        let miscValues = accountFormVC.formValues(forTagType: .misc)
        
        let contact = Account.Contact(values: contactValues as! [String:String])
        let supervisor = Account.Supervisor(values: supervisorValues as! [String:String])
        
        let avatarImageData: Data? = avatar?.image !== nil
            ? UIImagePNGRepresentation((avatar?.image)!)
            : nil
        
        let account = Account(
            avatar: avatarImageData,
            name: accountValues["name"] as! String,
            contact: contact,
            supervisor: supervisor,
            notes: miscValues["notes"] as! String,
            monthlySales: (100, 199),
            annualSales: (200, 201)
        )
        
        delegate?.receive(account: account)
        navigationController?.popViewController(animated: true)
    }
    
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

extension AddAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatar?.image = pickedImage
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}
