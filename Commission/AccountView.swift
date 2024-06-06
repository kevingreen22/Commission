//
//  ContentView.swift
//  Comish
//
//  Created by Kevin Green on 10/2/20.
//

import SwiftUI
import Combine
import CoreData

struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    
    var body: some View {
        ZStack {
            ColorManager.mainBackgroundGradient.edgesIgnoringSafeArea(.all)
            VStack {
//                Title()
//                DismissButton()
                ImageCircle(showEditButton: true, account: account)
                    .padding([.bottom, .top])
                    
                List {
                    AccountInfo(account: account)
                        .environmentObject(vm)
                        .environmentObject(userSettings)
                    UniversalPercentage()
                        .environmentObject(vm)
                        .environmentObject(userSettings)
                    QuickTip()
                        .environmentObject(vm)
                        .environmentObject(userSettings)
                    PayPeriodSectionView()
                        .environmentObject(vm)
                        .environmentObject(userSettings)
                    ReplayOnboarding()
                        .environmentObject(userSettings)
                    ResetPinSectionView()
                        .environmentObject(vm)
                        .environmentObject(userSettings)
                    FeedbackSectionView()
                    Section(footer: BundleInfoView(bundleInfoType: .versionNumber)) {}
                }
                .listStyle(InsetGroupedListStyle())

            } // End VStack
                        
            // NAVIGATION CONFIG
            .navigationBarTitle("Account Profile", displayMode: .inline)
                        
        } // End ZStack
        
        .alert(item: $vm.accountViewAlertItem, content: { alertItem in
            if let secondaryButton = alertItem.secondaryButton {
                return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
            } else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }) // End alert
        
        .sheet(isPresented: $vm.isShowPhotoLibrary, onDismiss: vm.loadImage(for: account)) {
            ImagePicker(selectedImage: $vm.pickedImage, sourceType: .photoLibrary)
        }
                
    } // End Body
} // End AccountView


fileprivate struct Title: View {
    var body: some View {
        HStack {
            Text("Account Profile")
                .font(.title)
                .foregroundColor(.white)
        }
    }
} // End Title


//fileprivate struct DismissButton: View {
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    Text("Done")
//                        .foregroundColor(.white)
//                })
//            }
//            Spacer()
//        }
//    }
//} // End DismissButton


fileprivate struct AccountInfo: View {
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    
    var body: some View {
        Section(header: Text("Account Settings")) {
            TextField("Enter Name", text: $vm.name, onCommit: {
                vm.update(account: account)
            })
            .accentColor(ColorManager.mainDark)
            .font(.headline)

            
            HStack {
                Text("Reset Services")
                Spacer()
                Button(action: {
                    vm.accountViewAlertItem = AlertItem(title: Text("Reset Services?"), message: Text("Are you sure you want to reset this Account's performed services?"), dismissButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Reset"), action: {
                        vm.resetServices(for: account)
                    }))
                }, label: {
                    Text("Reset").foregroundColor(.red)
                })
            }
            
//            HStack {
//                Text("Delete Account")
//                Spacer()
//                Button {
//                    vm.accountViewAlertItem = AlertItem(
//                        title: Text("Delete?"),
//                        message: Text("Are you sure you want to delete this Account? All data & archives will be deleted as well."),
//                        dismissButton: .cancel(Text("Cancel")),
//                        secondaryButton: .destructive(
//                            Text("Delete"),
//                            action: {
//                                vm.delete(account: account
//                            }
//                        )
//                    )
//                } label: {
//                    Text("Delete").foregroundColor(.red)
//                }
//            } // End HStack
            
        } // End section
        
        .onAppear {
            vm.name = account.name
        }
                
    } // End body
} // End AccountInfo


fileprivate struct UniversalPercentage: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    @State private var universalPercent = ""
    @State private var isEditing = false
    
    var body: some View {
        Section {
            Toggle(isOn: $userSettings.isUsingUniversalPercent.animation()) {
                Text("Use Universal Percent")
                InfoButton(type: .universalPercent).environmentObject(vm)
            }
            
            if userSettings.isUsingUniversalPercent {
                ZStack {
                    TextField("Enter Percentage", text: $universalPercent) { (isEditing) in
                        withAnimation {
                            self.isEditing = isEditing
                        }
                        userSettings.universalPercent = Float(universalPercent) ?? 0.0
                    }
                    .keyboardType(.decimalPad)
                    
                    if isEditing {
                        HStack {
                            Spacer()
                            Button(action: {
                                userSettings.universalPercent = Float(universalPercent) ?? 0.0
                                self.isEditing = false
                                hideKeyboard()
                            }, label: {
                                Text("Done").foregroundColor(.blue).bold()
                            })
                            .animation(.easeIn)
                        }
                    }
                }
            }
            
        } // End Section
        
        .onAppear {
            universalPercent = String(userSettings.universalPercent)
        }
        
    } // End Body
} // End UniversalPercentage


