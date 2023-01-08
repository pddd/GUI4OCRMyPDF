//
//  MultiSelectionView.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 22.12.22.
//

import SwiftUI

struct MultiSelectionView: View {
    let options: [String:String]
    let optionToString: (String) -> String
    
    @Binding var selected: [String]
    
    var body: some View {
        //        VStack {
        //            Spacer()
        //            HStack {
        //                List {
        //                    ForEach(options.sorted(by: >), id: \.key) { opt in
        //                        Button(action: { toggleSelection(key: opt.key) }) {
        //                            HStack {
        //                                Spacer()
        //                                Text(optionToString(opt.key))
        //
        //                                if selected.contains { $0 == opt.key } {
        //                                    Image(systemName: "checkmark").foregroundColor(.accentColor)
        //
        //                                }
        //                                Spacer()
        //                            }.scaledToFit()
        //                        }.buttonStyle(.link)
        //
        //                    }
        //                }.listStyle(.inset)
        //                    .scaledToFit()
        //
        //            }.scaledToFit()
        //            Spacer()
        //        }
        //GroupBox(label:Label("OCR Languages Options", systemImage: "globe").font(Font.headline)) {
        Text("OCR Languages Options").font(.headline)
        Form {
            
            ForEach(options.sorted(by: >), id: \.key) { opt in
                Toggle(optionToString(opt.key), isOn: Binding(
                    get: { return selected.contains { $0 == opt.key } },
                    set: { newValue in toggleSelection(append: newValue, key:opt.key) }) )
                .toggleStyle(.switch)
            }
            
        }
        
        // }
        
    }
    
    //    private func toggleSelection(key: String) {
    //        if let existingIndex = selected.firstIndex(where: { $0 == key }) {
    //            selected.remove(at: existingIndex)
    //        } else {
    //            selected.append(key)
    //        }
    //    }
    
    private func toggleSelection(append: Bool, key: String) {
        if append {
            selected.append(key)
        } else {
            selected.removeAll(where: {$0 == key})
        }
    }
}

struct MultiSelectionView_Previews: PreviewProvider {
    
    @State static var selected = ["pol"]
    
    static var previews: some View {
        NavigationStack {
            MultiSelectionView(
                options: ["deu":"Deutsch", "eng": "English", "pol":"Polish","nld":"Dutch"],
                optionToString: { OCRLanguageOptions.languages[$0] ?? OCRLanguageOptions.defaultLanguage },
                selected: $selected
            )
        }.frame(width: 400, height: 300, alignment: .center)
    }
}
