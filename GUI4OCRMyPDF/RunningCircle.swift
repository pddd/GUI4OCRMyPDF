//
//  RunningCircle.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 01.01.23.
//

import SwiftUI

struct RunningCircle: View {
    //@State private var rotate = false
    @State private var rotationAngle = 0.0
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .rotationEffect(Angle(degrees: rotationAngle))
            .onAppear(){
                withAnimation(Animation.default.repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
        //Same effect as above, but less understandable for me
        //            .rotationEffect(Angle(degrees: rotate ? 360 : 0))
        //            .animation(Animation.default.repeatForever(autoreverses: false), value: rotate)
        //            .onAppear() {
        //                self.rotate = true
        //            }
    }
}

struct RunningCircle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RunningCircle()
            
        }.padding()
            .frame(height: 50)
        
    }
}
