//
//  AddService.swift
//  Comish
//
//  Created by Kevin Green on 10/2/20.
//

import SwiftUI
import Combine
import CoreData

struct AddService: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var showAddServiceErrorAlert: AlertItem?
    @State private var serviceName: String = ""
    @State private var serviceAmount: String = ""
    @State private var serviceCommission: String = ""
    @State private var serviceColor = Color.blue
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.mainBackgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        GridItemService(serviceName: $serviceName, serviceAmount: $serviceAmount, serviceCommission: $serviceCommission, serviceColor: $serviceColor)
                            .environmentObject(vm)
                            .environmentObject(userSettings)
                        
                        ColorPicker("", selection: $serviceColor, supportsOpacity: true).padding(.trailing)
                        
                        Divider().background(Color.white)
                        
                        TextFields(serviceName: $serviceName, serviceAmount: $serviceAmount, serviceCommission: $serviceCommission, serviceColor: $serviceColor)
                            .environmentObject(vm)
                            .environmentObject(userSettings)
                        
                        Spacer()
                    } // End VStack
                } // End Scroll view
            } // End ZStack
            
            .navigationBarTitle("Add Service", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("Cancel save service tapped")
                    self.presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.white),
                trailing: Button("Save") {
                    print("Save Service button tapped")
                    saveService { isSaved in
                        if isSaved {
                            Haptics.success()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            hideKeyboard()
                            Haptics.error()
                            showAddServiceErrorAlert = AlertContext.addEditServiceInfoErrorAlert
                        }
                    }
                }
                .foregroundColor(.white)
            )
            
            .alert(item: $showAddServiceErrorAlert, content: { alertItem in
                if let secondaryButton = alertItem.secondaryButton {
                    return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
                } else {
                    return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
            }) // End alert
            
        } // End Navigation View
    } // End body
    
    fileprivate func saveService(_ saved: (Bool) -> Void) {
        var _commissionFloat: Float = 0.0
        
        guard serviceName != "" else {
            saved(false)
            return
        }
        
        guard let amountFloat = serviceAmount.convertToFloat(format: .currency) else {
            saved(false)
            return
        }
        
        if !userSettings.isUsingUniversalPercent {
            guard let commissionFloat = serviceCommission.convertToFloat(format: .percentage) else {
                saved(false)
                return
            }
            _commissionFloat = commissionFloat
        }
            
        PersistenceController.shared.createNewService(
            name: serviceName,
            amount: amountFloat,
            commission: userSettings.isUsingUniversalPercent ? userSettings.universalPercent : _commissionFloat,
            color: UIColor(serviceColor)
        )
        
        saved(true)
    }
    
} // End struct


fileprivate struct GridItemService: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @Binding var serviceName: String
    @Binding var serviceAmount: String
    @Binding var serviceCommission: String
    @Binding var serviceColor: Color
    
    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100, alignment: .center)
            .cornerRadius(20)
            .foregroundColor(.clear)
            .background(serviceColor)
            .cornerRadius(20)
            .modifier(Shadow())
            .overlay(
                VStack(alignment: .leading) {
                    Text("\(serviceName)")
                        .foregroundColor(Color.white)
                        .offset(x: 0, y: 7.0)
                    
                    Spacer()
                    
                    Text("$\(serviceAmount)")
                        .foregroundColor(Color.white)
                        .font(.title2)
                    
                    Spacer()
                    
                    if !userSettings.isUsingUniversalPercent {
                        Text("\(serviceCommission)%")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                            .bold()
                            .offset(x: 0, y: -6)
                    }
                }
            )
            .padding(.top)
    }
}


fileprivate struct TextFields: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @Binding var serviceName: String
    @Binding var serviceAmount: String
    @Binding var serviceCommission: String
    @Binding var serviceColor: Color
    
    var body: some View {
        Text("Name")
            .bold()
            .foregroundColor(.white)
            .modifier(LabelModifier())
        
        TextField("Enter a Name", text: $serviceName)
            .modifier(TextFieldModifier())
            .modifier(Shadow())
        
        Text("Amount")
            .bold()
            .foregroundColor(.white)
            .modifier(LabelModifier())
        
        TextField("Enter an amount", text: $serviceAmount)
            .keyboardType(.decimalPad)
            .modifier(TextFieldModifier())
            .modifier(Shadow())
        
        if !userSettings.isUsingUniversalPercent {
            Text("Commission")
                .bold()
                .foregroundColor(.white)
                .modifier(LabelModifier())
            
            TextField("Enter a percentage", text: $serviceCommission)
                .keyboardType(.decimalPad)
                .modifier(TextFieldModifier())
                .modifier(Shadow())
        }
    }
}





// MARK: Previews
struct AddService_Previews: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        
        return AddService()
            .environmentObject(ViewModel())
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, vc)
    }
}
