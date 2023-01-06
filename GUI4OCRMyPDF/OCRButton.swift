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
                }
            )
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
            .controlSize(.large)
            .shadow(radius: 10)
            .disabled(ocrTask.lockedSettings)
            .frame(height: 50)
            .transition(.asymmetric(insertion: AnyTransition.scale(scale: 0.05), removal: AnyTransition.scale(scale: 0.05)))
            .animation(.easeIn(duration: 0.5), value: ocrTask.isRunning)
            
        } else {
                //ProgressView()
                RunningCircle()
                    .frame(height: 50)
                    .transition(.asymmetric(insertion: AnyTransition.scale(scale: 0.05), removal: AnyTransition.scale(scale: 0.05)))
                    .animation(.easeIn(duration: 0.5), value: ocrTask.isRunning)
        }
    }
    
    
    
    
}

struct OCRButton_Previews: PreviewProvider {
    @StateObject static var ocrTaskState = OCRTask()
    
    static var previews: some View {
        
        OCRButton(ocrTask: ocrTaskState)
    }
}
