//
//  CommissionApp.swift
//  Commission
//
//  Created by Kevin Green on 3/17/21.
//

import SwiftUI

@main
struct CommissionApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewRouter = ViewRouter()
    @StateObject var viewModel = ViewModel()
    @StateObject var userSettings = UserSettings()
    let persistenceController = PersistenceController.shared
        
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    var body: some Scene {
        WindowGroup {
            switch viewRouter.currentPage {
            case .profileSetupName :
                ProfileSetupName()
                    .environmentObject(viewRouter)
                    .environmentObject(viewModel)
                    .environmentObject(userSettings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            case .profileSetupChooseImage:
                ProfileSetupChooseImage()
                    .environmentObject(viewRouter)
                    .environmentObject(viewModel)
                    .environmentObject(userSettings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            case .profileSetupUniversalPercent:
                ProfileSetupUniversalPercent()
                    .environmentObject(viewRouter)
                    .environmentObject(viewModel)
                    .environmentObject(userSettings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            case .profileSetupQuickTip:
                ProfileSetupQuickTip()
                    .environmentObject(viewRouter)
                    .environmentObject(viewModel)
                    .environmentObject(userSettings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            case .mainView:
                MainView()
                    .environmentObject(viewRouter)
                    .environmentObject(viewModel)
                    .environmentObject(userSettings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        .onChange(of: scenePhase) { phase in
            persistenceController.save(forDeletion: false)
            guard let _window = window else { return }
            switch phase {
            case .active:
                PrivateMultitaskImage.unblurPresentedView(window: _window)
            case .background:
                PrivateMultitaskImage.blurPresentedView(window: _window)
            case .inactive:
                PrivateMultitaskImage.blurPresentedView(window: _window)
            @unknown default:
                break
            }
        }
    }    
}



