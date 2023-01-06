//
//  MultiSelector.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 22.12.22.
//

import SwiftUI

struct MultiSelector: View {
    let label: String
    let options: [String:String]
    let optionToString: (String) -> String
    
    var selected: Binding<[String]>
    
    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0)})
    }
    
    @State private var showLanguageSheet = false
    var body: some View {
        LabeledContent(label) {
            Button(action: {
                showLanguageSheet.toggle()
                
            }) {
                Text(formattedSelectedListString)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .allowsTightening(true)
                    .truncationMode(Text.TruncationMode.tail)
                    .frame(maxWidth: 150)
                    .padding(2)
            }
            .sheet(isPresented: $showLanguageSheet) {
                VStack (alignment: .center){
                    multiSelectionView().padding().frame(alignment: .center)
                    Button("Select OCR Language Options",
                           action: { showLanguageSheet.toggle() })
                    .padding()
                }.frame(alignment: .center)
            }
            .buttonStyle(FancyButtonStyle())
        }
    }

    private func multiSelectionView() -> some View {
        MultiSelectionView(
            options: options,
            optionToString: optionToString,
            selected: selected
        )
    }
}

struct FancyButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    private let backgroundColor = Color(NSColor.controlColor)
    private let foregroudColor = Color(NSColor.controlTextColor)
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroudColor)
            .opacity(configuration.isPressed || !isEnabled ? 0.3 : 1.0)
            .background(configuration.isPressed || !isEnabled ? backgroundColor.opacity(0.5) : backgroundColor)
            .cornerRadius(5)
            .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
    }
}

struct MultiSelector_Previews: PreviewProvider {

    @State static var selected = ["eng","pol","deu","nld"]

    static var previews: some View {
        
        MultiSelector(
            label: String(localized: "Languages:"),
            options: OCRLanguageOptions.languages,
            optionToString: OCRLanguageOptions.optionToLocalizedString,
            selected: $selected
        )
        
    }
}
