//
//  CoreDataFunctions.swift
//  Comish
//
//  Created by Kevin Green on 10/5/20.
//

import CoreData
import SwiftUI
   
class CoreDataFunctions {
    @EnvironmentObject var userSettings: UserSettings
    let persistenceController = PersistenceController.shared
    
//    
//    // MARK: Account Methods
//    
//    /// Creates a new Account Object in CoreData.
//    /// - Parameters:
//    ///   - name: The string representing the name value of an Account Object.
//    ///   - image: The UIImage representing the image of an Account object.
//    ///   - context: The Persistent Store context object.
//    class func CreateNewAccount(name: String, image: UIImage?, with context: NSManagedObjectContext) {
//        withAnimation {
//            let newAccount = Comish.Account(context: context)
//            newAccount.name = name
//            newAccount.totalAmount = 0
//            newAccount.identifier = UUID()
//            if let image = image {
//                if let imageData = image.jpegData(compressionQuality: 1.0) {
//                    newAccount.image = imageData
//                }
//            }
//            
//            persistenceController.save()
//        }
//    }
//    
//    
//    /// Updates an Account Object in CoreData.
//    /// - Parameters:
//    ///   - account: The CoreData Account object to update.
//    ///   - name: The string representing the name value of an Account object.
//    ///   - image: The UIImage representing the image of an Account object.
//    ///   - context: The Persistent Store context object.
//    class func Update(_ account: Account, name: String, image: UIImage?, with context: NSManagedObjectContext) {
//        withAnimation {
//            account.name = name
//            if let image = image {
//                if let imageData = image.jpegData(compressionQuality: 1.0) {
//                    account.image = imageData
//                }
//            }
//            
//            PersistenceController.save(with: context)
//        }
//    }
//    
//    
//    /// Retrieves a CoreData Account object via the UUID.
//    /// - Parameters:
//    ///   - id: The UUID to look up.
//    ///   - accounts: The Fetched Results of Accounts in CoreData.
//    ///   - context: The Persistent Store context object.
//    /// - Returns: The Account object with the matching UUID, or nil if it doesn't exist.
//    class func getAccount(for id: NSManagedObjectID, context: NSManagedObjectContext) -> Account? {        
//        return context.object(with: id) as? Account
//    }
//    
//    
//    /// Resets the ServicesPerformed entity set for the given Account.
//    /// - Parameters:
//    ///   - account: The account to perform the reset on.
//    ///   - context: The Persistent Store context object.
//    class func resetServicesFor(_ account: Account, context: NSManagedObjectContext) {
//         // Delete each PerformedService
//        for servicePerformed in account.serviceArray {
//            context.delete(servicePerformed)
//        }
//        account.totalAmount = 0
//        PersistenceController.save(with: context)
//    }
//    
//    
//    /// Deletes an Account object from CoreData. This removes ALL information saved within the Account.
//    /// - Parameters:
//    ///   - account: The Account object to delete.
//    ///   - context: The Persistent Store context object.
//    class func delete(_ account: Account, context: NSManagedObjectContext) {
//        context.delete(account)
//        PersistenceController.save(with: context)
//    }
//    
//    
//    
//    
//    
//    
//    
//    // MARK: Service Methods
//    
//    /// Creates a new Service Object in CoreData.
//    /// - Parameters:
//    ///   - newService: The Service object thats being created.
//    ///   - name: The string representing the name value of an Account Object.
//    ///   - amount: The number representing the amount the service is.
//    ///   - commission: The number representing the commission gained from this service.
//    ///   - context: The Persistent Store context object.
//    class func CreateNewService(name: String, amount: Float, commission: Float, color: UIColor, with context: NSManagedObjectContext) {
//        withAnimation {
//            let newService = Comish.Service(context: context)
//            newService.name = name
//            newService.amount = amount
//            newService.commission = commission
//            newService.identifier = UUID()
//            newService.color = color
//            
//            PersistenceController.save(with: context)
//        }
//    }
//    
//    
//    /// Updates a Service Object in CoreData.
//    /// - Parameters:
//    ///   - service: The CoreData Service object to update.
//    ///   - name: The string representing the name value of an Service Object.
//    ///   - amount: The number representing the amount the service is.
//    ///   - commission: The number representing the commission gained from this service.
//    ///   - context: The Persistent Store context object.
//    class func Update(_ service: Service, name: String, amount: Float, commission: Float, color: UIColor, with context: NSManagedObjectContext) {
//        withAnimation {
//            service.name = name
//            service.amount = amount
//            service.commission = commission
//            service.color = color
//            
//            PersistenceController.save(with: context)
//        }
//    }
//    
//    
//    /// Retrieves a CoreData Account object via the UUID.
//    /// - Parameters:
//    ///   - id: The UUID to look up.
//    ///   - accounts: The Fetched Results of Accounts in CoreData.
//    ///   - context: The Persistent Store context object.
//    /// - Returns: The Account object with the matching UUID, or nil if it doesn't exist.
//    class func getService(for id: UUID, from services: FetchedResults<Service>, context: NSManagedObjectContext) -> Service? {
//        for _service in services {
//            if _service.identifier == id {
//                return _service
//            }
//        }
//        return nil
//    }
//    
//    
//    /// Deletes a Service object from CoreData. This removes ALL information saved within the Service.
//    /// - Parameters:
//    ///   - service: The CoreData Service object to update.
//    ///   - context: The Persistent Store context object.
//    class func delete(_ service: Service, context: NSManagedObjectContext) {
//        context.delete(service)
//        PersistenceController.save(with: context)
//    }
//    
//    
//    
//    
//    
//    
//    
//    // MARK: Performed Services Methods
//    
//    /// Adds a ServicePerformed object to an Account object that mimics a Service object.
//    /// - Parameters:
//    ///   - service: The Service object to mimic.
//    ///   - accounts: The Account object to add to.
//    ///   - id: The UUID of the Account object.
//    ///   - context: The Persistent Store context object.
//    class func add(performed service: Service, toAccountWithID id: NSManagedObjectID, with context: NSManagedObjectContext) {
//        guard let account = Self.getAccount(for: id, context: context) else { return }
//        let servicePerformed = ServicePerformed(context: context)
//        servicePerformed.name = service.name
//        servicePerformed.amount = service.amount
//        servicePerformed.commission = service.commission
//        servicePerformed.date = Date()
//        servicePerformed.identifier = UUID()
//        servicePerformed.color = service.color
//        
//        account.totalAmount += calculate(commission: service.commission, from: service.amount)
//        servicePerformed.origin = account
//        
//        print(servicePerformed)
//        
//        PersistenceController.save(with: context)
//    }
//    
//    
//    /// Updates a ServicePerfomed object within an Account object.
//    /// - Parameters:
//    ///   - servicePerformed: The ServicePerfomed to update.
//    ///   - account: The Account object containing the ServicePerformed object to update.
//    ///   - name: The string representing the name value of an ServicePerformed Object.
//    ///   - amount: The number representing the amount the ServicePerformed is.
//    ///   - commission: The number representing the commission gained from this ServicePerformed.
//    ///   - date: The date the ServicePerformed was done.
//    ///   - context: The Persistent Store context object.
//    class func update(servicePerformed: ServicePerformed, for account: Account, name: String, amount: Float, commission: Float, date: Date, color: UIColor, with context: NSManagedObjectContext) {
//        servicePerformed.name = name
//        servicePerformed.amount = amount
//        servicePerformed.commission = commission
//        servicePerformed.date = date
//        servicePerformed.color = color
//        
//        recalculateTotalAmountFor(account: account)
//        
//        PersistenceController.save(with: context)
//    }
//    
//    
//    /// Deletes PerformedServices objects from an Account object with the IndexSet passed in.
//    /// - Parameters:
//    ///   - offsets: The IndexSet to use for deleting PerformedServices objects.
//    ///   - account: The Account object from which to delete PerformedServices objects.
//    ///   - context: The Persistent Store context object.
//    class func deletePerformedService(offsets: IndexSet, from account: Account, context: NSManagedObjectContext) {
//        withAnimation {
//            offsets.forEach { index in
//                let performedService = account.serviceArray[index]
//                account.totalAmount -= calculate(commission: performedService.commission, from: performedService.amount)
//                context.delete(performedService)
//             }
//            
//            PersistenceController.save(with: context)
//        }
//    }
//    
//    
//    
//    
//    
//    // MARK: Archives Methods
//    
//    class func createArchive(for account: Account, context: NSManagedObjectContext) {
//        let newArchive = Comish.Archives(context: context)
//        var dateRange = [Date]()
//        var commissionMade: Float = 0
//        
//        // take each servicePerformed and create a ServicePerformedArchive object
//        for service in account.serviceArray {
//            // save each service to Archives.servicesPerformed set
//            let servicePerformed = ServicePerformed(context: context)
//            servicePerformed.name = service.name
//            servicePerformed.amount = service.amount
//            servicePerformed.commission = service.commission
//            servicePerformed.date = service.date
//            servicePerformed.identifier = UUID()
//            servicePerformed.color = service.color
//            
//            newArchive.addToServicePerformed(servicePerformed)
//            
//            dateRange.append(service.date)
//            commissionMade += calculate(commission: service.commission, from: service.amount)
//        }
//        
//        // create a dateRange from the servicesPerformed being moved and save that to Archives.dateRange
//        guard let dateLow = dateRange.min()?.MyDateFormatter() else { return }
//        guard let dateHigh = dateRange.max()?.MyDateFormatter() else { return }
//        newArchive.dateRange = dateLow + " - " + dateHigh
//        
//        // adds the commission made, creates a UUID and sets the archiveOrigin
//        newArchive.commissionMade = commissionMade
//        newArchive.identifier = UUID()
//        newArchive.archiveOrgin = account
//        
//        // Adds the archives to the account
//        account.addToArchives(newArchive)
//                
//        PersistenceController.save(with: context)
//        
//        
//        self.resetServicesFor(account, context: context)
//    }
//    
//    
//    /// Deletes Archives objects from an Account object with the IndexSet passed in.
//    /// - Parameters:
//    ///   - offsets: The IndexSet to use for deleting PerformedServices objects.
//    ///   - account: The Account object from which to delete PerformedServices objects.
//    ///   - context: The Persistent Store context object.
//    class func deleteArchives(offsets: IndexSet, from account: Account, context: NSManagedObjectContext) {
//        withAnimation {
//            offsets.forEach { index in
//                let archive = account.archivesArray[index]
//                context.delete(archive)
//             }
//            
//            PersistenceController.save(with: context)
//        }
//    }
//    
//    
//    
//    
//    
//    // MARK: Private Methods
//    
////    /// Saves the changes in the CoreData context.
////    /// - Parameter context: The Persistent Store context object.
////    fileprivate static func Save(with context: NSManagedObjectContext) {
////        do {
////            if context.hasChanges {
////                try context.save()
////                print("CoreData context saved!")
////            }
////        } catch {
////            // Replace this implementation with code to handle the error appropriately.
////            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
////            let nsError = error as NSError
////            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
////        }
////    }
//    
//    
//    /// Calculates an amount of commission earned.
//    /// - Parameters:
//    ///   - commission: The commission as a float.
//    ///   - amount: The amount as a float.
//    /// - Returns: A string representation of the total amount of commission in dollars.
//    fileprivate static func calculate(commission: Float, from amount: Float) -> Float {
//        var commissionedAmount: Float = 0.0
//        let commissionDecimal = commission / 100
//        commissionedAmount = amount * commissionDecimal
//
//        return commissionedAmount
//    }
//    
//    
//    fileprivate static func recalculateTotalAmountFor(account: Account) {
//        // recalculate the account totalAmount
//        account.totalAmount = 0
//        for servPerf in account.serviceArray {
//            account.totalAmount += calculate(commission: servPerf.commission, from: servPerf.amount)
//        }
//    }
//    
//    
//    
}
