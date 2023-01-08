//
//  OCRButton.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 01.01.23.
//

import SwiftUI

struct OCRButton: View {
    
    @ObservedObject var ocrTask: OCRTask
    
    var body: some View {
        if(!ocrTask.isRunning){
            Button(
                action: {ocrTask.selectFileAndRunOcrTask()},
                label: {
                    Text("Select and OCR my PDF")
                        .padding(.all)
                }
            )
            .transition(.asymmetric(insertion: AnyTransition.scale(scale: 0.2), removal: AnyTransition.scale(scale: 0.05)))
            .clipShape(Capsule())
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .shadow(radius: 10)
            .disabled(ocrTask.lockedSettings)
            .frame(width: 280, height: 50)
            //.transition(.slide)
            
            //.animation(.easeIn(duration: 0.5), value: ocrTask.isRunning)
            
            
        } else {
            //ProgressView()
            RunningCircle()
                .frame(height: 50)
                .transition(.asymmetric(insertion: AnyTransition.scale(scale: 0.05), removal: AnyTransition.scale(scale: 0.05)))
                .animation(.easeIn(duration: 0.5), value: ocrTask.isRunning)
        }
    }
    
    
    
    
}

//typealias ButtonStyleClosure<A: View, B: View> = (ButtonStyleConfiguration, A) -> B
//
//precedencegroup ForwardComposition {
//    associativity: left
//}

//infix operator >>>: ForwardComposition
//
//func >>> <A: View, B: View, C: View>(
//    _ f: @escaping ButtonStyleClosure<A, B>,
//    _ g: @escaping ButtonStyleClosure<B, C>
//) -> ButtonStyleClosure<A, C> {
//    return { configuration, a in
//        g(configuration, f(configuration, a))
//    }
//}
//
//struct ComposableButtonStyle<B: View>: ButtonStyle {
//    let buttonStyleClosure: ButtonStyleClosure<ButtonStyleConfiguration.Label, B>
//
//    init(_ buttonStyleClosure: @escaping ButtonStyleClosure<ButtonStyleConfiguration.Label, B>) {
//        self.buttonStyleClosure = buttonStyleClosure
//    }
//
//    func makeBody(configuration: Configuration) -> some View {
//        return buttonStyleClosure(configuration, configuration.label)
//    }
//}
//
//extension View {
//    func composableStyle<B: View>(_ buttonStyleClosure: @escaping ButtonStyleClosure<ButtonStyleConfiguration.Label, B>) -> some View {
//        return self.buttonStyle(ComposableButtonStyle(buttonStyleClosure))
//    }
//}

struct OCRButton_Previews: PreviewProvider {
    @StateObject static var ocrTaskState = OCRTask()
    
    static var previews: some View {
        
        OCRButton(ocrTask: ocrTaskState)
    }
}
