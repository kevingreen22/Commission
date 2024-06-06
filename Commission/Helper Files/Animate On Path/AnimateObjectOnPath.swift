//
//  AnimationObjectOnPath.swift
//  Commission
//
//  Created by Kevin Green on 5/18/21.
//

import SwiftUI
import Combine

class AnimateObjectOnPath: ObservableObject {
    @Published var alongTrackDistance = CGFloat.zero
    var size: CGSize
    var track: ParametricCurve
    var path: Path
    var color: Color
    var withRotation: Bool
    
    var object: some View {
        let t = track.curveParameter(arcLength: alongTrackDistance)
        let p = track.point(t: t)
        let dp = track.derivate(t: t)
        let h = Angle(radians: atan2(Double(dp.dy), Double(dp.dx)))
        return ServiceGridPlaceHolderForAnimation(size: size, color: color)
            .rotationEffect(withRotation ? h : Angle(degrees: 0))
            .position(p)
//        return Text("􀑓").font(.largeTitle).rotationEffect(h).position(p)
    }
    
    init(from: CGPoint, to: CGPoint, control1: CGPoint, control2: CGPoint, size: CGSize = CGSize(width: 100, height: 100), color: Color? = .blue, rotation rotateToFollowPath: Bool? = false) {
        track = Bezier3(from: from, to: to, control1: control1, control2: control2)
        path = Path({ (path) in
            path.move(to: from)
            path.addCurve(to: to, control1: control1, control2: control2)
        })
        self.size = size
        self.color = color ?? .blue
        self.withRotation = rotateToFollowPath ?? false
    }
    
    init() {
        track = Bezier3(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: 0), control1: CGPoint(x: 0, y: 0), control2: CGPoint(x: 0, y: 0))
        path = Path({ (path) in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addCurve(to: CGPoint(x: 0, y: 0), control1: CGPoint(x: 0, y: 0), control2: CGPoint(x: 0, y: 0))
        })
        self.size = CGSize(width: 100, height: 100)
        self.color = .blue
        self.withRotation = false
    }
    
    
    
    
    @Published var animating = false
    var timer: Cancellable? = nil

    func animate() {
        animating = true
        timer = Timer
            .publish(every: 0.02, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { _ in
                self.alongTrackDistance += self.track.totalArcLength / 20.0
                self.size.width -= self.track.totalArcLength / 10.0
                self.size.height -= self.track.totalArcLength / 10.0
                if self.alongTrackDistance > self.track.totalArcLength {
                    self.timer?.cancel()
                    self.animating = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.reset()
                    })
                }
            })
    }
    
    func reset() {
        self.size = CGSize(width: 100, height: 100)
        self.alongTrackDistance = .zero
    }
    
}


struct ServiceGridPlaceHolderForAnimation: View {
    var size: CGSize
    var color: Color?
    
    var body: some View {
            Rectangle()
                .frame(width: size.width, height: size.height)
                .foregroundColor(color ?? .blue)
                .cornerRadius(20)
                .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
