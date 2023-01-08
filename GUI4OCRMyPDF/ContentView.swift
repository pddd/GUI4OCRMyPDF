//
//  ContentView.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 14.12.22.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    
    @ObservedObject var ocrTask: OCRTask
    @State private var taskOutput = ""
    @State private var expandedResult = false
    
    
    private let settingsIcon = "gearshape.fill"
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            
            OCRButton(ocrTask: ocrTask)
            
            GroupBox(label:
                        Label("OCR Settings", systemImage: settingsIcon)
            ) {
                GeneralSettingsView()
            }.disabled(ocrTask.lockedSettings)
            
            DisclosureGroup("Output", isExpanded: $expandedResult) {
                ScrollViewReader { scrollView in
                    ScrollView {
                        Text(ocrTask.output).id("Result Text")
                            .onReceive(ocrTask.$output) { output in
                                //taskOutput = output
                                withAnimation{
                                    scrollView.scrollTo("Result Text",anchor: UnitPoint.bottom)
                                }
                            }
                    }
                }.frame(minHeight: 50.0, maxHeight: 100.0)
                if (ocrTask.processedPdfs.count>0 && !ocrTask.isRunning) {
                    HStackLayout {
                        Button(action: {
                            NSWorkspace.shared.open(ocrTask.processedPdfs[0])
                        }, label: {
                            Text("Open PDF")
                        })
                        Button(action: {
                            NSWorkspace.shared.activateFileViewerSelecting([ocrTask.processedPdfs[0]])
                        }, label: {
                            Text("Show in Finder")
                        })
                    }.id("Result File Buttons")
                }
            }
        }
        .padding()
        .frame(alignment: .top)
    }
}


struct ContentView_Previews: PreviewProvider {
    @StateObject static var ocrTask = OCRTask()
    
    static var previews: some View {
        
        VStack() {
            Header()
            ContentView(ocrTask: ocrTask)
        }.frame(minWidth: 400, idealWidth: 400, maxWidth: .infinity, minHeight: 330, idealHeight: 330, maxHeight: .infinity, alignment: .top)
            .environment(\.sizeCategory, .medium)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: 460))
            .previewDisplayName("App")
        
        
    }
}
