//
//  LightCollection.swift
//  HueQuickStartApp-iOS
//
//  Created by Andrew Cofano on 12/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation

struct LightCollection : Codable {
   var color1 : [Int]
   var color2: [Int]
   var color3: [Int]
   
   private enum CodingKeys: String, CodingKey {
      case color1
      case color2
      case color3
   }
   
}


/*func parseLightsData(data:Data) {
   do {
    let decoder = JSONDecoder()
    let lightCollection = try decoder.decode(LightCollection.self, from: data)
 
   
}
*/
