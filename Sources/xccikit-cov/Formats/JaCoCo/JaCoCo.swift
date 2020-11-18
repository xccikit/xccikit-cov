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
        let doc = XMLDocument(rootElement: xmlElement)
        doc.isStandalone = true
        doc.version = "1.0"
        return doc
    }
    
    var xmlElement: XMLElement {
        let elem = XMLElement(name: "report", attributes: [
            "name": name
        ], children: [
            sessionInformation
        ])
        
        if !packages.isEmpty {
            elem.addChild(XMLElement(name: "packages", children: packages))
        }

        return elem
    }

    var groups = [Group]()
    var packages = [Package]()
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

            var methods: [Method] = []
            var counters: [Counter] = []

            var xmlElement: XMLElement {
                let elem = XMLElement(name: "class", attributes: [
                    "name": name,
                    "sourcefilename": sourceFileName
                ])

                elem.addChildren(counters)
                elem.addChildren(methods)

                return elem
            }
            
            struct Method: XMLElementProtocol {
                var name: String
                var description: String
                var line: UInt
                var counters: [Counter] = []

                var xmlElement: XMLElement {
                    .init(name: "method", attributes: [
                        "name": name,
                        "desc": description,
                        "line": String(line)
                    ], children: counters)
                }
            }
        }
    }
    
    struct Counter: XMLElementProtocol {
        var missed: UInt
        var covered: UInt
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
                "covered": String(covered),
                "missed": String(missed)
            ])
        }
    }
    
    struct SourceFile: XMLElementProtocol {
        var name: String
        var lines: [Line] = []
        var counters: [Counter] = []

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
