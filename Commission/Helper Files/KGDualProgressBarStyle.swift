//
//  KGDualProgressBarStyle.swift
//  Commission
//
//  Created by Kevin Green on 6/19/21.
//

import SwiftUI

struct KGDualProgressBarStyle: ProgressViewStyle {
    @Binding var difference: Float
    var labelValue: Text? = nil
    var differenceLabelValue: Text? = nil
    var strokeColor = Color.green
    var strokeColorDifference = Color.red
    var height: CGFloat = 23.0
    
    private var computedHeight: CGFloat {
        guard self.height > 20 else { return 20 }
        return self.height
    }

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return GeometryReader { proxy in
            ZStack(alignment: .center) {
                GeometryReader { proxy in
                    let frac: CGFloat = {
                        let f = (CGFloat(fractionCompleted) * proxy.size.width - CGFloat(difference))
                        if f < 0 {
                            return 0
                        } else {
                            return f
                        }
                    }()
                    
                    Capsule()
                        .frame(width: CGFloat(fractionCompleted) * proxy.size.width, height: computedHeight)
                        .foregroundColor(strokeColorDifference)
                        .animation(.easeInOut)
                    
                    Capsule()
                        .background(
                            LinearGradient(gradient:
                                            Gradient(colors: [.clear, .gray, .clear]), startPoint: .leading, endPoint: .trailing)
                                .clipShape(Capsule())
                                .offset(x: (proxy.size.width * CGFloat(fractionCompleted.asDecimalFromContext()) < 10) ?proxy.size.width * CGFloat(fractionCompleted.asDecimalFromContext()) : 10)
                        )
                        .frame(width: frac,
                               height: height)
                        .foregroundColor(strokeColor)
                        .animation(.easeInOut)
                    
                    if labelValue != nil || differenceLabelValue != nil {
                        HStack {
                            labelValue
                                .foregroundColor(.black)
                                .padding([.leading])
                            
                            Spacer()
                            
                            differenceLabelValue
                                .foregroundColor(.black)
                                .padding([.trailing])
                            
                        }.frame(width: proxy.size.width, height: computedHeight)
                    }
                    
                }
            }.frame(width: proxy.size.width, height: computedHeight)
            
        }
    }
}







struct KGDualProgressBarStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.7, total: 1.0)
            .progressViewStyle(KGDualProgressBarStyle(difference: .constant(0.75)))
    }
}


