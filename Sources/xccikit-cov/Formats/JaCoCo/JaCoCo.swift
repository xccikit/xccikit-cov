//
//  JaCoCo.swift
//  xccikit-cov
//
//  Created by Tristian Azuara on 11/13/20.
//

import Foundation

struct JaCoCo: XMLElementProtocol {
    var name: String
    
    var sessionInformation: SessionInfo

    var xmlDocument: XMLDocument {
        XMLDocument(rootElement: xmlElement)
    }
    
    var xmlElement: XMLElement {
        XMLElement(name: "report", attributes: [
            "name": name
        ], children: [
            sessionInformation
        ])
    }
}

extension JaCoCo {
    struct SessionInfo: XMLElementProtocol {
        var id: String
        var startDate: Date
        var dumpDate: Date
        var xmlElement: XMLElement {
            .init(name: "sessioninfo", attributes: [
                "id": id,
                "start": startDate,
                "dump": dumpDate
            ])
        }
    }
}

extension JaCoCo {
    struct Group: XMLElementProtocol {
        var name: String

        var xmlElement: XMLElement {
            .init(name: "group", attributes: ["name": name])
        }
    }
    
    struct Package: XMLElementProtocol {
        var name: String
        
        var classes: [Class]
        var sourceFiles: [SourceFile]
        
        var xmlElement: XMLElement {
            let elem = XMLElement(name: "package", attributes: ["name": name])
            
            if !classes.isEmpty {
                elem.addChildren(classes)
            }
            
            if !sourceFiles.isEmpty {
                elem.addChildren(sourceFiles)
            }
            
            return elem
        }
        
        struct Class: XMLElementProtocol {
            var name: String
            var sourceFileName: String
            
            var counters: [Counter] = []
            var methods: [Method] = []

            var xmlElement: XMLElement {
                .init(name: "class", attributes: [
                    "name": name,
                    "sourcefilename": sourceFileName
                ])
            }
            
            struct Method: XMLElementProtocol {
                var name: String
                var desc: String
                var line: UInt
                var counters: [Counter] = []

                var xmlElement: XMLElement {
                    .init()
                }
            }
        }
        
        struct SourceFile: XMLElementProtocol {
            var xmlElement: XMLElement { .init() }
        }
    }
    
    struct Counter: XMLElementProtocol {
        var missed: String
        var covered: String
        var type: Type
        
        enum `Type`: String {
            case instruction
            case branch
            case line
            case complexity
            case method
            case `class`
        }
        
        var xmlElement: XMLElement {
            .init(name: "counter", attributes: [
                "type": type.rawValue,
                "covered": covered,
                "missed": missed
            ])
        }
    }
    
    struct SourceFile: XMLElementProtocol {
        var name: String
        var lines: [Line] = []
        var counters: [Counter]

        var xmlElement: XMLElement {
            let elem = XMLElement(name: "sourcefile", attributes: [
                "name": name
            ])

            if !lines.isEmpty {
                elem.addChildren(lines)
            }

            if !counters.isEmpty {
                elem.addChildren(counters)
            }
            
            return elem
        }

        struct Line: XMLElementProtocol {
            var number: UInt
            var missedInstructions: String
            var coveredInstructions: String
            var missedBranches: String
            var coveredBranches: String
            
            var xmlElement: XMLElement { .init(name: "line", attributes: [
                "nr": number,
                "mi": missedInstructions,
                "ci": coveredInstructions,
                "mb": missedBranches,
                "cb": coveredBranches
            ]) }
        }
    }
}
