//
//  UserSettings.swift
//  Comish
//
//  Created by Kevin Green on 10/14/20.
//

import Foundation
import Combine
import CoreData

struct UDKeys {
    static let isFirstAppLaunch = "isFirstAppLaunch"
    static let setupComplete = "setupComplete"
    static let passcode = "passcode"
    static let isCreatingPasscode = "isCreatingPasscode"
    static let useFaceID = "useFaceID"
    static let isUsingUniversalPercent = "isUsingUniversalPercent"
    static let universalPercent = "universalPercent"
    static let isUsingQuickTip = "isUsingQuickTip"
    static let isUsingPayPeriods = "isUsingPayPeriods"
    static let switcherSelection = "switcherSelection"
    static let weeklyPayPeriod = "weeklyPayPeriod"
    static let bimonthlyPayPeriod1Start = "bimonthlyPayPeriod1Start"
    static let bimonthlyPayPeriod1End = "bimonthlyPayPeriod1End"
    static let bimonthlyPayPeriod2Start = "bimonthlyPayPeriod2Start"
    static let bimonthlyPayPeriod2End = "bimonthlyPayPeriod2End"
}


class UserSettings: ObservableObject, Equatable {
    static func == (lhs: UserSettings, rhs: UserSettings) -> Bool {
        return
            lhs.isFirstAppLaunch == rhs.isFirstAppLaunch &&
            lhs.setupComplete == rhs.setupComplete &&
            lhs.passcode == rhs.passcode &&
            lhs.isCreatingPasscode == rhs.isCreatingPasscode &&
            lhs.isUsingUniversalPercent == rhs.isUsingUniversalPercent &&
            lhs.universalPercent == rhs.universalPercent &&
            lhs.isUsingQuickTip == rhs.isUsingQuickTip &&
            lhs.isUsingPayPeriods == rhs.isUsingPayPeriods &&
            lhs.switcherSelection == rhs.switcherSelection &&
            lhs.bimonthlyPayPeriod1Start == rhs.bimonthlyPayPeriod1Start &&
            lhs.bimonthlyPayPeriod1End == rhs.bimonthlyPayPeriod1End &&
            lhs.bimonthlyPayPeriod2Start == rhs.bimonthlyPayPeriod2Start &&
            lhs.bimonthlyPayPeriod2End == rhs.bimonthlyPayPeriod2End &&
            lhs.weeklyPayPeriod == rhs.weeklyPayPeriod
    }
    
    @Published var isFirstAppLaunch: Bool {
        didSet { UserDefaults.standard.set(isFirstAppLaunch, forKey: UDKeys.isFirstAppLaunch)
            print("USERSETTINGS-isFirstAppLaunch: \(isFirstAppLaunch)")
        }
    }
    
    @Published var setupComplete: Bool {
        didSet { UserDefaults.standard.set(setupComplete, forKey: UDKeys.setupComplete)
            print("USERSETTINGS-setupComplete: \(setupComplete)")
        }
    }
    
    
    @Published var passcode: String {
        didSet { UserDefaults.standard.set(passcode, forKey: UDKeys.passcode)
            print("USERSETTINGS-passcode: \(passcode)")
        }
    }
    
    @Published var isCreatingPasscode: Bool {
        didSet { UserDefaults.standard.set(isCreatingPasscode, forKey: UDKeys.isCreatingPasscode)
            print("USERSETTINGS-isCreatingPasscode: \(isCreatingPasscode)")
        }
    }
    
    @Published var isUsingUniversalPercent: Bool {
        didSet { UserDefaults.standard.set(isUsingUniversalPercent, forKey: UDKeys.isUsingUniversalPercent)
            print("USERSETTINGS-isUsingUniversalPercent: \(isUsingUniversalPercent)")
        }
    }
    
    @Published var universalPercent: Float {
        didSet { UserDefaults.standard.set(universalPercent, forKey: UDKeys.universalPercent)
            print("USERSETTINGS-universalPercent: \(universalPercent)")
        }
    }
    
    
    @Published var isUsingQuickTip: Bool {
        didSet { UserDefaults.standard.set(isUsingQuickTip, forKey: UDKeys.isUsingQuickTip)
            print("USERSETTINGS-universalPercent: \(isUsingQuickTip)")
        }
    }
    
    
    @Published var isUsingPayPeriods: Bool {
        didSet { UserDefaults.standard.set(isUsingPayPeriods, forKey: UDKeys.isUsingPayPeriods)
            print("USERSETTINGS-isUsingPayPeriods: \(isUsingPayPeriods)")
        }
    }
    
    @Published var switcherSelection: Int {
        didSet { UserDefaults.standard.set(switcherSelection, forKey: UDKeys.switcherSelection)
            print("USERSETTINGS-switcherSelection: \(switcherSelection)")
        }
    }
        
