//
//  XCResultToJaCoCo.swift
//  xccikit-cov
//
//  Created by Tristian Azuara on 11/13/20.
//

import Foundation

func jacoco(from xcresult: XCResultCov) -> JaCoCo? {
    var report = JaCoCo(
        name: "Coverage Jacoco",
        sessionInformation: .init(id: "Coverage Jacoco",
                                  startDate: Date(),
                                  dumpDate: Date())
    )

    for target in xcresult.targets {
        report.packages.append(JaCoCo.Package(
            name: target.name,
            classes: target.files.map(classes(from:)).reduce([]) {$0 + $1},
            sourceFiles: target.files.map(file(from:))
        ))
    }

    return report
}

/// Converts a XCResultCovFile value to a list of classes.
private func classes(from xcFile: XCResultCovFile) -> [JaCoCo.Package.Class] {
    var classes = [String : JaCoCo.Package.Class]()
    for function in xcFile.functions {
        let className = parse(className: function.name)
        var `class` = classes[
            className,
            default: JaCoCo.Package.Class(name: className, sourceFileName: xcFile.name)
        ]
        
        let methodNameAndSignature = parse(methodSignature: function.name)
        let methodName = parse(methodName: function.name)
        `class`.methods.append(.init(name: methodName,
                                     description: methodNameAndSignature,
                                     line: function.lineNumber)
        )
        classes[className] = `class`
    }
    
    return Array(classes.values)
}

private func file(from xcFile: XCResultCovFile) -> JaCoCo.SourceFile {
    JaCoCo.SourceFile(
        name: xcFile.name,
        lines: [],
        counters: [
            JaCoCo.Counter(missed: xcFile.executableLines - xcFile.coveredLines,
                           covered: xcFile.coveredLines,
                           type: .line)
        ]
    )
}
