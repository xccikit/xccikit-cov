//
//  XCResultConvertCommon.swift
//  xccikit-cov
//
//  Created by Tristian Azuara on 11/17/20.
//

import Foundation

private let propertyObservers = Set(["getter", "didset", "willset", "setter"])

private func parse(signatureParts string: String) -> [String]? {
    return string.split(separator: " ").map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
    }.filter{
        !$0.isEmpty
    }.first {
        $0.contains(".")
    }?.split(separator: ".").map(String.init)
}

func parse(className string: String) -> String {
    if string.hasSuffix(")") && !string.contains(".") && string.contains(":") {
        return "func"
    }

    let name = parse(signatureParts: string)?.first

    return name != nil ? String(name!) : string
}

func parse(methodSignature string: String) -> String {
    let parts = parse(signatureParts: string)
    
    var name = String(parts?.last ?? "")
    if let parts = parts, propertyObservers.contains(name) {
        name = parts[(parts.count-2)..<parts.count].joined(separator: ".")
    }
    
    return !name.isEmpty ? name : string
}

func parse(methodName string: String) -> String {
    let parts = parse(signatureParts: string)
    var name = String(parts?.last ?? "")
    if let parts = parts, propertyObservers.contains(name) {
        name = parts[(parts.count-2)..<parts.count].joined(separator: ".")
    }
    
    return !name.isEmpty ? name : string
}
