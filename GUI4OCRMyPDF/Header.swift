//
//  Header.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 01.01.23.
//

import SwiftUI

struct Header: View {
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(/*@START_MENU_TOKEN@*/"Header.svg"/*@END_MENU_TOKEN@*/)
                        .resizable(resizingMode: .stretch)
                        .frame(height: 50, alignment: .top)
                }
                Spacer()
            }
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image("HeaderImage.svg")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 75, alignment: .top)
                    
                }
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        }.frame(height: 95, alignment: .top)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
