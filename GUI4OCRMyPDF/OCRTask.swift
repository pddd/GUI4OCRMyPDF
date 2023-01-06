//
//  OCRTask.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 01.01.23.
//

import SwiftUI
import DequeModule
import UniformTypeIdentifiers

@MainActor
class OCRTask: ObservableObject, DropDelegate {
    
    @Published var isRunning = false
    @Published var lockedSettings = false
    
    @AppStorage("outputPDFA") var outputPDFA = true
    @AppStorage("inPlace") var inPlace = false
    @AppStorage("correctPageRotation") var correctPageRotation = true
    @AppStorage("redoOCR") var redoOCR = true
    @AppStorage("OCRLanguageOptions") var oOCRLanguageOptions = OCRLanguageOptions()
    
    @Published var output : String = ""
    
    var processedPdfs: Deque<URL> = []
    
    func selectFileAndRunOcrTask() {
        lockedSettings = true
        let pdfSourceUrl = self.selectPDF()
        runOcrTask(withPdfSource: pdfSourceUrl)
    }
    
    func runOcrTask(withPdfSource: URL?) {
        Task {
            withAnimation {
                lockedSettings = true
                isRunning = true
            }
            await runOcr(pdfSourceUrl: withPdfSource)
            //try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
            
            withAnimation {
                isRunning = false
                lockedSettings = false
            }
        }
    }
    
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
    
    private func optionsToShellArgs(pdfSourceUrl: URL?) -> [String] {
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
    
    private func targetUrl(sourceUrl: URL, inPlace: Bool) -> URL {
        var targetUrl = sourceUrl//URL(from: sourceUrl)//URL(string: sourceUrl.path(percentEncoded:true))!
        if (!inPlace) {
            let sourceExtension = sourceUrl.pathExtension
            let sourceName = sourceUrl.deletingPathExtension().lastPathComponent
            targetUrl = sourceUrl.deletingPathExtension().deletingLastPathComponent().appending(path: sourceName+" ocr").appendingPathExtension(sourceExtension)
        }
        return targetUrl
    }
    
    private func selectPDF () -> (URL?) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        return panel.runModal() == .OK ? panel.urls.first : nil
    }
    
    func performDrop(info dropInfo: DropInfo) -> Bool {
        guard dropInfo.hasItemsConforming(to: [UTType.pdf]) else {
            return false
        }
        
        let items = dropInfo.itemProviders(for: [UTType.pdf])
        //        _ = items.first?.loadInPlaceFileRepresentation(forTypeIdentifier: UTType.pdf.identifier, completionHandler: { url,success,error  in
        //            print(url!)
        //        })
        _ = items.first?.loadFileRepresentation(for: UTType.pdf, openInPlace: true) { [self] withDropedPdfSource,success,error in
            Task { @MainActor in
                withAnimation {
                    lockedSettings = true
                    isRunning = true
                }
                await runOcr(pdfSourceUrl: withDropedPdfSource)
                //try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
                
                withAnimation {
                    isRunning = false
                    lockedSettings = false
                }
            }
        }
        
        return true
    }
}
