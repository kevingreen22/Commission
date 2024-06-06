//
//  OnboardingViews.swift
//  Commission
//
//  Created by Kevin Green on 6/7/21.
//

import SwiftUI

struct OnboardingConstants {
    static var addService = "Tap the \"+\" to create a new service."
    static var archive = "Tap to view archives."
    static var account = "Tap to view or edit profile info."
    static var service = "Tap a service to add it as a performed service."
    static var currentPerfServ = "Tap to view all currently performed services."
}

struct OnboardingAddNewService: View {
    var body: some View {
        let size = CGSize(width: 200, height: 90)
        InfoDialog(parentSize: size, direction: .rightTop, withCornerRadius: true) {
            HStack {
                Text(OnboardingConstants.addService)
                    .lineLimit(nil)
                    .foregroundColor(.black)
            }.padding()
        }
        .frame(width: size.width, height: size.height)
        .foregroundColor(Color.white)
    }
}



struct OnboardingViewArchive: View {
    var body: some View {
        let size = CGSize(width: 200, height: 80)
        InfoDialog(parentSize: size, direction: .rightTop, withCornerRadius: true) {
            HStack {
                Text(OnboardingConstants.archive)
                    .lineLimit(nil)
                    .foregroundColor(.black)
            }.padding()
        }
        .frame(width: size.width, height: size.height)
        .foregroundColor(Color.white)
    }
}



struct OnboardingViewAccount: View {
    var body: some View {
        let size = CGSize(width: 200, height: 80)
        InfoDialog(parentSize: size, direction: .leftTop, withCornerRadius: true) {
            HStack {
                Text(OnboardingConstants.account)
                    .lineLimit(nil)
                    .foregroundColor(.black)
            }.padding()
        }
        .frame(width: size.width, height: size.height)
        .foregroundColor(Color.white)
    }
}



struct OnboardingService: View {
    var direction: PopoutPointerDirection
    
    var body: some View {
        let size = CGSize(width: 200, height: 100)
        VStack {
            InfoDialog(parentSize: size, direction: direction, withCornerRadius: true) {
                HStack {
                    Text(OnboardingConstants.service)
                        .lineLimit(nil)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }.padding()
            }
            .frame(width: size.width, height: size.height)
            .foregroundColor(Color.white)
        }
    }
}


struct OnboardingCurrentPerfServ: View {
    var body: some View {
        let size = CGSize(width: 200, height: 100)
        InfoDialog(parentSize: size, direction: .topMid, withCornerRadius: true) {
            HStack {
                Text(OnboardingConstants.currentPerfServ)
                    .lineLimit(nil)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }.padding()
        }
        .frame(width: size.width, height: size.height)
        .foregroundColor(Color.white)
    }
}