    @Published var weeklyPayPeriod: String {
        didSet { UserDefaults.standard.set(weeklyPayPeriod, forKey: UDKeys.weeklyPayPeriod)
            print("USERSETTINGS-weeklyPayPeriod: \(weeklyPayPeriod)")
        }
    }
    
    @Published var bimonthlyPayPeriod1Start: String {
        didSet { UserDefaults.standard.set(bimonthlyPayPeriod1Start, forKey: UDKeys.bimonthlyPayPeriod1Start)
            print("USERSETTINGS-bimonthlyPayPeriod1: \(bimonthlyPayPeriod1Start)")
        }
    }
    
    @Published var bimonthlyPayPeriod1End: String {
        didSet { UserDefaults.standard.set(bimonthlyPayPeriod1End, forKey: UDKeys.bimonthlyPayPeriod1End)
            print("USERSETTINGS-bimonthlyPayPeriod1: \(bimonthlyPayPeriod1End)")
        }
    }
   
    
    @Published var bimonthlyPayPeriod2Start: String {
        didSet { UserDefaults.standard.set(bimonthlyPayPeriod2Start, forKey: UDKeys.bimonthlyPayPeriod2Start)
            print("USERSETTINGS-bimonthlyPayPeriod2: \(bimonthlyPayPeriod2Start)")
        }
    }
   
    @Published var bimonthlyPayPeriod2End: String {
        didSet { UserDefaults.standard.set(bimonthlyPayPeriod2End, forKey: UDKeys.bimonthlyPayPeriod2End)
            print("USERSETTINGS-bimonthlyPayPeriod2: \(bimonthlyPayPeriod2End)")
        }
    }
    
   
    
    init() {
        self.isFirstAppLaunch = UserDefaults.standard.object(forKey: UDKeys.isFirstAppLaunch) as? Bool ?? true
        self.setupComplete = UserDefaults.standard.object(forKey: UDKeys.setupComplete) as? Bool ?? false
        self.passcode = UserDefaults.standard.object(forKey: UDKeys.passcode) as? String ?? ""
        self.isCreatingPasscode = UserDefaults.standard.object(forKey: UDKeys.isCreatingPasscode) as? Bool ?? true
        self.isUsingUniversalPercent = UserDefaults.standard.object(forKey: UDKeys.isUsingUniversalPercent) as? Bool ?? false
        self.universalPercent = UserDefaults.standard.object(forKey: UDKeys.universalPercent) as? Float ?? Float(0.0)
        self.isUsingQuickTip = UserDefaults.standard.object(forKey: UDKeys.isUsingQuickTip) as? Bool ?? false
        self.isUsingPayPeriods = UserDefaults.standard.object(forKey: UDKeys.isUsingPayPeriods) as? Bool ?? false
        self.switcherSelection = UserDefaults.standard.object(forKey: UDKeys.switcherSelection) as? Int ?? 0
        self.weeklyPayPeriod = UserDefaults.standard.object(forKey: UDKeys.weeklyPayPeriod) as? String ?? "Friday"
        self.bimonthlyPayPeriod1Start = UserDefaults.standard.object(forKey: UDKeys.bimonthlyPayPeriod1Start) as? String ?? ""
        self.bimonthlyPayPeriod1End = UserDefaults.standard.object(forKey: UDKeys.bimonthlyPayPeriod1End) as? String ?? ""
        self.bimonthlyPayPeriod2Start = UserDefaults.standard.object(forKey: UDKeys.bimonthlyPayPeriod2Start) as? String ?? ""
        self.bimonthlyPayPeriod2End = UserDefaults.standard.object(forKey: UDKeys.bimonthlyPayPeriod2End) as? String ?? ""
    }
    
    
    
    func checkPayPeriodsFor(_ account: Account) {
        // Check pay periods
        if isUsingPayPeriods {
            print("using pay periods")
            if weeklyPayPeriod != "" {
                // Check week day
                let weekday = Date().getCurrentWeekdayAsString
                print("check payperiod for: \(weekday)")
                if weekday == weeklyPayPeriod {
                    if account.serviceArray.count > 0 {
                        // Archive and reset here
                        print("Archiving for weekday match")
                        PersistenceController.shared.createArchiveFor(account)
                    }
                }
                
            } else {
                // Check pay day number
                let currentDayString = Date().getCurrentDayNumAsString
                print("check payperiod for \(currentDayString)")
                if currentDayString == bimonthlyPayPeriod1End || currentDayString == bimonthlyPayPeriod2End {
                    if account.serviceArray.count > 0 {
                        // Archive and reset here
                        print("Archiving for bimonthly match")
                        PersistenceController.shared.createArchiveFor(account)
                    }
                }
            }
        }
    }
    
    
    
}
