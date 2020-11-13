//
//  CoberturaTests.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/12/20.
//

import Foundation
import XCTest

final class CoberturaTests: XCTestCase {
    func test_000_empty_document() throws {
        let cob = Cobertura(timestamp: Date(), version: "1.0",
                            coverage: .init(branchRate: 1.0, lineRate: 1.0, complexity: 0.0))
        
        print(cob.xmlElement.xmlString)
    }
    
    static var allTests = [
        ("test_000_empty_document", test_000_empty_document),
    ]
}
