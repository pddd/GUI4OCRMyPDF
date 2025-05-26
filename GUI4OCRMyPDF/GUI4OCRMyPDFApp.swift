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
    @StateObject private var ocrTask = OCRTask(activateTestMode:false)

    init() {
        let preferredLanguage = Locale.preferredLanguages.first?.prefix(2).lowercased() ?? "en"
        let supportedLanguages = ["en", "de"]

        if supportedLanguages.contains(preferredLanguage) {
            UserDefaults.standard.set([preferredLanguage], forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        }
        UserDefaults.standard.synchronize()
    }
    
    var body: some Scene {
        WindowGroup {
            VStack() {
                Header()
                ContentView(ocrTask: ocrTask)
            }
            .frame(minWidth: 410, idealWidth: 450, maxWidth: .infinity, minHeight: 550, idealHeight: 550, maxHeight: .infinity, alignment: .top)
            .onDrop(of: [UTType.pdf], delegate: ocrTask)
            .onOpenURL(perform: {dropedPdf in ocrTask.runOcrTask(withPdfSource: dropedPdf)})
        }
        
#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}

