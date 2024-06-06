//
//  ProfileSetup.swift
//  Comish
//
//  Created by Kevin Green on 2/20/21.
//

import SwiftUI

struct ProfileSetupName: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    
    var body: some View {
        ZStack {
            ColorManager.mainBackgroundGradient.ignoresSafeArea()

            VStack(alignment: .center) {
                Text("Profile Setup")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                
                // Name TextField
                TextField("", text: $vm.accountName) { isEditing in
                    vm.isEditing = isEditing
                    vm.namePlaceholderText = ""
                }
                
                onCommit: {
                    print("Name textField committed")
                }
                .placeHolder(Text(vm.namePlaceholderText), show: vm.accountName.isEmpty, alignment: .center)
                .multilineTextAlignment(.center)
                .font(.title)
                .accentColor(.white)
                .foregroundColor(vm.isEditing ? .white : .gray)
                .padding(.bottom, 40)
                
                
                Button("Next") {
                    print("Next button tapped")
                    if vm.validateName {
                        // go to next profile setup page
                        withAnimation {
                            viewRouter.currentPage = .profileSetupChooseImage
                        }
                    }
                }
                .foregroundColor(.white)
                .font(.title)
                .offset(y: 20)
                .animation(.easeInOut(duration: 0.3))
                
                Spacer()
                
            } // End VStack
            
            .gesture(HideKeyboard())
            .transition(AnyTransition.move(edge: .bottom))
            .animation(.easeInOut(duration: 0.3))
            
        } // End ZStack
    } // End Body
} // End ProfileSetup


struct AccountSetup_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupName()
            .environmentObject(ViewModel())
    }
}




