//
//  PrivateMultitaskImage.swift
//  Commission
//
//  Created by Kevin Green on 4/23/21.
//

import SwiftUI

struct PrivateMultitaskImage {
    
    static private var blurViewtag: Int {
        198489
    }
 
    
    static func blurPresentedView(window: UIWindow) {
        // return if blured view with hardcoded tag is added to main window
        if (window.viewWithTag(blurViewtag) != nil){
            return
        }
        
        guard let snapshot = bluredSnapshot(window: window) else { return }
        window.addSubview(snapshot)
    }
    
    // find and remove blured view
    static func unblurPresentedView(window: UIWindow) {
        window.viewWithTag(blurViewtag)?.removeFromSuperview()
    }
    
    static private func bluredSnapshot(window: UIWindow) -> UIView? {
        //take window snapshot
        //and add blurView to it
        guard let snapshot = window.snapshotView(afterScreenUpdates: false) else { return nil }
        snapshot.addSubview(blurView(frame: (snapshot.frame)))
        snapshot.tag = blurViewtag
        return snapshot
    }
    
    static private func blurView(frame: CGRect) -> UIView {
        // iOS 8 and later
        switch UIDevice.current.systemVersion.compare("8.0.0", options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            view.frame = frame
            return view
        //Other
        case .orderedAscending:
            let toolbar = UIToolbar(frame: frame)
            toolbar.barStyle = UIBarStyle.black
            return toolbar
        }
    }
    
}
