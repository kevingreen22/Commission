//
//  Service+CoreDataProperties.swift
//  Comish
//
//  Created by Kevin Green on 10/16/20.
//
//

import Foundation
import CoreData
import UIKit.UIColor
import SwiftUI

extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var amount: Float
    @NSManaged public var colorAsHex: String?
    @NSManaged public var commission: Float
    @NSManaged public var identifier: UUID
    @NSManaged public var name: String
    @NSManaged public var userOrder: NSNumber
    @NSManaged public var isTip: Bool
    
    public var amountAsCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    public var commissionAsPercent: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter.string(from: NSNumber(value: commission / 100)) ?? "0.0%"
    }
    
    var uiColor: UIColor? {
        get {
            guard let hex = colorAsHex else { return nil }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                colorAsHex = newColor.toHex
            }
        }
    }
    
    public var color: Color {
        get {
            guard let c = uiColor else { return Color.blue }
            return Color(c)
        }
        set {
            self.uiColor = UIColor(newValue)
        }
    }
    

}

extension Service : Identifiable {

}
