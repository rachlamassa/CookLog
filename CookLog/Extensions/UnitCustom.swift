//
//  UnitCustom.swift
//  CookLog
//

import Foundation

// non mass, volume, length units and lets us use UnitCustom.slices, etc
class UnitCustom: Dimension {
    // defines custom unit, linear unit converter is 1 bc units are not convertible to anything else
    static let pinch = UnitCustom(symbol: "pinch", converter: UnitConverterLinear(coefficient: 1))
    static let dash = UnitCustom(symbol: "dash", converter: UnitConverterLinear(coefficient: 1))
    static let pcs = UnitCustom(symbol: "pcs", converter: UnitConverterLinear(coefficient: 1))
    static let slice = UnitCustom(symbol: "slice", converter: UnitConverterLinear(coefficient: 1))
    static let clove = UnitCustom(symbol: "clove", converter: UnitConverterLinear(coefficient: 1))
    static let can = UnitCustom(symbol: "can", converter: UnitConverterLinear(coefficient: 1))
    static let package = UnitCustom(symbol: "package", converter: UnitConverterLinear(coefficient: 1))
    static let stick = UnitCustom(symbol: "stick", converter: UnitConverterLinear(coefficient: 1))
    
    // what the custom unit will default te (ex: volume's base unit is liters)
    override class func baseUnit() -> Self {
        return pcs as! Self
    }
}
