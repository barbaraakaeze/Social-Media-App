//
//  ViewController.swift
//  Ass03_7433881
//
//  Created by Barbara Akaeze on 2017-04-12.
//  Copyright © 2017 Barbara Akaeze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
   // @IBOutlet weak var description: UITextView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    //Get photo from gallery
    @IBAction func selectPhoto(_ sender: Any) {
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        selectImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(selectImage, animated: true)
        
    }
    //Save photo from gallery
    @IBAction func saveBtn(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Get image from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = selectImage
        }
        self.dismiss(animated: true, completion: nil)
    }

}

