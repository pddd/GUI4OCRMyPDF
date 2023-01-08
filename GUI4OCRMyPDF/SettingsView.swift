//
//  SettingsView.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 03.01.23.
//

import SwiftUI

struct SettingsView: View {
    private let settingsIcon = "gearshape.fill"
    
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("OCR Settings", systemImage: settingsIcon)
                }
                .tag(Tabs.general)
            //                AdvancedSettingsView()
            //                    .tabItem {
            //                        Label("Advanced", systemImage: "star")
            //                    }
            //                    .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(width: 375, height: 250)
    }
}

struct GeneralSettingsView: View {
    
    @AppStorage("outputPDFA") var outputPDFA = true
    @AppStorage("inPlace") var inPlace = false
    @AppStorage("correctPageRotation") var correctPageRotation = true
    @AppStorage("redoOCR") var redoOCR = true
    @AppStorage("OCRLanguageOptions") var oOCRLanguageOptions = OCRLanguageOptions()
    
    var body: some View {
        VStack{
            Form() {
                
                Toggle("Output PDF/A:", isOn: $outputPDFA)
                    .toggleStyle(.switch)
                Toggle("In Place:", isOn: $inPlace)
                    .toggleStyle(.switch)
                Toggle("Correct Page Rotation:", isOn: $correctPageRotation)
                    .toggleStyle(.switch)
                Toggle("Redo OCR:", isOn: $redoOCR)
                    .toggleStyle(.switch)
                
                MultiSelector(
                    label: String(localized: "Languages:"),
                    options: OCRLanguageOptions.languages,
                    optionToString: OCRLanguageOptions.optionToLocalizedString,
                    selected: $oOCRLanguageOptions.selected
                )
            }
            HStack () {
                Button(action: resetSettings) {
                    Label("Reset Settings", systemImage: "gearshape.arrow.triangle.2.circlepath")
                        .font(Font.footnote)
                }.buttonStyle(.link)
                
                Spacer()
            }
        }
        
    }
    
    func resetSettings() {
        outputPDFA = true
        inPlace = false
        correctPageRotation = true
        redoOCR = true
        oOCRLanguageOptions.selected = ["eng", "deu"]
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
