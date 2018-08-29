//
//  ToNodeOperatorTest.swift
//  Genome
//
//  Created by Logan Wright on 9/23/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest

@testable import Genome

class ToNodeOperatorTest: XCTestCase {
    static let allTests = [
        ("testMapping", testMapping)
    ]

    struct Employee: BasicMappable, Hashable {
        
        var name: String = ""
        
        mutating func sequence(_ map: Map) throws -> Void {
            try name <~> map["name"]
        }
        
        var hashValue: Int {
            return name.hashValue
        }
        
    }
    
    struct Business: MappableObject {
        
        let name: String
        let foundedYear: Int
        
        let locations: [String]
        let locationsOptional: [String]?
        
        let owner: Employee
        let ownerOptional: Employee?
        
        let employees: [Employee]
        let employeesOptional: [Employee]?
        
        let employeesArray: [[Employee]]
        let employeesOptionalArray: [[Employee]]?
        
        let employeesDictionary: [String : Employee]
        let employeesOptionalDictionary: [String : Employee]?
        
        let employeesDictionaryArray: [String : [Employee]]
        let employeesOptionalDictionaryArray: [String : [Employee]]?
        
        let employeesSet: Set<Employee>
        let employeesOptionalSet: Set<Employee>?
        
        var optionalNil: String?
        var optionalNotNil: String? = "not nil"
        
        init(map: Map) {
            name = try! map.extract("name")
            foundedYear = try! map.extract("founded_in")
            
            locations = try! map.extract("locations")
            locationsOptional = try! map.extract("locations")
            
            let ownerrr: Employee = try! map.extract("owner")
            print("Ownerer: \(ownerrr)")
            owner = try! map.extract("owner")
            ownerOptional = try! map.extract("owner")
            
            employees = try! map.extract("employees")
            employeesOptional = try! map.extract("employees")
            
            employeesArray = try! map.extract("employeesArray")
            employeesOptionalArray = try! map.extract("employeesArray")
            
            employeesDictionary = try! map.extract("employeesDictionary")
            employeesOptionalDictionary = try! map.extract("employeesDictionary")
            
            employeesDictionaryArray = try! map.extract("employeesDictionaryArray")
            employeesOptionalDictionaryArray = try! map.extract("employeesDictionaryArray")
            
            employeesSet = try! map.extract("employees")
            employeesOptionalSet = try! map.extract("employees")
        }
        
        func sequence(_ map: Map) throws -> Void {
            try name ~> map["name"]
            try foundedYear ~> map["foundedYear"]
            
            try locations ~> map["locations"]
            try locationsOptional ~> map["locationsOptional"]
            
            try owner ~> map["owner"]
            try ownerOptional ~> map["ownerOptional"]
            
            try employees ~> map["employees"]
            try employeesOptional ~> map["employeesOptional"]
            
            try employeesArray ~> map["employeesArray"]
            try employeesOptionalArray ~> map["employeesOptionalArray"]
            
            try employeesDictionary ~> map["employeesDictionary"]
            try employeesOptionalDictionary ~> map["employeesOptionalDictionary"]
            
            try employeesDictionaryArray ~> map["employeesDictionaryArray"]
            try employeesOptionalDictionaryArray ~> map["employeesOptionalDictionaryArray"]
            
            try employeesSet ~> map["employeesSet"]
            try employeesOptionalSet ~> map["employeesOptionalSet"]
            
            try optionalNil ~> map["optionalNil"]
            try optionalNotNil ~> map["optionalNotNil"]
        }
    }
    
    let locations: Node = [
        "123 Street",
        "456 Road"
    ]
    
    let employees: Node = [
        ["name" : "Joe"],
        ["name" : "Jane"],
        ["name" : "Joe"],
        ["name" : "Justin"]
    ]
    
    let employeesArray: Node = [
        [["name" : "Joe"], ["name" : "Jane"]],
        [["name" : "Joe"], ["name" : "Justin"]]
    ]
    
