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
    
    var Light1: SingleLight = SingleLight(hue: 0,saturation: 0,brightness: 0)
    var Light2: SingleLight = SingleLight(hue: 0,saturation: 0,brightness: 0)
    var Light3: SingleLight = SingleLight(hue: 0,saturation: 0,brightness: 0)
   
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
    
    @IBAction func didTapGrouping1(_ sender: Any) {
        let vc = UIStoryboard(name: "ModifyColorVC", bundle: nil).instantiateViewController(withIdentifier: "ModifyColorVC") as? ModifyColorVC
        
        vc!.light = Light1
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func didTapGrouping2(_ sender: Any) {
        let vc = UIStoryboard(name: "ModifyColorVC", bundle: nil).instantiateViewController(withIdentifier: "ModifyColorVC") as? ModifyColorVC
        
        vc!.light = Light2
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func didTapGrouping3(_ sender: Any) {
        let vc = UIStoryboard(name: "ModifyColorVC", bundle: nil).instantiateViewController(withIdentifier: "ModifyColorVC") as? ModifyColorVC
        
        vc!.light = Light3
        
        self.present(vc!, animated: true, completion: nil)
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
                
                let hsb1 = self.rgbToHue(r: CGFloat(lightCollection.color1[0])/255, g: CGFloat(lightCollection.color1[1])/255, b: CGFloat(lightCollection.color1[2])/255)
                let hsb2 = self.rgbToHue(r: CGFloat(lightCollection.color2[0])/255, g: CGFloat(lightCollection.color2[1])/255, b: CGFloat(lightCollection.color2[2])/255)
                let hsb3 = self.rgbToHue(r: CGFloat(lightCollection.color3[0])/255, g: CGFloat(lightCollection.color3[1])/255, b: CGFloat(lightCollection.color3[2])/255)
                
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
