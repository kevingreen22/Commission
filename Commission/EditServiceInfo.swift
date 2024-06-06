//
//  EditServiceInfo.swift
//  Comish
//
//  Created by Kevin Green on 10/15/20.
//

import SwiftUI
import CoreData

struct EditServiceInfo: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    let service: Service
    
    @State private var showEditServiceInfoErrorAlert: AlertItem?
    @State private var editServiceName: String = ""
    @State private var editServiceAmount: String = ""
    @State private var editServiceCommission: String = ""
    @State private var editServiceColor = Color.blue
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.mainBackgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        GridItemEditService(editServiceName: $editServiceName, editServiceAmount: $editServiceAmount, editServiceCommission: $editServiceCommission, editServiceColor: $editServiceColor)
                            .environmentObject(vm)
                            .environmentObject(userSettings)
                        
                        ColorPicker("", selection: $editServiceColor, supportsOpacity: true)
                            .padding(.trailing)
                            .environmentObject(vm)
                            .environmentObject(userSettings)
                            
                        
                        Divider().background(Color.white)
                        
                        TextFields(editServiceName: $editServiceName, editServiceAmount: $editServiceAmount, editServiceCommission: $editServiceCommission, editServiceColor: $editServiceColor)
                            .environmentObject(vm)
                            .environmentObject(userSettings)
                        
                        Spacer()
                    } // End VStack
                    
                    VStack {
                        Spacer()
                        DeleteButton(service: service)
                    }
                    
                } // End scroll view
            } // End ZStack
            
            .onAppear() {
                self.editServiceAmount = service.amountAsCurrency
                self.editServiceCommission = service.commissionAsPercent
                self.editServiceName = service.name
                self.editServiceColor = service.color
            }
            .navigationBarTitle("Edit Service", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    print("Cancel edit service tapped")
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.white),
                trailing: Button("Save") {
                    updateService { isUpdated in
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
            
        } // end navigation view
            
        .alert(item: $showEditServiceInfoErrorAlert, content: { alertItem in
            if let secondaryButton = alertItem.secondaryButton {
                return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
            } else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }) // end alert
        
    } // end body
    
    fileprivate func updateService(_ updated: (Bool) -> Void) {
        print("Save EDIT Service button tapped")
        var commissionFloat: Float = 0.0
        
        guard editServiceName != "" else {
            updated(false)
            return
        }
        
        guard let amountFloat = editServiceAmount.convertToFloat(format: .currency) else {
            updated(false)
            return
        }
        
        if !userSettings.isUsingUniversalPercent {
            guard let _commissionFloat = editServiceCommission.convertToFloat(format: .percentage) else {
                updated(false)
                return
            }
            commissionFloat = _commissionFloat
        }
          
        PersistenceController.shared.update(
            service,
            name: editServiceName,
            amount: amountFloat,
            commission: userSettings.isUsingUniversalPercent ? userSettings.universalPercent : commissionFloat,
            color: editServiceColor
        )
        
        updated(true)
    }
    
} // End Struct


fileprivate struct DeleteButton: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var service: Service
    
    var body: some View {
        Button {
            vm.alertItem = AlertItem(
                title: Text("Delete?"),
                message: Text("Are you sure you want to delete this Service?"),
                dismissButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"), action: {
                    PersistenceController.shared.delete(service)
                    Haptics.success()
                    self.presentationMode.wrappedValue.dismiss()
                })
            )
        } label: {
            Text("Delete")
        }
        .font(.largeTitle)
        .foregroundColor(.red)
    }
}


fileprivate struct GridItemEditService: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @Binding var editServiceName: String
    @Binding var editServiceAmount: String
    @Binding var editServiceCommission: String
    @Binding var editServiceColor: Color
    

    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100, alignment: .center)
            .foregroundColor(editServiceColor)
            .overlay(
                VStack(alignment: .leading) {
                    Text("\(editServiceName)")
                        .foregroundColor(Color.white)
                        .offset(x: 0, y: 7.0)
                    
                    Spacer()
                    
                    Text(editServiceAmount)
                        .foregroundColor(Color.white)
                        .font(.title2)
                    
                    Spacer()
                    
                    Text(userSettings.isUsingUniversalPercent ? String(userSettings.universalPercent) : editServiceCommission)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .bold()
                        .offset(x: 0, y: -6)
                }
            )
            .cornerRadius(20)
            .modifier(Shadow())
            .contentShape(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .padding(.top)
    }
}


fileprivate struct TextFields: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @Binding var editServiceName: String
    @Binding var editServiceAmount: String
    @Binding var editServiceCommission: String
    @Binding var editServiceColor: Color
    
    var body: some View {
        Text("Name")
            .bold()
            .foregroundColor(.white)
            .modifier(LabelModifier())
        
        TextField("Enter a Name", text: $editServiceName)
            .modifier(TextFieldModifier())
            .modifier(Shadow())
        
        Text("Amount")
            .bold()
            .foregroundColor(.white)
            .modifier(LabelModifier())
        
        TextField("Enter an amount", text: $editServiceAmount)
            .keyboardType(.decimalPad)
            .modifier(TextFieldModifier())
            .modifier(Shadow())
        
        
        if !userSettings.isUsingUniversalPercent {
            Text("Commission")
                .bold()
                .foregroundColor(.white)
                .modifier(LabelModifier())
            
            TextField("Enter a percentage", text: $editServiceCommission)
                .keyboardType(.decimalPad)
                .modifier(TextFieldModifier())
                .modifier(Shadow())
        }
    }
}




// MARK: Previews
struct EditServiceInfo_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        userSettings.isUsingUniversalPercent = false
        let vc = PersistenceController.preview.container.viewContext
        let service = vc.registeredObjects.first(where: { $0 is Service }) as! Service
                
        return EditServiceInfo(service: service)
            .environmentObject(ViewModel())
            .environmentObject(userSettings)
            .environment(\.managedObjectContext, vc)
    }
}
