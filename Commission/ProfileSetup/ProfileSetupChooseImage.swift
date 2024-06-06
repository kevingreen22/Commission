//
//  ProfileSetupChooseImage.swift
//  Commission
//
//  Created by Kevin Green on 5/28/21.
//

import SwiftUI

struct ProfileSetupChooseImage: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        ZStack {
            ColorManager.mainBackgroundGradient.ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("Account Image")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                ZStack {
                    if let _image = vm.pickedImage {
                        Image(uiImage: _image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .background(Color.gray)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .shadow(color: Color.secondary, radius: 4, x: 0, y: 5)
                    } else {
                        Image(StringConstants.placeHolderImageName)
                            .resizable()
                            .background(Color.gray)
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .shadow(color: Color.secondary, radius: 4, x: 0, y: 5)
                    }
                } // End ZStack
                
                HStack {
                    Spacer()
                    Button("Choose") {
                        withAnimation {
                            vm.isShowPhotoLibrary = true
                            vm.shouldShowNextButton = true
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    
                    Spacer()
                    
                    Button("Skip") {
                        // go to next profile setup page
                        viewRouter.currentPage = .profileSetupUniversalPercent
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    
                    Spacer()
                }
                
                
                
                if vm.shouldShowNextButton {
                    Button("Next") {
                        print("Next button tapped")
                        // go to next profile setup page
                        withAnimation {
                            viewRouter.currentPage = .profileSetupQuickTip
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title)
                    .offset(y: 20)
                    .animation(.easeInOut(duration: 0.3))
                }
                
                Spacer()
            }
            
        }
        
        .transition(AnyTransition.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.3))
        
        .sheet(isPresented: $vm.isShowPhotoLibrary) {
            ImagePicker(selectedImage: $vm.pickedImage, sourceType: .photoLibrary)
        }
    }
}

struct ProfileSetupChooseImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupChooseImage()
    }
}