fileprivate struct QuickTip: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        Section {
            Toggle(isOn: $userSettings.isUsingQuickTip) {
                Text("Use QuickTip")
                InfoButton(type: .quickTip).environmentObject(vm)
            }
            .onChange(of: userSettings.isUsingQuickTip) { quickTip in
                vm.update(quickTip: quickTip)
            }
        } // End Section
    } // End Body
} // End QuickTip


fileprivate struct PayPeriodSectionView: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    let switcherOptions = ["Weekly", "Bi-Monthly"]
    let weeklyDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    let monthDays = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31",]
    
    
    var body: some View {
        Section {
            Toggle(isOn: $userSettings.isUsingPayPeriods.animation()) {
                Text("Use Pay Periods")
                InfoButton(type: .payPeriods).environmentObject(vm)
            }
            
            if userSettings.isUsingPayPeriods {
                Picker("Numbers", selection: $userSettings.switcherSelection.animation()) {
                    ForEach(0..<switcherOptions.count) { i in
                        Text(self.switcherOptions[i]).tag(i)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                
                switch userSettings.switcherSelection {
                case 1:
                    Picker("First pay period start:", selection: $userSettings.bimonthlyPayPeriod1Start) {
                        ForEach(monthDays, id: \.self) { day in
                            Text(day)
                        }
                    }
                    Picker("First pay period end:", selection: $userSettings.bimonthlyPayPeriod1End) {
                        ForEach(monthDays, id: \.self) { day in
                            Text(day)
                        }
                    }
                    Picker("Second Pay period start:", selection: $userSettings.bimonthlyPayPeriod2Start) {
                        ForEach(monthDays, id: \.self) { day in
                            Text(day)
                        }
                    }
                    Picker("Second Pay period end:", selection: $userSettings.bimonthlyPayPeriod2End) {
                        ForEach(monthDays, id: \.self) { day in
                            Text(day)
                        }
                    }
                    .onReceive(userSettings.$bimonthlyPayPeriod2End) { (_) in
                        if userSettings.bimonthlyPayPeriod1Start != "" &&
                            userSettings.bimonthlyPayPeriod1End != "" &&
                            userSettings.bimonthlyPayPeriod2Start != "" &&
                            userSettings.bimonthlyPayPeriod2End != "" {
                            userSettings.weeklyPayPeriod = ""
                        }
                    }
                    
                default:
                    Picker("Weekly Payday:", selection: $userSettings.weeklyPayPeriod) {
                        ForEach(weeklyDays, id: \.self) { day in
                            Text("\(day)")
                        }
                    }.onReceive(userSettings.$weeklyPayPeriod) { (_) in
                        if userSettings.weeklyPayPeriod != "" {
                            userSettings.bimonthlyPayPeriod1Start = ""
                            userSettings.bimonthlyPayPeriod1End = ""
                            userSettings.bimonthlyPayPeriod2Start = ""
                            userSettings.bimonthlyPayPeriod2End = ""
                        }
                    }
                }
            }
        
        } // end section
    } // End Body
} // End PayPeriodSectionView


fileprivate struct ResetPinSectionView: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Section {
            HStack {
                Text("Reset Pin")
                Spacer()
                Button("Reset") {
                    vm.alertItem = AlertItem(title: Text("Reset Pin?"), message: Text("Are you sure you want to reset your pin?"), dismissButton: .cancel(Text("Nevermind")), secondaryButton: .destructive(Text("Reset"), action: {
                        // Reset pin
                        print("reseting pin")
                        userSettings.passcode = ""
                    }))
                }.foregroundColor(.blue)
            }
        }
    }
} // End ResetPinSectionView


fileprivate struct ReplayOnboarding: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Section {
            HStack {
                Text("Replay Tutorial")
                Spacer()
                Button("Replay") {
                    userSettings.isFirstAppLaunch = true
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.blue)
            }
        }
    }
}


fileprivate struct FeedbackSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingEmailComposer = false
    
    var body: some View {
        Section {
            Button(action: {
                self.isShowingEmailComposer = true
            }, label: {
                Text("Send Feedback")
                    .foregroundColor(colorScheme == .light ? .black : .white)
            })
        }
        .sheet(isPresented: $isShowingEmailComposer) {
            EmailHelper(subject: "Feedback for Comish", to: "stuckbykev@gmail.com")
        }
    }
} // End FeedbackSectionView


fileprivate struct InfoButton: View {
    @EnvironmentObject var vm: ViewModel
    var type: InfoAlertType
    
    var body: some View {
        Button(action: {
            switch type {
            case .universalPercent:
                vm.accountViewAlertItem = AlertContext.universalPercentInfoAlert
            case .quickTip:
                vm.accountViewAlertItem = AlertContext.quickTipInfoAlert
            case .payPeriods:
                vm.accountViewAlertItem = AlertContext.payPeriodsInfoAlert
            }
        }, label: {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        })
    }
}


fileprivate enum InfoAlertType {
    case universalPercent
    case quickTip
    case payPeriods
}




// MARK: Previews
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        let account = vc.registeredObjects.first(where: { $0 is Account }) as! Account
        
        AccountView(account: account)
            .environmentObject(ViewModel())
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, vc)
    }
}

