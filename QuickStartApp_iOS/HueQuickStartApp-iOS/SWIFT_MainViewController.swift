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
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var grouping1: UIView!
    @IBOutlet weak var grouping2: UIView!
    @IBOutlet weak var grouping3: UIView!
    
    // hue
    // saturation
    // brightness
   
    var imagePicker = UIImagePickerController()
    var currentImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func getHueValue(hueValue: Int) -> Int {
        
        return (hueValue / 360) * 65535
    }
    
    func generateLightScheme(){
        
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()!
        
        let bridgeSendAPI = PHBridgeSendAPI()
        
        for light in cache.lights.values {
            
            if light is PHLight {
                let lightState = PHLightState()
                
                lightState.hue = 360
                lightState.saturation = 100
                lightState.brightness = 100
                
                // Send lightstate to light
                bridgeSendAPI.updateLightState(forId: (light as AnyObject).identifier, with: lightState, completionHandler: nil)
            }
        }
    }
    
    @IBAction func didTapImportPhoto(_ sender: UIButton) {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true,completion: nil)
        
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
            self.imageView.image = currentImage;
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
//               //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                   print(json)
//                        // handle json...
               }
               let decoder = JSONDecoder()
               let lightCollection = try decoder.decode(LightCollection.self, from: data)
                print("DATA: ")
                print(data)
               var Light1 = SingleLight(hue: lightCollection.color1[0], saturation: lightCollection.color1[1], brightness: lightCollection.color1[2])
               var Light2 = SingleLight(hue: lightCollection.color2[0], saturation: lightCollection.color2[1], brightness: lightCollection.color2[2])
               var Light3 = SingleLight(hue: lightCollection.color3[0], saturation: lightCollection.color3[1], brightness: lightCollection.color3[2])
                print(CGFloat(Light1.hue))
                print(CGFloat(Light1.saturation))
                print(CGFloat(Light1.brightness))
                self.grouping1.backgroundColor = UIColor(red: CGFloat(Light1.hue)/255.0, green: CGFloat(Light1.saturation)/255.0, blue: CGFloat(Light1.brightness)/255.0, alpha: 1.0)
                self.grouping2.backgroundColor = UIColor(red: CGFloat(Light2.hue)/255.0, green: CGFloat(Light2.saturation)/255.0, blue: CGFloat(Light2.brightness)/255.0, alpha: 1.0)
                self.grouping3.backgroundColor = UIColor(red: CGFloat(Light3.hue)/255.0, green: CGFloat(Light3.saturation)/255.0, blue: CGFloat(Light3.brightness)/255.0, alpha: 1.0)
                
                DispatchQueue.main.async {
                    self.grouping1.backgroundColor = UIColor(red: CGFloat(Light1.hue)/255.0, green: CGFloat(Light1.saturation)/255.0, blue: CGFloat(Light1.brightness)/255.0, alpha: 1.0)
                    self.grouping2.backgroundColor = UIColor(red: CGFloat(Light2.hue)/255.0, green: CGFloat(Light2.saturation)/255.0, blue: CGFloat(Light2.brightness)/255.0, alpha: 1.0)
                    self.grouping3.backgroundColor = UIColor(red: CGFloat(Light3.hue)/255.0, green: CGFloat(Light3.saturation)/255.0, blue: CGFloat(Light3.brightness)/255.0, alpha: 1.0)
                }
               //self.grouping1.backgroundColor = UIColor(hue: CGFloat(Light1.hue), saturation: CGFloat(Light1.saturation), brightness: CGFloat(Light1.brightness), alpha: 1.0)
               //self.grouping2.backgroundColor = UIColor(hue: CGFloat(Light2.hue), saturation: CGFloat(Light2.saturation), brightness: CGFloat(Light2.brightness), alpha: 1.0)
               //self.grouping3.backgroundColor = UIColor(hue: CGFloat(Light3.hue), saturation: CGFloat(Light3.saturation), brightness: CGFloat(Light3.brightness), alpha: 1.0)
               
            } catch let error {
                    print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
}
