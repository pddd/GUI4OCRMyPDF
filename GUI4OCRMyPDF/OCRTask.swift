//
//  OCRTask.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 01.01.23.
//

import SwiftUI
import DequeModule

@MainActor
class OCRTask: ObservableObject {
    
    @Published var isRunning = false
    @Published var locked = false
    
    @AppStorage("outputPDFA") var outputPDFA = true
    @AppStorage("inPlace") var inPlace = false
    @AppStorage("correctPageRotation") var correctPageRotation = true
    @AppStorage("redoOCR") var redoOCR = true
    @AppStorage("OCRLanguageOptions") var oOCRLanguageOptions = OCRLanguageOptions()
    
    @Published var output : String = ""
    
    var processedPdfs: Deque<URL> = []
    
    
    func runOcr(pdfSourceUrl: URL?) async -> Void {
        guard pdfSourceUrl != nil else {
            return
        }
        
        let shell = Shell()
        shell.$output.receive(on: DispatchQueue.main).assign(to: &$output)
        
//        let shell = Shell(outputHandler: { pipe in
//            if let pipeDataAsString = String(data: pipe.availableData, encoding: .utf8) {
//                if !pipeDataAsString.isEmpty {
//                    DispatchQueue.main.async {
//
//                        //self.output.append(contentsOf: " " + pipeDataAsString)
//
//                        self.output += pipeDataAsString
//
//                    }
//
//                    print("----> ouput: \(pipeDataAsString)")
//                }
//            } else {
//                print("Error decoding data: \(pipe.availableData)")
//            }
//        })
        
        do {
            try await shell.executeOCR(ocrArgs: optionsToShellArgs(pdfSourceUrl: pdfSourceUrl))
            processedPdfs.prepend(targetUrl(sourceUrl: pdfSourceUrl!, inPlace: inPlace))
            if (processedPdfs.count>10) {
                processedPdfs.removeLast()
            }
        } catch {
            print(error)
        }
    
    }
    
    func optionsToShellArgs(pdfSourceUrl: URL?) -> [String] {
        var args : [String] = []
        
        guard let sourceUrl = pdfSourceUrl else {
            return args
        }
        
        if (oOCRLanguageOptions.isNotEmpty()) {
            args.append("-l "+oOCRLanguageOptions.joinSelectedLanguagesForCommandArgs())
        }
        
        if (redoOCR) {
            args.append("--redo-ocr")
        }
        
        if (!outputPDFA) {
            args.append("--output-type pdf")
        }
        
        if (!correctPageRotation) {
            args.append("--rotate-pages")
        }
        
            
        let targetUrl = targetUrl(sourceUrl: sourceUrl, inPlace: inPlace)
        
        args.append("'\(sourceUrl.path(percentEncoded: false))'")
        args.append("'\(targetUrl.path(percentEncoded: false))'")
        
        
        
        return args
    }
    
    func targetUrl(sourceUrl: URL, inPlace: Bool) -> URL {
        var targetUrl = sourceUrl//URL(from: sourceUrl)//URL(string: sourceUrl.path(percentEncoded:true))!
        if (!inPlace) {
            let sourceExtension = sourceUrl.pathExtension
            let sourceName = sourceUrl.deletingPathExtension().lastPathComponent
            targetUrl = sourceUrl.deletingPathExtension().deletingLastPathComponent().appending(path: sourceName+" ocr").appendingPathExtension(sourceExtension)
        }
        return targetUrl
    }
}
