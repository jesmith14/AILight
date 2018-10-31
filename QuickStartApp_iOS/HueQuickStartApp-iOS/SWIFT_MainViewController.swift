//
//  SWIFT_MainViewController.swift
//  HueQuickStartApp-iOS
//
//  Created by Landon Gerrits on 10/23/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import PythonAPI
import PerfectPython
import UIKit

@objc class SWIFT_MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var setLightsButton: UIButton!
    @IBOutlet weak var hueTextField: UITextField!
    @IBOutlet weak var saturationTextField: UITextField!
    @IBOutlet weak var brightnessTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(image, animated: true)
        {
            //after image has been selected
        }
    }
    
    @IBAction func didTapSetLights(_ sender: Any) {
        generateLightScheme()
    }
    
    @IBAction func didTapGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
