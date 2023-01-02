//
//  GUI4OCRMyPDFApp.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 14.12.22.
//

import SwiftUI

@main
struct GUI4OCRMyPDFApp: App {
    var body: some Scene {
        WindowGroup {
            VStack() {
                Header()
                ContentView()
            }.frame(minWidth: 410, idealWidth: 450, maxWidth: .infinity, minHeight: 500, idealHeight: 500, maxHeight: .infinity, alignment: .top)
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

