//
//  ViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

import IGRPhotoTweaks

class ViewController: UIViewController {

    @IBOutlet weak fileprivate var imageView: UIImageView?
    
    fileprivate var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                       target: self,
                                       action: #selector(self.openEdit))
        
        let libraryItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                          target: self,
                                          action: #selector(self.openLibrary))
        
        self.navigationItem.leftBarButtonItem = libraryItem
        self.navigationItem.rightBarButtonItem = editItem
        
        if (self.image == nil) {
            openLibrary()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCrop" {
            
            let exampleCropViewController = segue.destination as! ExampleCropViewController
            exampleCropViewController.image = sender as! UIImage
            exampleCropViewController.delegate = self
        }
    }
    
    // MARK: - Funcs
    
    func openLibrary() {
        let pickerView = UIImagePickerController.init()
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerView, animated: true, completion: nil)
    }
    
    func openEdit() {
        self.edit(image: self.image)
    }
    
    func edit(image: UIImage) {
        self.performSegue(withIdentifier: "showCrop", sender: image)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.image = image
        
        picker.dismiss(animated: true) {
            self.edit(image: image)
        }
    }
}

extension ViewController: IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        self.imageView?.image = croppedImage
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}
