//
//  XCResultToCobertura.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/13/20.
//

import Foundation

func cobertura(from xcresult: XCResultCov, timestamp: Date = Date()) -> Cobertura {
    var cob = Cobertura(timestamp: timestamp, version: "1.0",
                        coverage: .init(branchRate: 0,
                                        lineRate: xcresult.lineCoverage,
                                        complexity: 0))
    cob.sources.append(contentsOf: xcresult.targets.map {
        $0.files
    }.reduce([], {$0 + $1}).map {
        $0.path
    })

    cob.packages.append(contentsOf: xcresult.targets.map {
        var pkg = CoberturaPackage(name: $0.name,
                                coverage: convert(fromXCResultCommon: xcresult))
        pkg.classes.append(contentsOf: $0.files.map(classes(from:)).reduce([]) { $0 + $1 })
        return pkg
    })
    
    return cob
}

func convert(fromXCResultCommon xcresult: XCResultCovCommon) -> Cobertura.Coverage {
    .init(branchRate: 0.0, lineRate: xcresult.lineCoverage, complexity: 0.0)
}

private func classes(from xcresult: XCResultCovFile) -> [CoberturaClass] {
    var classes = [String : CoberturaClass]()
    for function in xcresult.functions {
        let className = parseClassName(function.name)
        var `class` = classes[className, default: CoberturaClass(name: className,
                                        filename: xcresult.path,
                                        coverage: .init(branchRate: 0.0, lineRate: xcresult.lineCoverage,
                                                        complexity: 0.0), methods: [])]
        
        let methodNameAndSignature = parseMethodName(function.name)
        `class`.methods.append(.init(name: methodNameAndSignature,
                                     signature: methodNameAndSignature,
                                     coverage: .init(branchRate: 0.0,
                                                     lineRate: function.lineCoverage,
                                                     complexity: 0.0)))
        classes[className] = `class`
    }

    return Array(classes.values)
}

private func parseClassName(_ string: String) -> String {
    if string.hasSuffix(")") && !string.contains(".") && string.contains(":") {
        return "func" //string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    let name = string.split(separator: " ").map{
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
    }.filter{ !$0.isEmpty }.first {
        $0.contains(".")
    }?.split(separator: ".").first
    
    return name != nil ? String(name!) : string
}

private func parseMethodName(_ string: String) -> String {
    let parts = string.split(separator: " ").map{
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
    }.filter{ !$0.isEmpty }.first {
        $0.contains(".")
    }?.split(separator: ".")
    
    var name = String(parts?.last ?? "")
    if let parts = parts, ["getter", "didset", "willset", "setter"].contains(name) {
        name = parts[(parts.count-2)..<parts.count].joined(separator: ".")
    }
    
    return !name.isEmpty ? name : string
}
