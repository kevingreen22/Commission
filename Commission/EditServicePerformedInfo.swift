//
//  EditServicePerformedInfo.swift
//  Comish
//
//  Created by Kevin Green on 10/8/20.
//

import SwiftUI
import Combine
import CoreData

struct EditServicePerformedInfo: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    let servicePerformed: ServicePerformed
    @State var dateInterval: DateInterval
    
        
    var body: some View {
//        NavigationView {
            ZStack {
                ColorManager.mainBackgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack() {
                        TextFieldsAndDatePicker(dateInterval: $dateInterval)
                            .environmentObject(vm)
                            .environmentObject(userSettings)
                    } // End VStack
                    
                    VStack {
                        Spacer()
                        DeleteButton(servicePerformed: servicePerformed)
                    }
                    
                } // End ScrollView
            } // End ZStack
            
            .onAppear {
                vm.servPerfName = servicePerformed.name
                vm.servPerfCommission = servicePerformed.commissionAsPercent
                vm.servPerfDate = servicePerformed.date
                vm.servPerfAmount = servicePerformed.amountAsCurrency
                vm.servPerfColor = servicePerformed.color
            }
            
            .navigationBarTitle("Edit Performed Service", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("Cancel edit service tapped")
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.white),
                trailing: Button("Save") {
                    updateServicePerformed { isUpdated in
                        if isUpdated {
                            Haptics.success()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            hideKeyboard()
                            Haptics.error()
                            vm.alertItem = AlertContext.addEditServiceInfoErrorAlert
                        }
                    }
                }.foregroundColor(.white))
            .navigationBarBackButtonHidden(true)
            
//        } // End Navigation View
                    
            .alert(item: $vm.showEditServicePerformedErrorAlert, content: { alertItem in
            if let secondaryButton = alertItem.secondaryButton {
                return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
            } else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }) // end alert
        
    } // End Body
    
    fileprivate func updateServicePerformed(_ updated: (Bool) -> Void) {
        print("Save EDIT ServicePerformed button tapped")
        var commissionFloat: Float = 0.0
        
        guard vm.servPerfName != "" else {
            updated(false)
            return
        }
        
        guard let amountFloat = vm.servPerfAmount.convertToFloat(format: .currency) else {
            updated(false)
            return
        }
        
        if !userSettings.isUsingUniversalPercent {
            guard let _commissionFloat = vm.servPerfCommission.convertToFloat(format: .percentage) else  {
                updated(false)
                return
            }
            commissionFloat = _commissionFloat
        }
           
        PersistenceController.shared.update(
            servicePerformed: servicePerformed,
            name: vm.servPerfName,
            amount: amountFloat,
            commission: !servicePerformed.isTip ? (userSettings.isUsingUniversalPercent ? userSettings.universalPercent : commissionFloat) : 100.0,
            date: vm.servPerfDate,
            color: vm.servPerfColor
        )
        
        updated(true)
    }
    
} // End Struct


fileprivate struct TextFieldsAndDatePicker: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    @Binding var dateInterval: DateInterval
    
    var body: some View {
        Text("Name")
            .bold()
            .foregroundColor(.white)
            .modifier(LabelModifier())
        
        TextField("Name", text: $vm.servPerfName)
            .modifier(TextFieldModifier())
            .modifier(Shadow())
        
        Text("Amount")
            .bold()
            .foregroundColor(.white)
            .modifier(LabelModifier())
        
        TextField("Amount", text: $vm.servPerfAmount)
            .keyboardType(.decimalPad)
            .modifier(TextFieldModifier())
            .modifier(Shadow())
        
        VStack {
            Text("Date")
                .bold()
                .foregroundColor(.white)
                .modifier(LabelModifier())
            
            DatePicker("", selection: $vm.servPerfDate, in: dateInterval.start.addToDate(by: -6)...dateInterval.end.addToDate(by: 6), displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .colorScheme(.dark) // or .light to get black text
        }
        
        if !userSettings.isUsingUniversalPercent {
            Text("Commission")
                .bold()
                .foregroundColor(.white)
                .modifier(LabelModifier())
            
            TextField("Commission", text: $vm.servPerfCommission)
                .keyboardType(.decimalPad)
                .modifier(TextFieldModifier())
                .modifier(Shadow())
        }
    }
}


fileprivate struct DeleteButton: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    let servicePerformed: ServicePerformed
    
    var body: some View {
        Button {
            vm.alertItem = AlertItem(
                title: Text("Delete?"),
                message: Text("Are you sure you want to delete this Performed Service?"),
                dismissButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"),action: {
                    withAnimation {
                        PersistenceController.shared.delete(servicePerformed)
                        vm.servicesArray.removeAll(where: { $0 == servicePerformed })
                        Haptics.success()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
        } label: {
            Text("Delete")
        }
        .font(.largeTitle)
        .foregroundColor(.red)
    }
}




// MARK: Previews
struct EditServicePerformedInfo_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        userSettings.isUsingUniversalPercent = false
        let vc = PersistenceController.preview.container.viewContext
        let account = vc.registeredObjects.first(where: { $0 is Account }) as! Account
        let servPerf = account.servicePerformed?.first(where: { $0 is ServicePerformed }) as! ServicePerformed
        
        return EditServicePerformedInfo(servicePerformed: servPerf, dateInterval: DateInterval())
            .environmentObject(ViewModel())
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, vc)
    }
}
