//
//  SWIFT_MainViewController.swift
//  HueQuickStartApp-iOS
//
//  Created by Landon Gerrits on 10/23/18.
//  Copyright © 2018 Philips. All rights reserved.
//
import UIKit
import Alamofire
@objc class SWIFT_MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var setLightsButton: UIButton!
    @IBOutlet weak var hueTextField: UITextField!
    @IBOutlet weak var saturationTextField: UITextField!
    @IBOutlet weak var brightnessTextField: UITextField!
    var image = UIImagePickerController()
    var currentImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
    }
    
    func generateLightScheme(){
        
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()!
        
        let bridgeSendAPI = PHBridgeSendAPI()
        
        for light in cache.lights.values {
            
            if light is PHLight {
                let lightState = PHLightState()
                let hueString = hueTextField.text
                if let myInteger = Float(hueString!) {
                    lightState.hue = (Int((myInteger / 254.0) * 65535)) as NSNumber
                }
                
                lightState.saturation = Int(saturationTextField.text!)! as NSNumber
                lightState.brightness = Int(brightnessTextField.text!)! as NSNumber
                
                // Send lightstate to light
                bridgeSendAPI.updateLightState(forId: (light as AnyObject).identifier, with: lightState, completionHandler: nil)
            }
            
            
        }
    }
    @IBAction func didTapImportPhoto(_ sender: UIButton) {
        //let image = UIImagePickerController()
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(image, animated: true,completion: nil)

    }
    
    @IBAction func didTapSetLights(_ sender: Any) {
        generateLightScheme()
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SWIFT_MainViewController{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let selectedImage = info[.originalImage] as? UIImage{
            currentImage = selectedImage
        }
        dismiss(animated:true,completion: nil)
        //let name = "testName"
        sendRequest(name: "testName")
    }
    func sendRequest(name:String){
        let req = NSMutableURLRequest(url: NSURL(string:"http://0.0.0.0:5000/imageUpload")! as URL)
        let ses = URLSession.shared
        req.httpMethod = "POST"
        req.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        req.setValue(name, forHTTPHeaderField: "X-FileName")
        let jpgData = currentImage.jpegData(compressionQuality: 1.0)
        req.httpBody = jpgData
        let task = ses.dataTask(with: req as URLRequest, completionHandler: { data, response, error in
                
            guard error == nil else {
                return
            }
                
            guard let data = data else {
                return
            }
            do {
                    //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                        // handle json...
                }
            } catch let error {
                    print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
