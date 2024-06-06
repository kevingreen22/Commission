//
//  EmailHelper.swift
//  Comish
//
//  Created by Kevin Green on 10/24/20.
//

import MessageUI
import SwiftUI

struct EmailHelper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @State var subject: String = ""
    @State var body: String = ""
    @State var to: String = ""
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<EmailHelper>) -> MFMailComposeViewController {
        let picker = MFMailComposeViewController()
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([to])
        picker.mailComposeDelegate = context.coordinator
        
        return picker
    }
 
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<EmailHelper>) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: EmailHelper
        
        init(_ parent: EmailHelper) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
