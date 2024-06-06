//
//  Bundle.swift
//  Comish
//
//  Created by Kevin Green on 2/13/21.
//

import Foundation
import SwiftUI

extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}

enum BundleInfoType {
    case appName
    case bundleID
    case versionNumber
    case buildNumber
}

struct BundleInfoView: View {
    var bundleInfoType: BundleInfoType
    
    var body: some View {
        var info = ""
        switch bundleInfoType {
        case .appName: info = "App Name: \(Bundle.main.appName)"
        case .bundleID: info = "Bundle ID: \(Bundle.main.bundleId)"
        case .versionNumber: info = "Version: \(Bundle.main.versionNumber)"
        case .buildNumber: info = "Build: \(Bundle.main.buildNumber)"
        }
        
        return HStack {
            Text(info)
                .padding(.leading)
            Spacer()
        }
    }
}
