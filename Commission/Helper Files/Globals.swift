//
//  Globals.swift
//  Comish
//
//  Created by Kevin Green on 10/8/20.
//

// App Icon:  Icons made by <a href="https://www.flaticon.com/authors/monkik" title="monkik">monkik</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

// Account image placeholder: Icons made by <a href="" title="Gregor Cresnar">Gregor Cresnar</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>


import SwiftUI


// String Constants
struct StringConstants {
    static var placeHolderImageName = "avatar"
    static var quickTipGif = "quicktip_gif"
    static var setupNamePlaceHolder = "Enter Name Here"
    static var setupUnivPercPlaceholder = "Enter Your Commission %"
}



// MARK: ActiveSheet Enum
enum ActiveSheet: Identifiable {
    case addService
    case editService(service: Service)
    case showArchive
//    case cropImage
//    case showImagePicker
    
    var id: UUID {
        UUID()
    }
}


// MARK: ActiveFullCover Enum
enum ActiveFullCover: Identifiable {
//    case accountView(_ account: Account)
    case addService
    case editService(_ service: Service)
    case showArchive(_ account: Account)
    
    var id: UUID {
        UUID()
    }
}



