//
//  ViewController.swift
//  Ass03_7433881
//
//  Created by Barbara Akaeze on 2017-04-12.
//  Copyright © 2017 Barbara Akaeze. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    //Get photo from gallery
    @IBAction func selectPhoto(_ sender: Any) {
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        selectImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(selectImage, animated: true)
    }
    //Get location
    @IBAction func getLocationBtn(_ sender: Any) {
    getLocation()
    }
    //Save photo from gallery
    @IBAction func saveBtn(_ sender: Any) {
        saveToDatabase()
    }
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getDateTime()
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

    //get dateTime
    func getDateTime() {
        dateTime.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
    }
    //get location
    func getLocation() {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            if (placemarks!.count) > 0 {
                let pLacemark = (placemarks![0]) as CLPlacemark
                self.displayLocationInfo(placemark: pLacemark)
            }
        }
    }
    //Print in text box
    func displayLocationInfo(placemark: CLPlacemark) {
        currentLocation.text = ("\(placemark.locality!), \(placemark.postalCode!), \(placemark.country!)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func saveToDatabase() {
        guard let userDescription = descriptionLabel.text, let userPosition = currentLocation.text, let currentDateTime = dateTime.text else {
            print ("Incorrect Data.")
            return }
    //creating Firebase table
    let ref = FIRDatabase.database().reference().child("user")
    let childRef = ref.childByAutoId()
    
        //Insert photo in DB
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("user_photos").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.imageView.image!)
        {
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    //Enter values in DB
                    let values = ["photo": imageURL, "description": userDescription, "position": userPosition, "DateTime": currentDateTime ] as [String : Any]
                    childRef.updateChildValues(values) { (err, ref) in
                        
                        if err != nil {
                            print(err as Any)
                            return
                        }
                        print("User stored in Database")
                    }
                }
            })
        }
   
        print("User info stored in Database")
}
    
}

