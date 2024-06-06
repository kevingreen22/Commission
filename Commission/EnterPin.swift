//
//  EnterPin.swift
//  Comish
//
//  Created by Kevin Green on 10/11/20.
//

import SwiftUI

struct EnterPin: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var tempCode = ""
    @State private var alertItem: AlertItem?
    @State private var first = ""
    @State private var second = ""
    @State private var third = ""
    @State private var fourth = ""
    @State private var lastAddedCircleIndex = 0
    @State var attempts: Int = 0
    
    
    var body: some View {
        VStack {
            Spacer()
                .onAppear {
                    if userSettings.passcode == "" {
                        userSettings.isCreatingPasscode = true
                    } else {
                        Biometrics.shared.authenticate { succes in
                            viewModel.isUnlocked = succes
                        }
                    }
                }
            userSettings.isCreatingPasscode ? Text((tempCode == "") ? "Create a Pin" : "Enter your pin again.")
                .font(.title).padding() : Text("Enter Your Pin")
                .foregroundColor(ColorManager.mainDark)
                .font(.title)
                .padding()
            HStack {
                Image(systemName: (first == "") ? "circle" : "circle.fill")
                Image(systemName: (second == "") ? "circle" : "circle.fill")
                Image(systemName: (third == "") ? "circle" : "circle.fill")
                Image(systemName: (fourth == "") ? "circle" : "circle.fill")
                    .onChange(of: fourth, perform: { value in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if value != "" { processPasscodes() }
                        }
                    })
            }
            .modifier(Shake(animatableData: CGFloat(attempts)))
            
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    updateSecureCircles("1")
                }, label: {
                    Text("1")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("2")
                }, label: {
                    Text("2")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("3")
                }, label: {
                    Text("3")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    updateSecureCircles("4")
                }, label: {
                    Text("4")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("5")
                }, label: {
                    Text("5")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("6")
                }, label: {
                    Text("6")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    updateSecureCircles("7")
                }, label: {
                    Text("7")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("8")
                }, label: {
                    Text("8")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    updateSecureCircles("9")
                }, label: {
                    Text("9")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                })
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    // Activate face ID
                    print("face ID pressed")
                    Biometrics.shared.authenticate { success in
                        if success {
                            viewModel.isUnlocked = success
//                            viewRouter.currentPage = .mainView
                        } else {
                            alertItem = AlertItem(title: Text("Enable Face ID?"), message: Text("You must enable Face ID in your device settings in order to use Face ID."), dismissButton: .default(Text("Oh, Ok")), secondaryButton: .default(Text("Open Settings"), action: {
                                guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }))
                        }
                    }
                }, label: {
                    Image(systemName: "faceid")
//                        .foregroundColor(ColorManager.mainDark)
                        .imageScale(.large)
                        .padding()
                })
                .disabled(userSettings.isCreatingPasscode)
                
                Spacer()
                Button(action: {
                    updateSecureCircles("0")
                }, label: {
                    Text("0")
                        .foregroundColor(ColorManager.mainDark)
                        .font(.largeTitle)
                        .padding()
                        .font(.largeTitle)
                        .padding()
                })
                
                Spacer()
                Button(action: {
                    print("delete pressed")
                    updateSecureCircles(nil, isDeleteing: true, forCircle: lastAddedCircleIndex)
                }, label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color.red)
                        .imageScale(.large)
                        .padding()
                })
                Spacer()
            }
            
            Spacer()
            Spacer()
        }
        
        .alert(item: $alertItem) { alertItem in
            if let secondaryButton = alertItem.secondaryButton {
                return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
            } else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }
    }
    
    
    fileprivate func getEnteredCode() -> String {
        let enteredCode = first + second + third + fourth
        return enteredCode
    }
    
    fileprivate func clearEnteredCode() {
        first = ""
        second = ""
        third = ""
        fourth = ""
    }
    
    fileprivate func updateSecureCircles(_ number: String?, isDeleteing: Bool = false, forCircle index: Int? = nil) {
        switch isDeleteing {
        case true:
            switch index {
            case 1:
                first = ""
                lastAddedCircleIndex = 0
            case 2:
                second = ""
                lastAddedCircleIndex = 1
            case 3:
                third = ""
                lastAddedCircleIndex = 2
            case 4:
                fourth = ""
                lastAddedCircleIndex = 3
            default:
                break
            }
            
        case false:
            guard let number = number else { return }
            if first == "" {
                first = number
                lastAddedCircleIndex = 1
            } else if second == "" {
                second = number
                lastAddedCircleIndex = 2
            } else if third == "" {
                third = number
                lastAddedCircleIndex = 3
            } else if fourth == "" {
                fourth = number
            }
        }
    }
    
     func processPasscodes() {
        switch userSettings.isCreatingPasscode {
        
        // Verifying passcode entered
        case false:
            let enteredCode = getEnteredCode()
            if enteredCode == userSettings.passcode && fourth != "" {
                print("correct passcode entered")
                viewModel.isUnlocked = true
            } else if enteredCode.count == 4 {
                print("wrong passcode entered: \(userSettings.passcode)")
                Haptics.error()
                // animate circles to shake
                withAnimation(.default) {
                    self.attempts += 1
                }
                clearEnteredCode()
            }
            
        // Creating passcode, requires to enter the code twice
        case true:
            switch tempCode {
            case "":
                // First time entered
                tempCode = getEnteredCode()
                print("tempCode: \(tempCode)")
                clearEnteredCode()
                
            default:
                if tempCode != "" {
                    // Second time entered
                    let secondEnteredCode = getEnteredCode()
                    // Check if both codes match
                    if tempCode != secondEnteredCode {
                        // Passcodes don't match
                        // Show alert and start over
                        Haptics.error()
                        clearEnteredCode()
                        tempCode = ""
                        alertItem = AlertItem(title: Text("Wrong Pin"), message: Text("Both pins must match."),  dismissButton: .cancel(Text("Gotcha")))
                    } else {
                        // Both passcodes match
                        viewModel.isUnlocked = true
                        userSettings.passcode = secondEnteredCode
                        userSettings.isCreatingPasscode = false
                    }
                }
            }
        }
    }
    
}

struct EnterPin_Previews: PreviewProvider {
    static var previews: some View {
        EnterPin()
            .environmentObject(ViewModel())
            .environmentObject(UserSettings())
    }
}
