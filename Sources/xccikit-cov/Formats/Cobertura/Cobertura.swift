//
//  Cobertura.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/12/20.
//
import Foundation

struct Cobertura {
    var timestamp: Date
    var version: String
    var coverage: Coverage
    var sources: [String] = []
    var packages: [CoberturaPackage] = []

    var document: XMLDocument { .init(rootElement: xmlElement) }
    
    var xmlElement: XMLElement {
        .init(name: "coverage", attributes: [
            "line-rate": coverage.lineRate,
            "version": version,
            "timestamp": timestamp
        ], children: sourcesElem, packagesElem)
    }
    
    private var sourcesElem: XMLElement { .init(name: "sources", children: sources) }

    private var packagesElem: XMLElement { .init(name: "packages", children: packages) }

    struct Coverage {
        var branchRate: Double
        var lineRate: Double
        var complexity: Double
        
        var xmlAttributes: [AnyHashable : Any] {[
            "line-rate": lineRate,
            "branch-rate": branchRate,
            "complexity": complexity
        ]}
    }
}

struct CoberturaPackage: XMLElementProtocol {
    var name: String
    var coverage: Cobertura.Coverage
    var classes: [CoberturaClass] = []

    var xmlElement: XMLElement {
        .init(name: "package", attributes: ["name": name].merged(with: coverage.xmlAttributes),
              children: XMLElement(name: "classes", children: classes))
    }
}

struct CoberturaClass: XMLElementProtocol {
    var name: String
    var filename: String
    var coverage: Cobertura.Coverage
    var methods: [Method] = []
    
    /// <class name="Main" filename="Main.java" line-rate="1.0" branch-rate="1.0" complexity="1.0">
    var xmlElement: XMLElement {
        let elem = XMLElement(name: "class", attributes: [
            "name": name,
            "filename": filename,
        ].merged(with: coverage.xmlAttributes))

        if !methods.isEmpty {
            elem.addChild(XMLElement(name: "methods", children: methods))
        }

        return elem
    }
    
    struct Method: XMLElementProtocol {
        var name: String
        var signature: String
        var lines: [Line] = []
        var coverage: Cobertura.Coverage
        
        /**
         ```
         <method name="&lt;init&gt;" signature="()V" line-rate="1.0" branch-rate="1.0">
             <lines>
                <line number="10" hits="3" branch="false"/>
             </lines>
         </method>
         ```
         */
        var xmlElement: XMLElement {
            let elem = XMLElement(name: "method", attributes: [
                "name": name,
                "signature": signature,
            ].merged(with: coverage.xmlAttributes))

            if !lines.isEmpty {
                elem.addChild(XMLElement(name: "lines", children: lines))
            }
            
            return elem
        }
        
        /**
         ```
         <line number="23" hits="3" branch="false">
            <conditions>
                <condition number="0" type="jump" coverage="100%"/>
            </conditions>
         </lines>
         ```
         */
        struct Line: XMLElementProtocol {
            var number: UInt
            var hits: UInt
            var branch: Bool = false
            var conditions: [Condition] = []
            
            var xmlElement: XMLElement {
                let elem = XMLElement(name: "line", attributes: [
                    "number": number,
                    "hits": hits,
                    "branch": branch
                ])

                if !conditions.isEmpty {
                    elem.addChild(XMLElement(name: "conditions", children: conditions))
                }
                    
                return elem
            }
            
            struct Condition: XMLElementProtocol {
                var number: UInt
                var coverage: Double
                var type: `Type`
                
                enum `Type`: String {
                    case jump
                }
                
                var xmlElement: XMLElement {
                    XMLElement(name: "condition", attributes: [
                        "number": number,
                        "type": type.rawValue,
                        "coverage": coverage
                    ])
                }
            }
        }
    }
}
