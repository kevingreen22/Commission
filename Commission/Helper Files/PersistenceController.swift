//
//  PersistenceController.swift
//  Comish
//
//  Created by Kevin Green on 10/2/20.
//

import CoreData
import SwiftUI

struct PersistenceController {
//    @EnvironmentObject var vm: ViewModel

    
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    
    // Storage for Core Data
    let container: NSPersistentContainer
    
    
    // Initialization
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Comish")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    
    /// Saves the changes in the CoreData context.
    /// - Parameters:
    ///   - forDeletion: A boolean indication if the save is coming from a delete function.
    func save(forDeletion: Bool) {
        let context = container.viewContext
        do {
            if context.hasChanges {
                try context.save()
                print("CoreData context saved!")
            }
        } catch {
            if forDeletion { context.rollback() }
            let nsError = error as NSError
            print(nsError)
//            vm.alertItem = AlertItem(title: Text("Error"), message: Text(displayValidationError(anError: nsError)), dismissButton: .default(Text("Ok")))
             fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    fileprivate func displayValidationError(anError: NSError?) -> String {
        if anError != nil && anError!.domain.compare("NSCocoaErrorDomain") == .orderedSame {
            var messages: String = "Reason(s):\n"
            var errors = [AnyObject]()
            if (anError!.code == NSValidationMultipleErrorsError) {
                errors = anError!.userInfo[NSDetailedErrorsKey] as! [AnyObject]
            } else {
                errors = [AnyObject]()
                errors.append(anError!)
            }
            if (errors.count > 0) {
                for error in errors {
                    if (error as? NSError)!.userInfo.keys.contains("conflictList") {
                        messages =  messages.appending("Generic merge conflict. see details : \(error)")
                    } else {
                        let entityName = "\(String(describing: ((error as? NSError)!.userInfo["NSValidationErrorObject"] as! NSManagedObject).entity.name))"
                        let attributeName = "\(String(describing: (error as? NSError)!.userInfo["NSValidationErrorKey"]))"
                        var msg = ""
                        switch (error.code) {
                        case NSPersistentStoreOpenError:
                            msg = String(format: "An error occurred while attempting to open a persistent store: '%@'.", attributeName)
                        case NSPersistentStoreSaveError:
                            msg = String(format: "Persistent store '%@' returned an error for a save operation.", attributeName)
                        case NSPersistentStoreTimeoutError:
                            msg = String(format: "Failed to connect to a persistent store '%@' within the time specified.", attributeName)
                        case NSPersistentStoreOperationError:
                            msg = String(format: "Persistent store '%@' operation failed.", attributeName)
                        case NSPersistentStoreInvalidTypeError:
                            msg = String(format: "Unknown persistent store type/format/version: '%@'.", attributeName)
                        case NSPersistentStoreTypeMismatchError:
                            msg = String(format: "Store '%@' accessed that does not match the specified type.", attributeName)
                        case NSPersistentStoreSaveConflictsError:
                            msg = String(format: "Unresolved merge conflict '%@' was encountered during a save.", attributeName)
                        case NSPersistentStoreIncompleteSaveError:
                            msg = String(format: "One or more of the stores '%@' returned an error during a save operations.", attributeName)
                        case NSPersistentStoreCoordinatorLockingError:
                            msg = String(format: "Inability to acquire a lock in a persistent store: '%@'.", attributeName)
                        case NSPersistentStoreIncompatibleSchemaError:
                            msg = String(format: "Persistent store '%@' returned an error for a save operation.", attributeName)
                        case NSPersistentStoreUnsupportedRequestTypeError:
                            msg = String(format: "NSPersistentStore subclass was passed a request '%@' that it did not understand.", attributeName)
                            
                        
                        case NSManagedObjectValidationError:
                            msg = "Generic validation error."
                        case NSManagedObjectConstraintValidationError:
                            msg = String(format: "The object '%@' can not be validated.", attributeName)
                        case NSManagedObjectMergeError, NSManagedObjectConstraintMergeError:
                            msg = String(format: "The object '%@' is unable to complete merging.", attributeName)
                        case NSManagedObjectContextLockingError:
                            msg = String(format: "Managed object context '%@', unable to acquire a lock.", attributeName)
                        case NSManagedObjectExternalRelationshipError:
                            msg = String(format: "The object '%@' being saved has a relationship with another store.", attributeName)
                            
                            
                        case NSManagedObjectReferentialIntegrityError:
                            msg = String(format: "The object '%@' does not exist.", attributeName)
                        case NSValidationMissingMandatoryPropertyError:
                            msg = String(format:"The attribute '%@' can not be empty.", attributeName)
                        case NSValidationRelationshipLacksMinimumCountError:
                            msg = String(format:"The relationship '%@' does not have enough entries.", attributeName)
                        case NSValidationRelationshipExceedsMaximumCountError:
                            msg = String(format:"The relationship '%@' has too many entries.", attributeName)
                        case NSValidationRelationshipDeniedDeleteError:
                            msg = String(format:"To delete, the relationship '%@' must be empty.", attributeName)
                        case NSValidationNumberTooLargeError:
                            msg = String(format:"The number of the attribute '%@' is too large.", attributeName)
                        case NSValidationNumberTooSmallError:
                            msg = String(format:"The number of the attribute '%@' is too small.", attributeName)
                        case NSValidationDateTooLateError:
                            msg = String(format:"The date of the attribute '%@' is too late.", attributeName)
                        case NSValidationDateTooSoonError:
                            msg = String(format:"The date of the attribute '%@' is too soon.", attributeName)
                        case NSValidationInvalidDateError:
                            msg = String(format:"The date of the attribute '%@' is invalid.", attributeName)
                        case NSValidationStringTooLongError:
                            msg = String(format:"The text of the attribute '%@' is too long.", attributeName)
                        case NSValidationStringTooShortError:
                            msg = String(format:"The text of the attribute '%@' is too short.", attributeName)
                        case NSValidationStringPatternMatchingError:
                            msg = String(format:"The text of the attribute '%@' does not match the required pattern.", attributeName)
                        default:
                            msg = String(format:"Unknown error (code %i).", error.code) as String
                        }

                        messages = messages.appending("\(entityName).\(attributeName):\(msg)\n")
                    }
                }
            }
            print(messages)
            return messages
        }
        return "no error"
    }
    
    
    
    
    
    
    
    
    
    
// MARK: Account Methods
    
    /// Creates a new Account Object in CoreData.
    /// - Parameters:
    ///   - name: The string representing the name value of an Account Object.
    ///   - image: The UIImage representing the image of an Account object.
    func createNewAccount(name: String, image: UIImage?) {
        withAnimation {
            let newAccount = Commission.Account(context: container.viewContext)
            newAccount.name = name
            newAccount.totalCommissionAmount = 0
            newAccount.identifier = UUID()
            if let image = image {
                newAccount.image = image
            }
            
            print("created/added account")
            
            save(forDeletion: false)
        }
    }
    
    
    /// Updates an Account Object in CoreData.
    /// - Parameters:
    ///   - account: The CoreData Account object to update.
    ///   - name: The string representing the name value of an Account object.
    ///   - image: The UIImage representing the image of an Account object.
    func update(_ account: Account, name: String, image: UIImage?) {
        withAnimation {
            account.name = name
            if let image = image {
                account.image = image
            }
            
            print("updated account info")
            
            save(forDeletion: false)
        }
    }
    
    
    /// Retrieves a CoreData Account object via the UUID.
    /// - Parameters:
    ///   - id: The NSManaged object ID to look up.
    /// - Returns: The Account object with the matching UUID, or nil if it doesn't exist.
    func getAccount(for id: NSManagedObjectID) -> Account? {
        return container.viewContext.object(with: id) as? Account
    }
    
    
    
    /// Resets the ServicesPerformed entity set for the given Account.
    /// - Parameters:
    ///   - account: The account to perform the reset on.
    func resetServicesFor(_ account: Account) {
         // Delete each PerformedService
        for servicePerformed in account.serviceArray {
            account.removeFromServicePerformed(servicePerformed)
        }
        account.totalCommissionAmount = 0
        account.totalTipAmount = 0
        
        print("services reset for account")
        
        save(forDeletion: true)
    }
    
    
    /// Deletes an Account object from CoreData. This removes ALL information saved within the Account.
    /// - Parameters:
    ///   - account: The Account object to delete.
    func delete(_ account: Account) {
        container.viewContext.delete(account)
        print("deleted Account")
        save(forDeletion: true)
    }
    
    
    
    
    
    
    
// MARK: Service Methods
    
    /// Creates a new Service Object in CoreData.
    /// - Parameters:
    ///   - name: The string representing the name value of an Account Object.
    ///   - amount: The number representing the amount the service is.
    ///   - commission: The number representing the commission gained from this service.
    ///   - color: The background color of the service view. Default is blue.
    func createNewService(name: String, amount: Float, commission: Float, color: UIColor = .blue) {
        withAnimation {
            let newService = Commission.Service(context: container.viewContext)
            newService.name = name
            newService.amount = amount
            newService.commission = commission
            newService.uiColor = color
            newService.isTip = false
            newService.identifier = UUID()
            
            print("created/added Service")
            
            save(forDeletion: false)
        }
    }
    
    
    /// Updates a Service Object in CoreData.
    /// - Parameters:
    ///   - service: The CoreData Service object to update.
    ///   - name: The string representing the name value of an Service Object.
    ///   - amount: The number representing the amount the service is.
    ///   - commission: The number representing the commission gained from this service.
    ///   - color: The background color of the service view.
    func update(_ service: Service, name: String, amount: Float, commission: Float, color: Color) {
        withAnimation {
            service.name = name
            service.amount = amount
            service.commission = commission
            service.color = color
            
            print("updated Service")
            
            save(forDeletion: false)
        }
    }
    
    
    /// Retrieves a CoreData Service object via the UUID.
    /// - Parameters:
    ///   - id: The UUID to look up.
    ///   - services: The Fetched Results of Services in CoreData.
    /// - Returns: The Service object with the matching UUID, or nil if it doesn't exist.
    func getService(for id: NSManagedObjectID) -> Service? {
        guard let service = container.viewContext.registeredObject(for: id) as? Service else { return nil }
        return service
    }
    
    
    /// Deletes a Service object from CoreData. This removes ALL information saved within the Service.
    /// - Parameters:
    ///   - service: The CoreData Service object to update.
    func delete(_ service: Service) {
        container.viewContext.delete(service)
        print("deleted Service")
        save(forDeletion: true)
    }
    
    
    
    
    
    
    
// MARK: Quick Tip Service
    
    /// Returns the quickTipService object or nil if it does not exist.
    var quickTipService: Service? {
        let set = container.viewContext.registeredObjects
        for obj in set {
            if let obj = obj as? Service, obj.isTip {
                return obj
            }
        }
        return nil
    }
    
    
    /// Updates the quickTipService. i.e. creation or removing from Core data context.
    func updateQuickTipService(_ isUsingQuickTip: Bool) {
        if isUsingQuickTip {
            if PersistenceController.shared.quickTipService == nil {
                createQuickTip()
            }
        } else {
            removeQuickTipService()
        }
    }
    
    
    /// Creates ONE service object as a tip and sets it's "isTip" variable to true.
    fileprivate func createQuickTip() {
        let container = PersistenceController.shared.container
        let quickTip = Commission.Service(context: container.viewContext)
        quickTip.name = ""
        quickTip.amount = 0.0
        quickTip.commission = 100.0
        quickTip.uiColor = .green
        quickTip.isTip = true
        quickTip.identifier = UUID()
        save(forDeletion: false)
    }
    
    
    /// Removes the QuickTipService from the container.
    fileprivate func removeQuickTipService() {
        guard let qt = quickTipService else { return }
        container.viewContext.delete(qt)
        print("deleted quicktip service")
        save(forDeletion: true)
    }
    
    
    /// Sets the amount variable to the passed in tip amount for the Tip Service Object.
    /// - Parameters:
    ///   - amount: The amount to set.
    ///   - account: The account to set the tipAmount and ServicePerformed to.
    func addQuick(tip amount: Float, to account: Account) {
        guard let quickTipSevice = quickTipService else { return }
        quickTipSevice.amount = amount
        
        // creates
        let quickTip = Commission.ServicePerformed(context: container.viewContext)
        quickTip.name = "Tip"
        quickTip.amount = amount
        quickTip.date = Date()
        quickTip.color = .green
        quickTip.percent = 100.0
        quickTip.uiColor = .green
        quickTip.isTip = true
        quickTip.identifier = UUID()
        quickTip.origin = account
        
        // add quickTip performedService to account
        account.addToServicePerformed(quickTip)
        
        // add tip amount to Account
        account.totalTipAmount += amount
        
        print("added a tip to account")
        
        save(forDeletion: false)
    }
    
    
    /// Deletes QuickTip performedService objects from an Account object.
    /// - Parameters:
    ///   - quickTip: The performedService object to delete from the account.
    func deleteQuickTipPerformed(_ quickTip: ServicePerformed) {
        withAnimation {
            guard let account = quickTip.origin else { return }
            account.totalTipAmount -= quickTip.amount
            account.removeFromServicePerformed(quickTip)

            print("Deleted QuickTip ServicePerformed")
            
            save(forDeletion: true)
        }
    }
    
    
    
    
    
    
    
    
    
// MARK: Performed Services Methods
    
    /// Adds a ServicePerformed that mimics a Service, to an Account.
    /// - Parameters:
    ///   - service: The Service object to mimic.
    ///   - id: The UUID of the Account object.
    func add(performed service: Service, toAccountWithID id: NSManagedObjectID) {
        guard let account = getAccount(for: id) else { return }
        let servicePerformed = Commission.ServicePerformed(context: container.viewContext)
        servicePerformed.name = service.name
        servicePerformed.amount = service.amount
        servicePerformed.percent = service.commission
        servicePerformed.date = Date()
        servicePerformed.identifier = UUID()
        servicePerformed.color = service.color
        
        account.totalCommissionAmount += calculate(commission: service.commission, from: service.amount)
        servicePerformed.origin = account
        
        print("added servicePerformed to account")
        
        save(forDeletion: false)
    }
    
    /// Adds a ServicePerformed object to an Account object that mimics a Service object.
    /// - Parameters:
    ///   - service: The Service object to mimic.
    ///   - account: The Account object to add to.
    func add(performed service: Service, to account: Account) {
        let servicePerformed = Commission.ServicePerformed(context: container.viewContext)
        servicePerformed.name = service.name
        servicePerformed.amount = service.amount
        servicePerformed.percent = service.commission
        servicePerformed.date = Date()
        servicePerformed.identifier = UUID()
        servicePerformed.color = service.color
        
        account.totalCommissionAmount += calculate(commission: service.commission, from: service.amount)
        servicePerformed.origin = account
        
        account.addToServicePerformed(servicePerformed)
        
        print("added servicePerformed to account")
        
        save(forDeletion: false)
    }
    
    
    /// Updates a ServicePerfomed object within an Account object.
    /// - Parameters:
    ///   - servicePerformed: The ServicePerfomed to update.
    ///   - name: The string representing the name value of an ServicePerformed Object.
    ///   - amount: The number representing the amount the ServicePerformed is.
    ///   - commission: The number representing the commission gained from this ServicePerformed.
    ///   - date: The date the ServicePerformed was done.
    ///   - color: The background color of the service view.
    func update(servicePerformed: ServicePerformed, name: String, amount: Float, commission: Float, date: Date, color: Color) {
        guard let account = servicePerformed.origin else { return }
        servicePerformed.name = name
        servicePerformed.amount = amount
        servicePerformed.percent = commission
        servicePerformed.date = date
        servicePerformed.color = color
        
        recalculateTotalAmountFor(account: account)
        
        print("updated servicePerformed")
        
        save(forDeletion: false)
    }
    
    
    /// Deletes PerformedServices objects from an Account object.
    /// - Parameters:
    ///   - performedService: The performedService object to delete from the account.
    func delete(_ performedService: ServicePerformed) {
        withAnimation {
            guard let account = performedService.origin else { return }
            account.totalCommissionAmount -= calculate(commission: performedService.percent, from: performedService.amount)
            account.removeFromServicePerformed(performedService)

            print("Deleted performedService")
            
            save(forDeletion: true)
        }
    }
    
    
    /// Deletes PerformedService(s) objects from an Account object with the IndexSet passed in.
    /// - Parameters:
    ///   - offsets: The IndexSet to use for deleting PerformedService(s) objects.
    ///   - account: The Account object from which to delete the PerformedService objects.
    func deletePerformedService(at offsets: IndexSet, from account: Account) {
        withAnimation {
            offsets.forEach { index in
                let performedService = account.serviceArray[index]
                account.totalCommissionAmount -= calculate(commission: performedService.percent, from: performedService.amount)
                account.removeFromServicePerformed(performedService)
             }
            
            print("deleted performedService(s) from account via offsets")

            save(forDeletion: true)
        }
    }
    
    
    
    

    
    
// MARK: Archives Methods
    
    /// Creates an Archive object for the specified Account object.
    /// - Parameter account: The Account object to save the Archive to.
    func createArchiveFor(_ account: Account) {
        let newArchive = Commission.Archives(context: container.viewContext)
        var dates = [Date]()
        var commissionMade: Float = 0
        
        // take each servicePerformed and create a ServicePerformedArchive object
        for service in account.serviceArray {
            // save each service to Archives.servicesPerformed set
            let servicePerformed = Commission.ServicePerformed(context: container.viewContext)
            servicePerformed.name = service.name
            servicePerformed.amount = service.amount
            servicePerformed.percent = service.percent
            servicePerformed.date = service.date
            servicePerformed.identifier = UUID()
            servicePerformed.color = service.color
            servicePerformed.origin = account
            
            newArchive.addToServicePerformed(servicePerformed)
            
            dates.append(service.date)
            commissionMade += calculate(commission: service.percent, from: service.amount)
        }
        
        // saves the earliest and most recent dates to "fromDate" & "toDate" respectively
        guard let dateLow = dates.min() else { return }
        guard let dateHigh = dates.max() else { return }
        newArchive.fromDate = dateLow
        newArchive.toDate = dateHigh
        
        // adds the commission made, creates a UUID and sets the archiveOrigin
        newArchive.commissionMade = commissionMade
        newArchive.identifier = UUID()
        newArchive.archiveOrgin = account
        
        // Adds the archives to the account
        account.addToArchives(newArchive)
        
        print("created/added archive to account")
                
        save(forDeletion: false)
        
        resetServicesFor(account)
    }
    
    
    /// Deletes an Archives objects from an Account object.
    /// - Parameters:
    ///   - archive: An Archives object.
    ///   - account: The Account object from which to delete PerformedServices objects.
    func delete(_ archive: Archives, from account: Account) {
        withAnimation {
            account.removeFromArchives(archive)
        }
        
        print("deleted archive from account")
        
        save(forDeletion: true)
    }
    
    
    /// Deletes Archives objects from an Account object with the IndexSet passed in.
    /// - Parameters:
    ///   - offsets: The IndexSet to use for deleting PerformedServices objects.
    ///   - account: The Account object from which to delete PerformedServices objects.
    func deleteArchives(offsets: IndexSet, from account: Account) {
        withAnimation {
            offsets.forEach { index in
                let archive = account.archivesArray[index]
                account.removeFromArchives(archive)
             }
            
            print("deleted archive(s) from account via offsets")
            
            save(forDeletion: true)
        }
    }
    
    
    
    
    
// MARK: Private Methods
    
    /// Calculates an amount of commission earned.
    /// - Parameters:
    ///   - commission: The commission as a float.
    ///   - amount: The amount as a float.
    /// - Returns: A string representation of the total amount of commission in dollars.
    fileprivate func calculate(commission: Float, from amount: Float) -> Float {
        var commissionedAmount: Float = 0.0
        let commissionDecimal = commission / 100
        commissionedAmount = amount * commissionDecimal

        return commissionedAmount
    }
    
    
    fileprivate func recalculateTotalAmountFor(account: Account) {
        // recalculate the account totalCommissionAmount
        account.totalCommissionAmount = 0
        for servPerf in account.serviceArray {
            if !servPerf.isTip {
                account.totalCommissionAmount += calculate(commission: servPerf.percent, from: servPerf.amount)
            }
        }
    }
    
    
    fileprivate func calculateTotalFor(_ account: Account, with service: Service) -> Float {
        var commissionedAmount: Float = 0.0
        let amount = service.amount
        let totalCommissionAmount = account.totalCommissionAmount
        let commission = service.commission
        
        let totalServiceAmount = amount + totalCommissionAmount
        commissionedAmount = totalServiceAmount * commission.asDecimalFromContext()

        return commissionedAmount
    }
    
    
    
    
    
    
    
    /// A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let pc = PersistenceController(inMemory: true)
        let vc = pc.container.viewContext
        
        // Creates one Account
        let account = Commission.Account(context: vc)
        account.name = "Kevin"
        account.totalCommissionAmount = 500
        account.totalTipAmount = 10
        account.image = UIImage(named: "me")!
        account.identifier = UUID()
        
        // creates 3 Services
        let newService1 = Commission.Service(context: vc)
        newService1.name = "Cut"
        newService1.amount = 105
        newService1.commission = 50
        newService1.color = .blue
        newService1.identifier = UUID()
        newService1.isTip = false
        newService1.userOrder = 1
        
        let newService2 = Commission.Service(context: vc)
        newService2.name = "Tint"
        newService2.amount = 95
        newService2.commission = 50
        newService1.color = .yellow
        newService2.identifier = UUID()
        newService2.isTip = false
        newService2.userOrder = 2
        
        let newService3 = Commission.Service(context: vc)
        newService3.name = "Color"
        newService3.amount = 300
        newService3.commission = 50
        newService1.color = .red
        newService3.identifier = UUID()
        newService3.isTip = false
        newService3.userOrder = 3
        
        // Creates a quickTip service
        let quicktip = Commission.Service(context: vc)
        quicktip.name = ""
        quicktip.amount = 0.0
        quicktip.commission = 100.0
        quicktip.uiColor = .green
        quicktip.isTip = true
        quicktip.identifier = UUID()
        quicktip.userOrder = 4
        
        
        // adds 3 PerformedServices to the account
        let servicePerformed1 = Commission.ServicePerformed(context: vc)
        servicePerformed1.name = newService1.name
        servicePerformed1.amount = newService1.amount
        servicePerformed1.percent = newService1.commission
        servicePerformed1.date = Date()
        servicePerformed1.identifier = UUID()
        servicePerformed1.isTip = false
        account.totalCommissionAmount = PersistenceController.shared.calculateTotalFor(account, with: newService1)
//        servicePerformed1.origin = account
        account.addToServicePerformed(servicePerformed1)
        
        let servicePerformed2 = Commission.ServicePerformed(context: vc)
        servicePerformed2.name = newService2.name
        servicePerformed2.amount = newService2.amount
        servicePerformed2.percent = newService2.commission
        servicePerformed2.date = Date()
        servicePerformed2.identifier = UUID()
        servicePerformed2.isTip = false
        account.totalCommissionAmount = PersistenceController.shared.calculateTotalFor(account, with: newService2)
//        servicePerformed2.origin = account
        account.addToServicePerformed(servicePerformed2)
        
        let servicePerformed3 = Commission.ServicePerformed(context: vc)
        servicePerformed3.name = newService3.name
        servicePerformed3.amount = newService3.amount
        servicePerformed3.percent = newService3.commission
        servicePerformed3.date = Date()
        servicePerformed3.identifier = UUID()
        servicePerformed3.isTip = false
        account.totalCommissionAmount = PersistenceController.shared.calculateTotalFor(account, with: newService3)
//        servicePerformed3.origin = account
        account.addToServicePerformed(servicePerformed3)
        
//        let archive1 = Commission.Archives(context: vc)
////        archive1.archiveOrgin = account
//        archive1.fromDate = Date()
//        archive1.toDate = Date()
//        archive1.identifier = UUID()
//        let set = NSSet(arrayLiteral: [servicePerformed1, servicePerformed2, servicePerformed3])
//        archive1.addToServicePerformed(set)
//        archive1.commissionMade = 300.0
//        account.addToArchives(archive1)
        
        
        do {
            try vc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return pc
    }()
    
    
    
}

