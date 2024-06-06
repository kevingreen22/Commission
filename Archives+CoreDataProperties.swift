//
//  Archives+CoreDataProperties.swift
//  Comish
//
//  Created by Kevin Green on 10/22/20.
//
//

import Foundation
import CoreData


extension Archives {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Archives> {
        return NSFetchRequest<Archives>(entityName: "Archives")
    }

    @NSManaged public var commissionMade: Float
    @NSManaged public var fromDate: Date
    @NSManaged public var toDate: Date
    @NSManaged public var identifier: UUID
    @NSManaged public var archiveOrgin: Account?
    @NSManaged public var servicePerformed: NSSet
    
    public var serviceArray: [ServicePerformed] {
        let set = servicePerformed as? Set<ServicePerformed> ?? []
        return set.sorted {
            $0.date > $1.date
        }
    }
    
    public var dateRange: DateInterval {
        return DateInterval(start: fromDate, end: toDate)
    }
    
    public var commissionMadeInCurrency: String  {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: commissionMade)) ?? "$?.??"
    }
    
}

// MARK: Generated accessors for servicePerformed
extension Archives {

    @objc(addServicePerformedObject:)
    @NSManaged public func addToServicePerformed(_ value: ServicePerformed)

    @objc(removeServicePerformedObject:)
    @NSManaged public func removeFromServicePerformed(_ value: ServicePerformed)

    @objc(addServicePerformed:)
    @NSManaged public func addToServicePerformed(_ values: NSSet)

    @objc(removeServicePerformed:)
    @NSManaged public func removeFromServicePerformed(_ values: NSSet)

}

extension Archives : Identifiable {

}
