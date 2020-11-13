//
//  XMLExtensions.swift
//  xccikit-cov
//
//  Created by Tristian Azuara on 11/13/20.
//

import Foundation

protocol XMLElementProtocol {
    var xmlElement: XMLElement { get }
}

extension XMLElement: XMLElementProtocol {
    var xmlElement: XMLElement { self }
}

internal extension XMLElement {
    convenience init(name: String, attributes: [AnyHashable : Any] = [:], children: XMLElement...) {
        self.init(name: name)
        setAttributesAs(attributes)
        addChildren(children)
    }
    
    convenience init<S : Sequence>(name: String, attributes: [AnyHashable : Any] = [:],
                                   children: S) where S.Element : XMLElementProtocol {
        self.init(name: name)
        setAttributesAs(attributes)
        addChildren(children)
    }

    func addChildren<Seq : Sequence>(_ sequence: Seq)
        where Seq.Element : XMLElementProtocol {
            sequence.map { $0.xmlElement }.forEach { self.addChild($0) }
    }
}

internal extension Dictionary where Key == AnyHashable, Value == Any {
    func merged(with other: Self) -> Self {
        self.merging(other, uniquingKeysWith: {$1})
    }
}

internal extension XMLNode {
    static func attribute(_ name: String, _ value: CustomStringConvertible) -> XMLNode {
        let node = XMLNode(kind: .attribute, options: .nodeUseDoubleQuotes)
        node.name = name
        node.stringValue = String(describing: value)
        return node
    }
}

internal extension XMLElement {
    func addAttributes(_ nodes: XMLNode...) {
        for node in nodes {
            addAttribute(node)
        }
    }
}

extension String: XMLElementProtocol {
    var xmlElement: XMLElement {
        let textNode = XMLNode(kind: .text)
        textNode.stringValue = self
        let sourceElem = XMLElement(name: "source")
        sourceElem.addChild(textNode)
        return sourceElem
    }
}
