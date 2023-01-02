//
//  ProcessShellCommand.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 18.12.22.
//  This will only work, if we disable sandbox

import Foundation
import SwiftUI

class Shell: ObservableObject {
    @Published var output: String = ""
    private let _environmentPath = EnvironmentPath()
    
    func executeOCR(ocrArgs: [String]) async throws -> Void {
        let args = ["-ic","ocrmypdf \(ocrArgs.joined(separator: " "))"]
        try await _execute(command: "/bin/zsh", arguments: args)
    }
    
    private func _execute(command: String, arguments: [String] = []) async throws -> Void {
        
        
        let process = Process()
        process.executableURL = URL(filePath: command)
        process.arguments = arguments
        
        let pipe = Pipe()
        
        var environment = ProcessInfo.processInfo.environment
        environment["PATH"] = _environmentPath.colonJoinedEnvironmentPath
        print(environment["PATH"] ?? "No Path")
        self.output += "PATH = \(environment["PATH"] ?? "") \n"

        process.environment = environment
        
        process.standardOutput = pipe
        process.standardError = pipe
        
        print(command+" "+arguments.joined(separator: " "))
        self.output += "Run Command: \(command) \(arguments.joined(separator: " ")) \n"
        
        pipe.fileHandleForReading.readabilityHandler = { pipe in
            if let pipeDataAsString = String(data: pipe.availableData, encoding: .utf8) {
                if !pipeDataAsString.isEmpty {
                    self.output += pipeDataAsString //= pipeDataAsString//.append(" " + pipeDataAsString)
                    print("----> ouput: \(pipeDataAsString)")
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        
        try process.run()
        process.waitUntilExit()
    }
    
}

struct EnvironmentPath {
    private static let DefaultPaths = "/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/opt/homebrew/bin"
    private var paths: Set<String> = []
    
    init() {
        let defaultPaths = EnvironmentPath.DefaultPaths.split(separator: ":", maxSplits: Int.max, omittingEmptySubsequences: true).map { String($0) }
        let envPaths = EnvironmentPath.getEnvironmentPath().split(separator: ":", maxSplits: Int.max, omittingEmptySubsequences: true).map { String($0) }.filter({ !$0.isEmpty })
        
        paths.formUnion(defaultPaths)
        paths.formUnion(envPaths)
    }
    
    private static func getEnvironmentPath() -> String {
        let environment = ProcessInfo.processInfo.environment
        guard let environmentPath = environment["PATH"] else { return "" }
        return environmentPath
    }
    
    var colonJoinedEnvironmentPath: String {
        return paths.joined(separator: ":")
    }
}
