//
//  KGProgressBar.swift
//  Comish
//
//  Created by Kevin Green on 3/8/21.
//

import SwiftUI

struct KGProgressBar: View {
    @Binding var value: Float
    var total: Float
    @State var height: CGFloat = 20
    @State var color = Color.blue
    @State var backgroundColor = Color.gray
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                Capsule()
                    .frame(width: geo.size.width , height: height)
                    .foregroundColor(backgroundColor)
                    .animation(.easeIn)
                
                Capsule()
                    .frame(
                        width: total == 0 ? geo.size.width : CGFloat((value / total)) * geo.size.width,
                        height: height
                    )
                    .foregroundColor(total == 0 ? .gray : color)
                    .animation(.easeIn)
            }
        }
    }
    
    fileprivate func compute(value: Float, total: Float, with width: CGFloat) -> CGFloat {
        return CGFloat((value / total)) * width
    }
    
}



struct KGProgressBar_preview: PreviewProvider {
    
    static var previews: some View {
        KGProgressBar(value: .constant(40), total: 100.0)
    }
}
