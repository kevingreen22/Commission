//
//  ViewModel.swift
//  Commission
//
//  Created by Kevin Green on 4/23/21.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    @EnvironmentObject var userSettings: UserSettings
    
        
    // ViewModel vars/methods
    @Published var alertItem: AlertItem?
    @Published var activeSheet: ActiveSheet? = nil
    @Published var activeFullCover: ActiveFullCover? = nil
    @Published var currentAccountID: NSManagedObjectID = NSManagedObjectID()
    
    
    
    // MainView vars/methods
    @Published var servs = [Service]() // used for dragging of the service grids
    @Published var dragging: Service? // used for dragging of the service grids
    @Published var isShowPhotoLibrary: Bool = false
    @Published var tipAmount: String? = ""
    @Published var isPresentingAmountAlert: Bool = false
    @Published var showArchiveView = false
    
    func textFieldAlertButtons(items: [AnyObject]?) -> [UIAlertAction] {
        var buttons = [UIAlertAction]()
        let button1 = UIAlertAction(title: "Add Tip", style: .default) { _ in
            print("Add tip tapped")
            
            // prepare & set tip amount for quickTip service object
            guard let tip: Float = Float(self.tipAmount ?? "0") else { return }
            guard let account = PersistenceController.shared.getAccount(for: self.currentAccountID) else { return }
            PersistenceController.shared.addQuick(tip: tip, to: account)
            Haptics.success()
        }
        
        buttons.append(button1)
        return buttons
    }
    
    func delete(service: Service) {
        print("deleting service")
        PersistenceController.shared.delete(service)
        Haptics.success()
    }
    
    func add(perfService service: Service, to account: Account) {
        print("Adding service/quickTip to account-list")
        PersistenceController.shared.add(performed: service, to: account)
        Haptics.success()
    }
    
    
    
    
    
    // PerformedList vars/methods
    @Published var servicesArray = [ServicePerformed]()
    @Published var segmentSelection: Int = 1
    @Published var dateToShow = Date()
    @Published var filterType: FilterType = .all
    
    func delete(servicePerformed: ServicePerformed) {
        print("deleting service performed")
        if servicePerformed.isTip {
            PersistenceController.shared.deleteQuickTipPerformed(servicePerformed)
            servicesArray.removeAll(where: { $0 == servicePerformed })
        } else {
            PersistenceController.shared.delete(servicePerformed)
            servicesArray.removeAll(where: { $0 == servicePerformed })
        }
        Haptics.success()
    }
    
    func createArchive(for account: Account) {
        PersistenceController.shared.createArchiveFor(account)
    }
    
    
    
    // AccountView vars/methods
    @Published var pickedImage: UIImage?
    @Published var accountViewAlertItem: AlertItem?
    @Published var name = ""
    
    func loadImage(for account: Account) -> (() -> Void)? {
        if let  inputImage = pickedImage {
            account.image = inputImage
        }
        return nil
    }
    
    func update(account: Account) {
        print("updating account")
        PersistenceController.shared.update(account, name: name, image: nil)
    }
    
    func resetServices(for account: Account) {
        print("reseting account services")
        PersistenceController.shared.resetServicesFor(account)
        Haptics.success()
    }
    
    func delete(account: Account) {
        print("deleting account")
        PersistenceController.shared.delete(account)
        Haptics.success()
    }
    
    func update(quickTip: Bool) {
        print("updating quicktip")
        PersistenceController.shared.updateQuickTipService(quickTip)
    }
    
    
    // EditServicePerformedInfo vars/methods
    @Published var showEditServicePerformedErrorAlert: AlertItem?
    @Published var servPerfName: String = ""
    @Published var servPerfCommission: String = ""
    @Published var servPerfDate: Date = Date()
    @Published var servPerfAmount: String = ""
    @Published var servPerfColor: Color = .clear
    
    
    // ProfileSetup vars/methods
    @Published var isUnlocked = false
    @Published var accountName = ""
    @Published var namePlaceholderText = StringConstants.setupNamePlaceHolder
    @Published var universalPercent = ""
    @Published var univPercPlaceholderText = StringConstants.setupUnivPercPlaceholder
    @Published var showUniversalTextField = false
    @Published var shouldShowNextButton = false
    @Published var isEditing = false
    
    
    var validateName: Bool {
        guard accountName != "" else { return false }
        return true
    }
    
    func validatePercent(userSettings: UserSettings) -> Bool {
        guard userSettings.isUsingUniversalPercent && universalPercent != "" || userSettings.isUsingUniversalPercent == false else { return false }
        return true
    }
    
    func setupCompleted(userSettings: UserSettings) {
        PersistenceController.shared.updateQuickTipService(userSettings.isUsingQuickTip)
        PersistenceController.shared.createNewAccount(name: accountName, image: pickedImage)
        userSettings.setupComplete = true
    }
    
    
    
    
    
    func getDateDifference() -> String {
        var daysTill: Int = 0
        
        if userSettings.weeklyPayPeriod != "" {
            let today = Date().getCurrentWeekdayAsString
            var current = 0
            
            switch today {
            case "Sunday":
                current = 1
            case "Monday":
                current = 2
            case "Tuesday":
                current = 3
            case "Wednesday":
                current = 4
            case "Thursday":
                current = 5
            case "Friday":
                current = 6
            case "Saturday":
                current = 7
            default:
                break
            }
            
            
            let payday = userSettings.weeklyPayPeriod
            var payPeriod = 0
            
            switch payday {
            case "Sunday":
                payPeriod = 1
            case "Monday":
                payPeriod = 2
            case "Tuesday":
                payPeriod = 3
            case "Wednesday":
                payPeriod = 4
            case "Thursday":
                payPeriod = 5
            case "Friday":
                payPeriod = 6
            case "Saturday":
                payPeriod = 7
            default:
                break
            }
            
            if current <= payPeriod {
                daysTill = payPeriod - current
            } else if current > payPeriod {
                let difference = current - payPeriod
                daysTill = abs(difference - 7)
            }
            
        
        } else if userSettings.bimonthlyPayPeriod1End != "" {
            guard let payPeriod1End = Int(userSettings.bimonthlyPayPeriod1End) else { return "" }
            guard let payPeriod2End = Int(userSettings.bimonthlyPayPeriod2End) else { return "" }
            guard let today = Int(Date().getCurrentDayNumAsString) else { return "" }
            if payPeriod1End >= today {
                daysTill = payPeriod1End - today
            } else if payPeriod2End >= today {
                daysTill = payPeriod2End - today
            } else {
                daysTill = daysInCurrentMonth() - today + payPeriod1End
            }
            
        }
        
        return String(daysTill)
    }

    fileprivate func daysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let date = Date()

        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)!

        // Compute difference in days:
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        print(days)
        
        return days
    }
    
    
    
}
