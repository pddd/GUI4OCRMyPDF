//
//  Languages.swift
//  GUI4OCRMyPDF
//
//  Created by Przemyslaw Dul on 22.12.22.
//

import Foundation

struct OCRLanguageOptions: RawRepresentable {
    
    static let languages = [
        "eng": String(localized: "English"),
        "deu": String(localized: "German"),
        "pol": String(localized: "Polish"),
        "nld": String(localized: "Dutch"),
    ]
    
    static let defaultLanguage = "eng"
    
    var selected = ["eng", "deu"]
    
    func joinSelectedLanguagesForCommandArgs() -> String {
        let joined = selected.joined(separator: "+")
        return joined
    }
    
    func isNotEmpty() -> Bool {
        return !selected.isEmpty
    }
    
    static func optionToLocalizedString(key: String) -> String {
        return languages[key] ?? OCRLanguageOptions.defaultLanguage
    }
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([String].self, from: data)
        else {
            selected = ["eng", "deu"]
            return
        }
        selected = result
        
    }
    
    public init() {
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(selected),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
}

//extension Array: RawRepresentable where Element: Codable {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8),
//              let result = try? JSONDecoder().decode([Element].self, from: data)
//        else {
//            return nil
//        }
//        self = result
//    }
//
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let result = String(data: data, encoding: .utf8)
//        else {
//            return "[]"
//        }
//        return result
//    }
//}
