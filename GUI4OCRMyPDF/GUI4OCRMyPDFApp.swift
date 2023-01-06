//
//  GUI4OCRMyPDFApp.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 14.12.22.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct GUI4OCRMyPDFApp: App {
    @StateObject private var ocrTask = OCRTask()
    
    var body: some Scene {
        WindowGroup {
            VStack() {
                Header()
                ContentView(ocrTask: ocrTask)
            }
            .frame(minWidth: 410, idealWidth: 450, maxWidth: .infinity, minHeight: 500, idealHeight: 500, maxHeight: .infinity, alignment: .top)
            .onDrop(of: [UTType.pdf], delegate: ocrTask)
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