    let employeesDictionary: Node = [
        "0" : ["name" : "Joe"],
        "1" : ["name" : "Jane"]
    ]
    
    let employeesDictionaryArray: Node = [
        "0" : [["name" : "Joe"], ["name" : "Phil"]],
        "1" : [["name" : "Jane"]]
    ]
    
    let employeesSet: Node = [
        ["name" : "Joe"],
        ["name" : "Jane"],
        ["name" : "Justin"]
    ]
    
    let owner: Node = [
        "name" : "Owner"
    ]
    
    lazy var businessNode: Node = [
        "owner" : self.owner,
        "name" : "Good Business",
        "founded_in" : 1987,
        "locations" : self.locations,
        "employees" : self.employees,
        "employeesArray" : self.employeesArray,
        "employeesDictionary" : self.employeesDictionary,
        "employeesDictionaryArray" : self.employeesDictionaryArray,
        "employeesSet" : self.employeesSet
    ]
    
    lazy var goodBusiness: Business = try! Business(node: self.businessNode)
    
    func testMapping() {
        let node = try! goodBusiness.makeNode()
        // Basic type
        let name = node["name"]!.string!
        XCTAssert(name == "Good Business", "name is \(name) expected: Good Business")
        let foundedYear = node["foundedYear"]!.int
        XCTAssert(foundedYear == 1987, "foundedYear is \(foundedYear ?? "¯\\_(ツ)_/¯") expected: 1987")
        
        // Basic type array
        let locations = node["locations"]!
        XCTAssert(locations == self.locations, "locations is \(locations) expected: \(self.locations)")
        let locationsOptional = node["locationsOptional"]
        XCTAssert(locationsOptional == self.locations, "locationsOptional is \(locationsOptional ?? "¯\\_(ツ)_/¯") expected: \(self.locations)")
        
        // Mappable
        let owner = node["owner"]!
        XCTAssert(owner == self.owner, "owner is \(owner) expected: \(self.owner)")
        let ownerOptional = node["ownerOptional"]
        XCTAssert(ownerOptional == self.owner, "ownerOptional is \(ownerOptional ?? "¯\\_(ツ)_/¯") expected: \(self.owner)")
        
        // Mappable array
        let employees = node["employees"]!
        XCTAssert(employees == self.employees, "employees is \(employees) expected: \(self.employees)")
        let employeesOptional = node["employeesOptional"]
        XCTAssert(employeesOptional == self.employees, "employeesOptional is \(employees) expected: \(self.employees)")
        
        // Mappable array of arrays
        let employeesArray = node["employeesArray"]!
        XCTAssert(employeesArray[0] == self.employeesArray[0], "employeesArray[0] is \(employeesArray[0] ?? "¯\\_(ツ)_/¯") expected: \(self.employeesArray[0] ?? "¯\\_(ツ)_/¯")")
        XCTAssert(employeesArray[1] == self.employeesArray[1], "employeesArray[1] is \(employeesArray[1] ?? "¯\\_(ツ)_/¯") expected: \(self.employeesArray[1] ?? "¯\\_(ツ)_/¯")")
        let employeesOptionalArray = node["employeesOptionalArray"]
        XCTAssert(employeesOptionalArray![0]! == self.employeesArray[0], "employeesOptionalArray[0] is \(employeesOptionalArray?[0] ?? "¯\\_(ツ)_/¯") expected: \(self.employeesArray[0] ?? "¯\\_(ツ)_/¯")")
        XCTAssert(employeesOptionalArray![1]! == self.employeesArray[1], "employeesOptionalArray[1] is \(employeesOptionalArray?[1] ?? "¯\\_(ツ)_/¯") expected: \(self.employeesArray[1] ?? "¯\\_(ツ)_/¯")")
        
        // Mappable dictionary
        let employeesDictionary = node["employeesDictionary"]!
        XCTAssert(employeesDictionary["0"]! == self.employeesDictionary["0"]!,
                  "employeesDictionary[\"0\"] is \(employeesDictionary["0"]!) expected: \(self.employeesDictionary["0"]!)")
        XCTAssert(employeesDictionary["1"]! == self.employeesDictionary["1"]!,
                  "employeesDictionary[\"1\"] is \(employeesDictionary["1"]!) expected: \(self.employeesDictionary[""]!)")
        let employeesOptionalDictionary = node["employeesOptionalDictionary"]
        XCTAssert(employeesOptionalDictionary!["0"]! == self.employeesDictionary["0"]!,
                  "employeesOptionalDictionary[\"0\"] is \(employeesOptionalDictionary?["0"]! ?? "¯\\_(ツ)_/¯") expected: \(self.employeesDictionary["0"]!)")
        XCTAssert(employeesOptionalDictionary!["1"]! == self.employeesDictionary["1"]!,
                  "employeesOptionalDictionary[\"1\"] is \(employeesOptionalDictionary?["1"]! ?? "¯\\_(ツ)_/¯") expected: \(self.employeesDictionary["1"]!)")
        
        // Mappable dictionary array
        let employeesDictionaryArray = node["employeesDictionaryArray"]!
        XCTAssert(employeesDictionaryArray["0"]! == self.employeesDictionaryArray["0"]!,
                  "employeesDictionaryArray[\"0\"] is \(employeesDictionaryArray["0"]!) expected: \(self.employeesDictionaryArray["0"]!)")
        XCTAssert(employeesDictionaryArray["1"]! == self.employeesDictionaryArray["1"]!,
                  "employeesDictionaryArray[\"1\"] is \(employeesDictionaryArray["1"]!) expected: \(self.employeesDictionaryArray["1"]!)")
        let employeesOptionalDictionaryArray = node["employeesOptionalDictionaryArray"]
        XCTAssert(employeesOptionalDictionaryArray!["0"]! == self.employeesDictionaryArray["0"]!,
                  "employeesOptionalDictionaryArray[\"0\"] is \(employeesOptionalDictionaryArray?["0"]! ?? "¯\\_(ツ)_/¯") expected: \(self.employeesDictionaryArray["0"]!)")
        XCTAssert(employeesOptionalDictionaryArray!["1"]! == self.employeesDictionaryArray["1"]!,
                  "employeesOptionalDictionaryArray[\"1\"] is \(employeesOptionalDictionaryArray?["1"]! ?? "¯\\_(ツ)_/¯") expected: \(self.employeesDictionaryArray["1"]!)")
        
        // Mappable set
        // Temporarily commented out on linux because it's reordering array
        #if Xcode
        let employeesSet = node["employeesSet"]!
        XCTAssert(employeesSet == self.employeesSet,
                  "employeesSet is \(employeesSet) expected: \(self.employeesSet)")
        let employeesOptionalSet = node["employeesOptionalSet"]
        XCTAssert(employeesOptionalSet == self.employeesSet,
                  "employeesOptionalSet is \(employeesOptionalSet ?? "¯\\_(ツ)_/¯") expected: \(self.employeesSet)")
        #endif

        // Nil
        let optionalNil = node["optionalNil"]
        XCTAssertTrue(optionalNil == nil, "optionalNil is \(optionalNil ?? "¯\\_(ツ)_/¯") expected: nil")
        let optionalNotNil = node["optionalNotNil"]
        XCTAssertTrue(optionalNotNil != nil, "optionalNotNil is \(optionalNotNil ?? "¯\\_(ツ)_/¯") expected: \(node["optionalNotNil"] ?? "¯\\_(ツ)_/¯")")
    }
    
}

// MARK: Operators

func ==(lhs: ToNodeOperatorTest.Employee, rhs: ToNodeOperatorTest.Employee) -> Bool {
    return lhs.name == rhs.name
}
