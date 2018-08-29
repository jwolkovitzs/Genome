//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import Genome

class BasicTypeTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic),
        ("testBasicArrays", testBasicArrays)
    ]

    let BasicTestNode: [String : Node] = [
        "int" : 1,
        "float" : 1.5,
        "double" : 2.5,
        "bool" : true,
        "string" : "hello"
    ]
    
    struct Basic : BasicMappable, CustomStringConvertible {
        private(set) var int = 0
        private(set) var float: Float = 0
        private(set) var double: Double = 0
        private(set) var bool = false
        private(set) var string = ""
        
        mutating func sequence(_ map: Map) throws -> Void {
            let path: [String] = ["int"]
            try int <~> map[path]
            try float <~> map["float"]
            try double <~> map["double"]
            try bool <~> map["bool"]
            try string <~> map["string"]
        }
        
        var description: String {
            return "\(int) : \(float) : \(double) : \(bool) : \(string)"
        }
    }
    
    let BasicArraysTestNode: [String : Node] = [
        "ints" : [1],
        "floats" : [1.5],
        "doubles" : [2.5],
        "bools" : [true],
        "strings" : ["hello"]
    ]
    
    struct BasicArrays : BasicMappable, CustomStringConvertible {
        var ints: [Int] = []
        var floats: [Float] = []
        var doubles: [Double] = []
        var bools: [Bool] = []
        var strings: [String] = []
        
        mutating func sequence(_ map: Map) throws -> Void {
            try ints <~> map["ints"]
            try floats <~> map["floats"]
            try doubles <~> map["doubles"]
            try bools <~> map["bools"]
            try strings <~> map["strings"]
        }
        
        var description: String {
            return "\(ints) : \(floats) : \(doubles) : \(bools) : \(strings)"
        }
    }
    
    func testBasic() throws {
        let basic = try Basic(node: BasicTestNode)
        XCTAssert(basic.int == 1)
        XCTAssert(basic.float == 1.5)
        XCTAssert(basic.double == 2.5)
        XCTAssert(basic.bool == true)
        XCTAssert(basic.string == "hello")
        
        let node = try basic.makeNode()
        let int = node["int"]!.int!
        let float = node["float"]!.float!
        let double = node["double"]!.double!
        let bool = node["bool"]!.bool!
        let string = node["string"]!.string!
        XCTAssert(int == 1)
        XCTAssert(float == 1.5)
        XCTAssert(double == 2.5)
        XCTAssert(bool == true)
        XCTAssert(string == "hello")
    }
    
    func testBasicArrays() throws {
        let basic = try BasicArrays(node: .object(BasicArraysTestNode))
        XCTAssert(basic.ints == [1])
        XCTAssert(basic.floats == [1.5])
        XCTAssert(basic.doubles == [2.5])
        XCTAssert(basic.bools == [true])
        XCTAssert(basic.strings == ["hello"])
        
        let node = try basic.makeNode()
        let ints = node["ints"]!.array!.compactMap { $0.int }
        let floats = node["floats"]!.array!.compactMap { $0.float }
        let doubles = node["doubles"]!.array!.compactMap { $0.double }
        let bools = node["bools"]!.array!.compactMap { $0.bool }
        let strings = node["strings"]!.array!.compactMap { $0.string }
        XCTAssert(ints == [1])
        XCTAssert(floats == [1.5])
        XCTAssert(doubles == [2.5])
        XCTAssert(bools == [true])
        XCTAssert(strings == ["hello"])
    }
}
