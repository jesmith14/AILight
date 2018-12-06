//
//  ModifyColorVC.swift
//  HueQuickStartApp-iOS
//
//  Created by Landon Gerrits on 12/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation

class ModifyColorVC: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var hueLabel: UILabel!
    
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var saturationLabel: UILabel!
    
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var brightnessLabel: UILabel!
    
    var source: SWIFT_MainViewController?
    
    var light : SingleLight = SingleLight(hue: 360, saturation: 0, brightness: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hueSlider.value = Float(self.light.hue)
        self.saturationSlider.value = Float(self.light.saturation)
        self.brightnessSlider.value = Float(self.light.brightness)
        
        self.hueLabel.text = "\((hueSlider.value * 360).rounded())"
        self.saturationLabel.text = "\((saturationSlider.value * 100).rounded())"
        self.brightnessLabel.text = "\((brightnessSlider.value * 100).rounded())"
        
        self.colorView.backgroundColor = UIColor(hue: self.light.hue, saturation: self.light.saturation, brightness: self.light.brightness, alpha: 1.0)
    }
    
    @IBAction func hueChanged(_ sender: Any) {
        self.hueLabel.text = "\((hueSlider.value * 360).rounded())"
        self.light.hue = CGFloat(hueSlider.value)
        self.colorView.backgroundColor = UIColor(hue: self.light.hue, saturation: self.light.saturation, brightness: self.light.brightness, alpha: 1.0)
    }
    
    @IBAction func saturationChanged(_ sender: Any) {
        self.saturationLabel.text = "\((saturationSlider.value * 100).rounded())"
        self.light.saturation = CGFloat(saturationSlider.value)
        self.colorView.backgroundColor = UIColor(hue: self.light.hue, saturation: self.light.saturation, brightness: self.light.brightness, alpha: 1.0)
    }
    
    
    @IBAction func brightnessChanged(_ sender: Any) {
        self.brightnessLabel.text = "\((brightnessSlider.value * 100).rounded())"
        self.light.brightness = CGFloat(brightnessSlider.value)
        self.colorView.backgroundColor = UIColor(hue: self.light.hue, saturation: self.light.saturation, brightness: self.light.brightness, alpha: 1.0)
    }
    
    @IBAction func didTapSetColor(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
