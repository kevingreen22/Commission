//
//  MainView.swift
//  Commission
//
//  Created by Kevin Green on 3/17/21.
//

import SwiftUI
import Combine
import CoreData
import LocalAuthentication

struct MainView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @FetchRequest(entity: Account.entity(), sortDescriptors: [], animation: .default) var accounts: FetchedResults<Account>

    @FetchRequest(entity: Service.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Service.userOrder, ascending: true)], animation: .default) var services: FetchedResults<Service>
    
    @State var account: Account?

//    var rows = [ GridItem(.fixed(200)) ]
    var columns = [ GridItem(.adaptive(minimum: 100, maximum: 200)) ]
    
    
    var body: some View {
        ZStack {
//            if vm.isUnlocked && userSettings.setupComplete {
                NavigationView {
                    VStack {
                        
                        // MARK: ACCOUNTS VIEW
                        AccountsHeaderView()
                        ForEach(accounts) { account in
                            NavigationLink(destination: PerformedList(account: account)) {
                                AccountGridItem(account: account)
                                    .onChange(of: account) { acct in
                                        self.account = acct
                                        vm.currentAccountID = acct.objectID
                                        userSettings.checkPayPeriodsFor(acct)
                                    }
                                    .onAppear {
                                        self.account = account
                                        vm.currentAccountID = account.objectID
                                        userSettings.checkPayPeriodsFor(account)
                                    }
                                
                                //                                    .contextMenu {
                                //                                        // Edit Account
                                //                                        Button(action: { NavigationLink(
                                //                                            destination:
                                //                                                AccountView(account: account)
                                //                                                .environmentObject(vm)
                                //                                                .environmentObject(userSettings)
                                //                                        ) {
                                //                                            Image(systemName: "person.fill")
                                //                                        }
                                //                                        }, label: {
                                //                                            Text("Edit Account")
                                //                                            Image(systemName: "person.fill")
                                //                                                .scaleEffect(1.5)
                                //                                        })
                                //
                                //                                        // Reset services performed
                                //                                        Button(action: {
                                //                                            vm.alertItem = AlertItem(
                                //                                                title: Text("Reset Services?"),
                                //                                                message: Text("Are you sure you want to reset this Account's performed services?"),
                                //                                                dismissButton: .cancel(Text("Cancel")),
                                //                                                secondaryButton: .destructive(
                                //                                                    Text("Reset"),
                                //                                                    action: {
                                //                                                        Haptics.success()
                                //                                                        PersistenceController.shared.resetServicesFor(account)
                                //                                                    }
                                //                                                )
                                //                                            )
                                //                                        }, label: {
                                //                                            Text("Reset Services")
                                //                                            Image(systemName: "arrow.counterclockwise.circle")
                                //                                        })
                                //
                                //                                        //Delete Account
                                //                                        Button {
                                //                                            vm.alertItem = AlertItem(
                                //                                                title: Text("Delete?"),
                                //                                                message: Text("Are you sure you want to delete this Account? All data & archives will be deleted as well."),
                                //                                                dismissButton: .cancel(Text("Cancel")),
                                //                                                secondaryButton: .destructive(
                                //                                                    Text("Delete"),
                                //                                                    action: {
                                //                                                        Haptics.success()
                                //                                                        PersistenceController.shared.delete(account)
                                //                                                    }
                                //                                                ))
                                //                                        } label: {
                                //                                            Text("Delete Account")
                                //                                            Image(systemName: "trash")
                                //                                        }
                                //                                    } // End context menu
                                
                                
                            } // End Nav Link
                            
                            .navigationBarItems(
                                leading:
                                    NavigationLink(destination:
                                                    AccountView(account: account)
                                                    .environmentObject(vm)
                                                    .environmentObject(userSettings)
                                    ) {
                                        Image(systemName: "person.fill")
                                    },
                                trailing:
                                    Button(action: {
                                        withAnimation {
                                            vm.activeFullCover = .showArchive(account)
                                        }
                                    }, label: {
                                        Image(systemName: "archivebox")
                                    }))
                            
                        } // End ForEach
                            
                        
                        ScrollView {
                            VStack {
                                // MARK: SERVICES VIEWS
                                ServicesHeaderView()
                                LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                                    ForEach(services) { service in
                                        if let _account = account {
                                            ServicesView(account: _account, services: services, service: service)
                                        }
                                    } // End ForEach
                                } // End LazyVGrid
                            } // End VStack
                        } // End ScrollView
                    } // End Main VStack
                    
                    .navigationBarTitle("", displayMode: .inline)
                    .accentColor(ColorManager.mainDark)
                    .background(ColorManager.mainBackgroundGradient)
                    .edgesIgnoringSafeArea(.bottom)
                    
                    .onDrop(of: ["public.plain-text"], delegate: DropOutsideDelegate(current: $vm.dragging))
                    
                    .alert(item: $vm.alertItem, content: { alertItem in
                        if let secondaryButton = alertItem.secondaryButton {
                            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
                        } else {
                            return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                        }
                    }) // End alert
                    
                    .textFieldAlert(isPresented: $vm.isPresentingAmountAlert) {
                        TextFieldAlert(title: "Tip Amount", message: "", text: $vm.tipAmount, buttons: vm.textFieldAlertButtons(items: [services as AnyObject]))
                    }
                    
                    .fullScreenCover(item: $vm.activeFullCover, onDismiss: nil, content: { item in
                        switch item {
                        case .addService:
                            AddService()
                                .environmentObject(userSettings)
                                .environment(\.managedObjectContext, self.moc)
                        case .editService(let service):
                            EditServiceInfo(service: service)
                                .environmentObject(userSettings)
                                .environment(\.managedObjectContext, self.moc)
                        case .showArchive(let account):
                            ArchiveViewer(account: account)
                                .environmentObject(vm)
                                .environment(\.managedObjectContext, self.moc)
                        }
                    }) // End full screen cover
                    
                } // End NavigationView
                .accentColor(.white)
                
                
//            } else if userSettings.setupComplete {
//                EnterPin()
//            } else if !userSettings.setupComplete {
//                ProfileSetupName()
//            }
            
            
            if userSettings.isFirstAppLaunch && userSettings.setupComplete && vm.isUnlocked {
                Onboarding()
                    .environmentObject(userSettings)
            }
            
            
        } // End ZStack
    } // End Body
} // End MainView


