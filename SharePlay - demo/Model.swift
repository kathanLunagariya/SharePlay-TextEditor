//
//  Model.swift
//  SharePlay - demo
//
//  Created by Kathan Lunagariya on 27/10/21.
//

import Foundation
import UIKit

struct SharedEditData: Codable{
    let cardBGColor:Color
    let fontDescriptor:Descriptor
    let Text:String
}


struct Color : Codable {
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor : UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(uiColor : UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}


struct Descriptor : Codable {
    var name:String
    
    init(family: String){
        self.name = family
    }
}
