//
//  AddAccountViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/21/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var cameraButton: UIButton?
    @IBOutlet weak var contactInfoContainerView: UIView?
    @IBOutlet weak var supervisorInfoContainerView: UIView?
    
    let imagePickerController = UIImagePickerController()
    
    var delegate: ReceivesAccountData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton?.setIcon(
            icon: .dripicon(.camera),
            iconSize: 30,
            color: .white,
            backgroundColor: UIColor.init(hex: 0x24B0FC),
            forState: .normal
        )
        
        imagePickerController.delegate = self
        avatar?.contentMode = .scaleAspectFill
        
        contactInfoContainerView?.isHidden = false
        supervisorInfoContainerView?.isHidden = true
    }
    
    /**
     * Dismiss the keyboard if the view is touched.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            contactInfoContainerView?.isHidden = false
            supervisorInfoContainerView?.isHidden = true
        case 1:
            contactInfoContainerView?.isHidden = true
            supervisorInfoContainerView?.isHidden = false
        default: break
        }
    }
    
    @IBAction func saveAccount(_ sender: Any) {
        let contact: Account.Contact = Account.Contact(name: "Great Account", phone: "4355551212", fax: "4355551234", email: "email@email.com", address: "1234 N. Main St.", city: "Washington", state: "UT", zip: "84780", notes: "Great notes")
        let supervisor: Account.Supervisor = Account.Supervisor(name: "Great Account", phone: "4355551212", email: "email@email.com")
        
        delegate?.receive(account: Account(contact: contact, supervisor: supervisor, monthlySales: (100, 1000), annualSales: (1000, 2000)))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(alert) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "From Photo Library", style: .default, handler: {(alert) -> Void in
            self.openPhotoLibrary()
        }))
        
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
