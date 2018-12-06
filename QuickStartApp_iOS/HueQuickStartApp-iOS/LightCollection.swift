//
//  LightCollection.swift
//  HueQuickStartApp-iOS
//
//  Created by Andrew Cofano on 12/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation

struct LightCollection : Codable {
   var kmeans : [Float]
   var colors: [Float]
   
   private enum CodingKeys: String, CodingKey {
      case kmeans
      case colors
   }
   
}


/*func parseLightsData(data:Data) {
   do {
    let decoder = JSONDecoder()
    let lightCollection = try decoder.decode(LightCollection.self, from: data)
 
   
}
*/
