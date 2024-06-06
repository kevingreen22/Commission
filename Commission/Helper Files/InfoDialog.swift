//
//  InfoDialog.swift
//  Commission
//
//  Created by Kevin Green on 6/4/21.
//

import SwiftUI


/// A  dialog box for displaying information with a directional indicator.
///
/// This dialog box is similar to the UIKit version of a popover UIView. You must implement the animation yourself. The main focus of this struct is to have a SwiftUI View where the arrow indicator has different locations for a better visual feel than just a basic alert dialog.
/// The corner radius, if desired, must be confugured in the view's init otherwise adding the cornerRadius modifier to your implementation will break the directional pointer which is the point of this view.
///
/// - Requires: If you use a frame modifier to size this view you must pass that size to the view's init.
///
/// - Parameters
///     - parentSize: The size of the dialog. Default is 200 width, 300 height.
///     - direction: The direction of the dialog pointer. Default is .topMid
///     - pointerSize: The size of the pointer. Default is 30.
///     - withCornerRadius: A boolean value if the view should have rounded corners. Default is false.
///     - radius: The value to apply to the corner radius.
///     - content: The content to place in the dialog box. View
///
/// - Note: To Display multiple lines of text use Text view with .lineLimit(nil) embeded in an HStack.
///
/// # Code
/// ```
/// InfoDialog() {
///     HStack {
///         Text("Long informational text that will span multiple lines and be bound by the size of the dialog popup.")
///             .lineLimit(nil)
///     }
/// }
/// ```
struct InfoDialog<Content: View>: View {
    var parentSize: CGSize = CGSize(width: 200, height: 300)
    var direction: PopoutPointerDirection = .topMid
    var pointerSize: CGFloat = 30.0
    var withCornerRadius = false
    var radius: CGFloat = 5
    var content: () -> Content
    
    var body: some View {
        Rectangle()
            .cornerRadius(withCornerRadius ? radius : 0)
            .overlay(
                Triangle(direction: direction)
                    .frame(width: pointerSize, height: pointerSize)
                    .position(getPosition())
            )
            .overlay(
                content()
                    .frame(width: parentSize.width, height: parentSize.height)
            )
            .frame(width: parentSize.width, height: parentSize.height)
            
    }
    
    fileprivate func getPosition() -> CGPoint {
        var point = CGPoint()
        let halfPointer = pointerSize / 2
        switch direction {
        case .topLeft:
            point = CGPoint(x: halfPointer, y: -halfPointer)
        case .topMid:
            point = CGPoint(x: parentSize.width / 2, y: -halfPointer)
        case .topRight:
            point = CGPoint(x: parentSize.width - halfPointer, y: -halfPointer)
            
        case .bottomLeft:
            point = CGPoint(x: pointerSize / 2, y: parentSize.height + halfPointer)
        case .bottomMid:
            point = CGPoint(x: parentSize.width / 2, y: parentSize.height + halfPointer)
        case .bottomRight:
            point = CGPoint(x: parentSize.width - halfPointer, y: parentSize.height + halfPointer)
            
        case .leftTop:
            point = CGPoint(x: -halfPointer, y: halfPointer)
        case .leftMid:
            point = CGPoint(x: -(pointerSize / 2), y: parentSize.height / 2)
        case .leftBottom:
            point = CGPoint(x: -(pointerSize / 2), y: parentSize.height - pointerSize / 2)
            
        case .rightTop:
            point = CGPoint(x: parentSize.width + (pointerSize / 2), y: pointerSize / 2)
        case .rightMid:
            point = CGPoint(x: parentSize.width + (pointerSize / 2), y: parentSize.height / 2)
        case .rightBottom:
            point = CGPoint(x: parentSize.width + (pointerSize / 2), y: parentSize.height - (pointerSize / 2))
        }
        
        if withCornerRadius {
            switch direction {
            case .topMid, .topLeft, .topRight:
                point.y += radius / 2
            case .bottomMid, .bottomLeft, .bottomRight:
                point.y -= radius / 2
            case .rightTop, .rightMid, .rightBottom:
                point.x -= radius / 2
            case .leftTop, .leftMid, .leftBottom:
                point.x += radius / 2
            }
        }
        
        return point
    }
}


struct InfoPopout_Preview: PreviewProvider {
    static var previews: some View {
        InfoDialog(parentSize: CGSize(width: 200, height: 30), direction: .rightTop, withCornerRadius: true) {
            Text("Popout content").foregroundColor(.black)
        }
        .frame(width: 200, height: 30)
        .foregroundColor(.orange)
    }
}


enum PopoutPointerDirection {
    case topLeft
    case topMid
    case topRight
    
    case bottomLeft
    case bottomMid
    case bottomRight
    
    case leftTop
    case leftMid
    case leftBottom
    
    case rightTop
    case rightMid
    case rightBottom
}



struct Triangle: Shape {
    var direction: PopoutPointerDirection = .leftTop
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch direction {
        case .topLeft, .topMid, .topRight:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            
        case .bottomLeft, .bottomMid, .bottomRight:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.closeSubpath()
            
        case .rightTop, .rightMid, .rightBottom:
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: .zero)
            path.closeSubpath()
            
        case .leftTop, .leftMid, .leftBottom:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
            
        }
        
        return path
    }
}

//struct Triangle_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            Triangle(direction: .top)
//                .previewLayout(.sizeThatFits)
//                .frame(width: 300, height: 300)
//                .foregroundColor(.blue)
//            Triangle(direction: .bottom)
//                .previewLayout(.sizeThatFits)
//                .frame(width: 300, height: 300)
//                .foregroundColor(.blue)
//            Triangle(direction: .right)
//                .previewLayout(.sizeThatFits)
//                .frame(width: 300, height: 300)
//                .foregroundColor(.blue)
//            Triangle(direction: .left)
//                .previewLayout(.sizeThatFits)
//                .frame(width: 300, height: 300)
//                .foregroundColor(.blue)
//        }
//    }
//}