struct AccountsHeaderView: View {
    var body: some View {
        HStack {
            Text("Account")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding([.top, .leading])
            Spacer()
        }
    }
} // End AccountsHeaderView


struct ServicesHeaderView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        HStack {
            Text("Services")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding(.leading)
            Spacer()
            AddItemToGrid()
                .scaleEffect(0.3)
                .onTapGesture(count: 1, perform: {
                    print("Add Service button tapped")
                    vm.activeFullCover = .addService
                })
        } // End HStack
    } // End body
} // End ServicesHeaderView


struct ServicesView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    @State private var rotationAmount: Double = 0
    var services: FetchedResults<Service>
    let service: Service

    
    var body: some View {
            ServiceGridItem(service: service)
                .contextMenu {
                    if !service.isTip {
                        // Edit Service
                        Button(action: {
                            vm.activeFullCover = .editService(service)
                        }, label: {
                            Text("Edit")
                            Image(systemName: "square.and.pencil")
                        })
                        
                        // Delete service
                        Button {
                            vm.alertItem = AlertItem(
                                title: Text("Delete?"),
                                message: Text("Are you sure you want to delete this Service?"),
                                dismissButton: .cancel(Text("Cancel")),
                                secondaryButton: .destructive(Text("Delete"), action: {
                                    vm.delete(service: service)
                                }))
                        } label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                } // End context menu
                
                .rotation3DEffect(Angle(degrees: rotationAmount), axis: (x: 1, y: 0, z: 1))
                
                .onTapGesture {
                    if !service.isTip {
                        withAnimation {
                            rotationAmount = 360
                        }
                        vm.add(perfService: service, to: account)
                        rotationAmount = 0
                        
                    } else {
                        vm.isPresentingAmountAlert.toggle()
                    }
                }
                
                .onDrag {
                    vm.dragging = service
                    vm.servs = Array(services)
                    return NSItemProvider(object: String(service.identifier.uuidString) as NSString)
                }
                
                .onDrop(of: ["public.plain-text"], delegate: DragRelocateDelegate(moc: moc, item: service, listData: $vm.servs, current: $vm.dragging))
        
                
    }// End Body
} // End ServicesView


struct DragRelocateDelegate: DropDelegate {
    var moc: NSManagedObjectContext
    let item: Service
    @Binding var listData: [Service]
    @Binding var current: Service?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
                updateFetchedResults(for: listData)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        updateFetchedResults(for: listData)
        return true
    }
    
    fileprivate func updateFetchedResults(for array: [Service]) {
        for reverseIndex in stride(from: array.count - 1, through: 0, by: -1 ) {
            array[reverseIndex].userOrder = NSNumber(value: UInt8(reverseIndex))
        }

        try? moc.save()
    }
    
} // End DragRelocateDelegate


struct DropOutsideDelegate: DropDelegate {
    @Binding var current: Service?

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
} // End DropOutsideDelegate


struct Onboarding: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var num = 1
    @State private var opacity = 1.0
        
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
            
            if num == 1 {
            OnboardingAddNewService()
                .offset(y: 23)
                .transition(AnyTransition.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.3))
            }
            
            if num == 2 {
                OnboardingService(direction: userSettings.isUsingQuickTip ? .bottomMid : .bottomLeft)
                    .offset(x: userSettings.isUsingQuickTip ? 0 : -50, y: -30)
                    .transition(AnyTransition.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.3))
                
                Rectangle()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.blue)
                    .overlay(
                        VStack(alignment: .leading) {
                            Text("Standard")
                                .foregroundColor(Color.white)
                                .offset(x: 0, y: 7.0)
                                .allowsTightening(true)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("$100.00")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .allowsTightening(true)
                            
                            Spacer()
                            
                            Text("50%")
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
                    .offset(x: userSettings.isUsingQuickTip ? 0 : -127, y: 100)
                    .transition(AnyTransition.scale(scale: 0))
                    .animation(.easeInOut(duration: 0.3))
            }
            
            if num == 3 {
                OnboardingCurrentPerfServ()
                    .offset(y: 30)
                    .transition(AnyTransition.move(edge: .top))
                    .animation(.easeInOut(duration: 0.3))
            }
            
            if num == 4 {
                OnboardingViewArchive()
                    .offset(x: 15, y: -320)
                    .transition(AnyTransition.move(edge: .top))
                    .animation(.easeInOut(duration: 0.3))
            }
            
            if num == 5 {
                OnboardingViewAccount()
                    .offset(x: -20, y: -320)
                    .transition(AnyTransition.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            }
            
        }
        .opacity(opacity)
        .onTapGesture {
            withAnimation {
                num += 1
                if num == 6 {
                    opacity = 0.0
                    userSettings.isFirstAppLaunch = false
                }
            }
        }
    }
}



// MARK: Previews
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ViewModel()
        vm.isUnlocked = true
        
        let us = UserSettings()
        us.setupComplete = true
        us.isUsingQuickTip = true
        
        let vc = PersistenceController.preview.container.viewContext
        
        return MainView()
            .environmentObject(vm)
            .environmentObject(us)
            .environment(\.managedObjectContext, vc)
    }
}


