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
    
    var hue : Float = 0
    var saturation : Float = 0
    var brightness : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hueSlider.value = self.hue
        self.saturationSlider.value = self.saturation
        self.brightnessSlider.value = self.brightness
    }
    
    @IBAction func hueChanged(_ sender: Any) {
        hueLabel.text = "\(hueSlider.value)"
        self.hue = hueSlider.value
        colorView.backgroundColor = UIColor(hue: CGFloat(self.hue), saturation: CGFloat(self.saturation), brightness: CGFloat(self.brightness), alpha: 1.0)
    }
    
    @IBAction func saturationChanged(_ sender: Any) {
        saturationLabel.text = "\(saturationSlider.value)"
        self.saturation = saturationSlider.value
        colorView.backgroundColor = UIColor(hue: CGFloat(self.hue), saturation: CGFloat(self.saturation), brightness: CGFloat(self.brightness), alpha: 1.0)
    }
    
    @IBAction func brightnessChanged(_ sender: Any) {
        brightnessLabel.text = "\(saturationSlider.value)"
        self.brightness = brightnessSlider.value
        colorView.backgroundColor = UIColor(hue: CGFloat(self.hue), saturation: CGFloat(self.saturation), brightness: CGFloat(self.brightness), alpha: 1.0)
    }
    
    @IBAction func didTapSetColor(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
