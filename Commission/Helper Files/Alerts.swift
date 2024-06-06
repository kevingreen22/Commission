//
//  Alerts.swift
//  Commission
//
//  Created by Kevin Green on 5/9/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button
    var secondaryButton: Alert.Button?
}



/// Alerts that do not have an action attached.
struct AlertContext {
    
    static let universalPercentInfoAlert = AlertItem(title: Text("Universal Percentage"), message: Text("This will make all services have the same commission percentage amount. Turning this option off will allow you to set each service's commission percentage amount independently."), dismissButton: .default(Text("Got It")))
    
    static let quickTipInfoAlert = AlertItem(title: Text("QuickTip"), message: Text("QuickTip adds a tip item to the services that allows you to set the tip amount when you tap it."), dismissButton: .default(Text("Got It")))
    
    static let payPeriodsInfoAlert = AlertItem(title: Text("Pay Periods"), message: Text("Pay periods allow you to set a weekly or bi-weekly schedule of your pay day(s). Comish will then automatically archive your current performed service(s) so you can view them at a later date. Keep in mind that once your performed services are archived, you won't be able to edit them. (This feature is in Beta testing)"), dismissButton: .default(Text("Got It")))
    
    static let addEditServiceInfoErrorAlert = AlertItem(title: Text("Error"), message: Text("Be sure to fill in all fields."), dismissButton: .cancel(Text("Ok")))

    
    
}
