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
                action: {
                    ocrTask.locked = true
                    let pdfSourceUrl = self.selectPDF()
                    Task{
                        withAnimation {
                            ocrTask.isRunning = true
                        }
                        await ocrTask.runOcr(pdfSourceUrl: pdfSourceUrl)
                        //ocrTask.output=shellOutput
                        //try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
                        
                        withAnimation {
                            ocrTask.isRunning = false
                            ocrTask.locked = false
                        }
                    }
            },
                label: {
                    Text("Select and OCR my PDF")
                }
            
            )
            .buttonStyle(.borderedProminent)
            //.buttonStyle(FancyOCRButtonStyle())
            .clipShape(Capsule())
            .controlSize(.large)
            .shadow(radius: 10)
            .disabled(ocrTask.locked)
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
    
    private func selectPDF () -> (URL?) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        return panel.runModal() == .OK ? panel.urls.first : nil
    }
    
    
}

//struct FancyOCRButtonStyle: ButtonStyle {
//    @Environment(\.isEnabled) var isEnabled
//    let runningCircle = RunningCircle()
//    var size : CGSize = CGSize()
//    func makeBody(configuration: Configuration) -> some View {
//
//        configuration.label
//            .padding()
//            .background(isEnabled ? .blue : .gray)
//            .foregroundColor(.white)
//            .clipShape(Capsule())
//            .shadow(radius: 10)
//
//    }
//}

struct OCRButton_Previews: PreviewProvider {
    @StateObject static var ocrTaskState = OCRTask()
    
    static var previews: some View {
        
        OCRButton(ocrTask: ocrTaskState)
    }
}
