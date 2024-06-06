//
//  Account+CoreDataProperties.swift
//  Comish
//
//  Created by Kevin Green on 10/22/20.
//
//

import Foundation
import CoreData
import UIKit.UIImage
import SwiftUI


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var identifier: UUID
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String
    @NSManaged public var totalCommissionAmount: Float
    @NSManaged public var totalTipAmount: Float
    @NSManaged public var archives: NSSet?
    @NSManaged public var servicePerformed: NSSet?
    
    public var totalComAmountWithTipInCurrency: String  {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: totalComAmountWithTip)) ?? "$?.??"
    }
    
    
    public var totalComAmountWithTip: Float {
        return totalCommissionAmount + totalTipAmount
    }
    
    public var totalCommish: Float {
        var totalCommish: Float = 0.0
        for servicePerf in serviceArray {
            totalCommish += servicePerf.isTip ? servicePerf.amount : servicePerf.amount * servicePerf.percent.asDecimalFromContext()
        }
        return totalCommish
    }
    
    public var totalAmountsFromServicePerfArray: Float {
        var total: Float = 0.0
        for servicePerf in serviceArray {
            total += servicePerf.amount
        }
        return total
    }
    
    public var difference: Float {
        return totalCommissionAmount * averageCommissionRate.asDecimalFromContext()
    }
    
    
    
    public var image: UIImage {
        get {
            guard let data = imageData else { return UIImage(named: "avatar")! }
            guard let uiImage = UIImage(data: data) else { return UIImage(named: "avatar")! }
            return uiImage
        }
        set {
            guard let data = newValue.jpegData(compressionQuality: 1.0) else { return }
            imageData = data
        }
    }
    
    
    public var serviceArray: [ServicePerformed] {
        get {
            let set = servicePerformed as? Set<ServicePerformed> ?? []
            return set.sorted {
                $0.date.kgDateFormatter() < $1.date.kgDateFormatter()
            }
        }
        set {
            servicePerformed = NSSet(array: newValue)
        }
    }
    
    
    public var archivesArray: [Archives] {
        let set = archives as? Set<Archives> ?? []
        return set.sorted {
            $0.dateRange > $1.dateRange
        }
    }

    
    /// The date range of the performed services.
    public var servicePerformedDateRange: DateInterval {
        get {
            let sortedDates = serviceArray.sorted(by: {
                $0.date < $1.date
            })
            
            guard let earliestDate = sortedDates.first?.date else { return DateInterval() }
            guard  let latestDate = sortedDates.last?.date else { return DateInterval() }
            
            let dateInterval = DateInterval(start: earliestDate, end: latestDate)
            return dateInterval
        }
    }
    
    
    /// The commission rates for all currently performed services, averaged, not including servicePerformed's where isTip == True.
    public var averageCommissionRate: Float {
        var addedCommission: Float = 0.0
        if serviceArray.count > 0 {
            for servicePerformed in serviceArray {
                if !servicePerformed.isTip {
                    addedCommission += servicePerformed.percent
                }
            }
            return addedCommission / Float(serviceArray.count)
        }
        return 0
    }
    
    public func averageCommissionsAsPercentage() -> String {
        return String(format: "%.1f", averageCommissionRate)
    }
    
}


// MARK: Generated accessors for servicePerformed
extension Account {

    @objc(addServicePerformedObject:)
    @NSManaged public func addToServicePerformed(_ value: ServicePerformed)

    @objc(removeServicePerformedObject:)
    @NSManaged public func removeFromServicePerformed(_ value: ServicePerformed)

    @objc(addServicePerformed:)
    @NSManaged public func addToServicePerformed(_ values: NSSet)

    @objc(removeServicePerformed:)
    @NSManaged public func removeFromServicePerformed(_ values: NSSet)

}


// MARK: Generated accessors for archives
extension Account {

    @objc(addArchivesObject:)
    @NSManaged public func addToArchives(_ value: Archives)

    @objc(removeArchivesObject:)
    @NSManaged public func removeFromArchives(_ value: Archives)

    @objc(addArchives:)
    @NSManaged public func addToArchives(_ values: NSSet)

    @objc(removeArchives:)
    @NSManaged public func removeFromArchives(_ values: NSSet)

}

extension Account : Identifiable {
    
}

