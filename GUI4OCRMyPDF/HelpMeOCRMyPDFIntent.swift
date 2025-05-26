//
//  HelpMeOCRMyPDFIntent.swift
//  HelpMeOCRMyPDFIntent
//
//  Created by Przemyslaw Dul on 05.02.23.
//

import AppIntents
import SwiftUI
import GUI4OCRMyPDF

struct HelpMeOCRMyPDFIntent: AppIntent {
    static var title: LocalizedStringResource = "Help me ocr my PDF"
    
    static var description = IntentDescription("Runs OCR on your pdf")
    
    @StateObject private var ocrTask = OCRTask(activateTestMode:false)
    
    @Parameter(title: "Source PDF")
    var sourcePDF: URL
    
    func perform() async throws -> some IntentResult {
        await ocrTask.runOcrTask(withPdfSource: sourcePDF)
        return .result()
    }
}
