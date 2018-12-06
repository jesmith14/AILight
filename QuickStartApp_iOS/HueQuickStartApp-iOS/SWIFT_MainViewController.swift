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
    
    var Light1: SingleLight = SingleLight(hue: 360,saturation: 100,brightness: 100)
    var Light2: SingleLight = SingleLight(hue: 360,saturation: 100,brightness: 100)
    var Light3: SingleLight = SingleLight(hue: 360,saturation: 100,brightness: 100)
   
    var imagePicker = UIImagePickerController()
    var currentImage : UIImage!
    var grouping : Int = 0

    var kmeansArray : [[Float]] = [[0,0,0,0], [0,0,0,0], [0,0,0,0]]
    var givenHSB : [[Float]] = [[0,0,0], [0,0,0], [0,0,0]]
    var userHSB : [[Float]] = [[0,0,0], [0,0,0], [0,0,0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
    }
   
    func getHueValue(hueValue: CGFloat) -> Int {
        
        return Int(hueValue * 65535)
    }
    
    func generateLightScheme(){
        
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()!
        
        let bridgeSendAPI = PHBridgeSendAPI()

        var currentLight = 1
        for light in cache.lights.values {
            
            if light is PHLight {
                let lightState = PHLightState()
                
                if currentLight == 1 {
                    lightState.hue = NSNumber(value: Int(getHueValue(hueValue: Light1.hue)))
                    lightState.saturation = NSNumber(value: Int(Float(Light1.saturation)*254))
                    lightState.brightness = NSNumber(value: Int(Float(Light1.brightness)*254))
                } else if currentLight == 2 {
                    lightState.hue = NSNumber(value: Int(getHueValue(hueValue: Light2.hue)))
                    lightState.saturation = NSNumber(value: Int(Float(Light2.saturation)*254))
                    lightState.brightness = NSNumber(value: Int(Float(Light2.brightness)*254))
                } else {
                    lightState.hue = NSNumber(value: Int(getHueValue(hueValue: Light3.hue)))
                    lightState.saturation = NSNumber(value: Int(Float(Light3.saturation)*254))
                    lightState.brightness = NSNumber(value: Int(Float(Light3.brightness)*254))
                }
                
                currentLight += 1
                
                // Send lightstate to light
                bridgeSendAPI.updateLightState(forId: (light as AnyObject).identifier, with: lightState, completionHandler: nil)
            }
        }
    }
   
    @IBAction func didTapImportPhoto(_ sender: UIButton) {
        let req = NSMutableURLRequest(url: NSURL(string:"http://0.0.0.0:5000/startNeuralNet")! as URL)
        let ses = URLSession.shared
        req.httpMethod = "POST"
        req.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        req.setValue("test", forHTTPHeaderField: "X-FileName")
        let task = ses.dataTask(with: req as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
        
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true,completion: nil)
        
    }
    
    @IBAction func didTapSetLights(_ sender: Any) {
        generateLightScheme()
    }
   
    @IBAction func didTapGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
   @IBAction func unwindFromColorPicker(_ sender: UIStoryboardSegue){
      if sender.source is ModifyColorVC {
         if let colorPickerVC = sender.source as? ModifyColorVC {
            self.handleLightChange(newLight: colorPickerVC.light)
         }
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
      let vc = segue.destination as? ModifyColorVC
    
      if segue.identifier == "grouping1" {
        self.grouping = 1
        vc?.light = Light1
      }
      else if segue.identifier == "grouping2" {
        self.grouping = 2
        vc?.light = Light2
      }
      else {
        self.grouping = 3
        vc?.light = Light3
      }
   }
    
    func handleLightChange(newLight: SingleLight) {
        print("CALLING HANDLE LIGHT CHANGE ", grouping)
        
        if self.grouping == 1 {
        Light1 = SingleLight(hue: newLight.hue, saturation: newLight.saturation, brightness: newLight.brightness)
        self.grouping1.backgroundColor = UIColor(hue: self.Light1.hue, saturation: self.Light1.saturation, brightness: self.Light1.brightness, alpha: 1.0)
        }
        else if self.grouping == 2 {
        Light2 = SingleLight(hue: newLight.hue, saturation: newLight.saturation, brightness: newLight.brightness)
        self.grouping2.backgroundColor = UIColor(hue: self.Light2.hue, saturation: self.Light2.saturation, brightness: self.Light2.brightness, alpha: 1.0)
        }
        else {
        Light3 = SingleLight(hue: newLight.hue, saturation: newLight.saturation, brightness: newLight.brightness)
        self.grouping3.backgroundColor = UIColor(hue: self.Light3.hue, saturation: self.Light3.saturation, brightness: self.Light3.brightness, alpha: 1.0)
        }
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
               
               let kmean = lightCollection.kmeans
               let hsbGiven = lightCollection.colors
               self.kmeansArray = [[kmean[0], kmean[1], kmean[2], kmean[3]], [kmean[4], kmean[5], kmean[6], kmean[7]], [kmean[8], kmean[9], kmean[10], kmean[11]]]
               self.givenHSB = [[hsbGiven[0], hsbGiven[1], 100], [hsbGiven[3], hsbGiven[4], 100], [hsbGiven[6], hsbGiven[7], 100]]
               
               let hsb1 = self.rgbToHue(r: CGFloat(lightCollection.colors[0])/255, g: CGFloat(lightCollection.colors[1])/255, b: 100/255)
                let hsb2 = self.rgbToHue(r: CGFloat(lightCollection.colors[3])/255, g: CGFloat(lightCollection.colors[4])/255, b: 100/255)
                let hsb3 = self.rgbToHue(r: CGFloat(lightCollection.colors[6])/255, g: CGFloat(lightCollection.colors[7])/255, b: 100/255)
                
                print("hsb1")
                print(hsb1.h)
                print(hsb1.s)
                print(hsb1.b)
                
                self.Light1 = SingleLight(hue: hsb1.h, saturation: hsb1.s, brightness: hsb1.b)
                self.Light2 = SingleLight(hue: hsb2.h, saturation: hsb2.s, brightness: hsb2.b)
                self.Light3 = SingleLight(hue: hsb3.h, saturation: hsb3.s, brightness: hsb3.b)
                
                DispatchQueue.main.async {
                    self.grouping1.backgroundColor = UIColor(hue: self.Light1.hue, saturation: self.Light1.saturation, brightness: self.Light1.brightness, alpha: 1.0)
                    self.grouping2.backgroundColor = UIColor(hue: self.Light2.hue, saturation: self.Light2.saturation, brightness: self.Light2.brightness, alpha: 1.0)
                    self.grouping3.backgroundColor = UIColor(hue: self.Light3.hue, saturation: self.Light3.saturation, brightness: self.Light3.brightness, alpha: 1.0)
                }
               
            } catch let error {
                    print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    func rgbToHue(r:CGFloat,g:CGFloat,b:CGFloat) -> (h:CGFloat, s:CGFloat, b:CGFloat) {
        let minV:CGFloat = CGFloat(min(r, g, b))
        let maxV:CGFloat = CGFloat(max(r, g, b))
        let delta:CGFloat = maxV - minV
        var hue:CGFloat = 0
        if delta != 0 {
            if r == maxV {
                hue = (g - b) / delta
            }
            else if g == maxV {
                hue = 2 + (b - r) / delta
            }
            else {
                hue = 4 + (r - g) / delta
            }
            hue *= 60
            if hue < 0 {
                hue += 360
            }
        }
        let saturation = maxV == 0 ? 0 : (delta / maxV)
        let brightness = maxV
        return (h:hue/360, s:saturation, b:brightness)
    }
    
}
