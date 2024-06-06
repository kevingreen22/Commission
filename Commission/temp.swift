//
//  Temp.swift
//  Comish
//
//  Created by Kevin Green on 12/4/20.
//

import SwiftUI

struct Temp : View {
    @State var isShowPhotoLibrary: Bool = false
    @State private var image: Image = Image("avatar")
    @State private var pickedImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack {
                image
                    .resizable()
                    .frame(width: 300, height: 300)
                
                
                Button("Pick Image") {
                    isShowPhotoLibrary.toggle()
                }
            }
            
            .sheet(isPresented: $isShowPhotoLibrary, onDismiss: loadImage) {
                ImagePicker(selectedImage: $pickedImage, sourceType: .photoLibrary)
            }
        }
    }
    
    func loadImage() {
        if let  inputImage = pickedImage {
            image = Image(uiImage: inputImage)
        }
    }
    
    
}




struct Temp_Preview: PreviewProvider {
    static var previews: some View {
        return Temp()
    }
}
