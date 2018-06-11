//: Playground - noun: a place where people can play

import UIKit

//That is an example of nongeneric function

func swapTowInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 2

print("before swapping, someInt = \(someInt), anotherInt = \(anotherInt)")

swapTowInts(&someInt, &anotherInt)

print("After swapping, someInt = \(someInt), anotherInt = \(anotherInt)")

// if we want to swap tow string, we should create another function for that

func swapTowString(_ a: inout String, _ b: inout String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someString = "Hello World"
var anotherString = "Good morning dear"

print("Before swapping, someString = \(someString), anotherString = \(anotherString)")

swapTowString(&someString, &anotherString)

print("After swapping, someString = \(someString), anotherString \(anotherString)")

// If we want to add another type, we should create one more function
// But we can solve this by just create a generic function

func swapTowValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someFloat: Float = 12.3
var anotherFloat: Float = 20.5

print("Before swapping, someFloat = \(someFloat), anotherFloat = \(anotherFloat)")

swapTowValues(&someFloat, &anotherFloat)

print("After swapping, someFloat = \(someFloat), anotherFloat = \(anotherFloat)")

// Another example

// 1- Nongeneric
struct IntStack {
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() {
        items.removeLast()
    }
}

var intStack = IntStack(items: [2, 3, 1, 6, 4, 9, 7])

intStack.push(5)
print(intStack)
intStack.pop()
print(intStack)

// 2- Generic version
//struct Stack<Element> {
//    var items = [Element]()
//
//    mutating func push(_ item: Element) {
//        items.append(item)
//    }
//
//    mutating func pop() {
//        items.removeLast()
//    }
//}

var stack = Stack(items: ["A", "C", "E", "B", "H", "D", "J", "I"])
stack.push("K")
print(stack)
stack.pop()
print(stack)

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items.first
    }
}

print("The topItem in our Stack<String> is \(stack.topItem!)")

// Type Constraints
// When define swift generic Type, you can specify a limitation on the types that can be uses

func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]

let foundIndex = findIndex(ofString: "llama", in: strings)
print("The index of llama is \(foundIndex)")

func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.12, in: [3.14, 0.1, 2.25])
print("doubleindex = \(String(describing: doubleIndex))")

let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
print("stringIndex = \(String(describing: stringIndex))")

// Associeted Types
// When we define a protocol, we can declare one or more associedted types as part of the protocol's definition

protocol Container {
    associatedtype Item
    
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct Stack<Element>: Container {
    //Original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    //Conforming to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
}

print("stack.count = \(stack.count), stack[3] = \(stack[3])")

// Adding constraints to an associate type
/*protocol Container {
    associatedtype Item: Equatable
    
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    
    func suffix(_ size: Int) -> Suffix
}

extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
}*/

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {
        if someContainer.count != anotherContainer.count {
            return false
        }
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        return true
}

var statckOfString = Stack<String>()
statckOfString.append("uno")
statckOfString.append("dos")
statckOfString.append("tres")

var arrayOfString = Stack(items: ["uno", "dos", "tres"])

if allItemsMatch(statckOfString, arrayOfString) {
    print("All items match.")
} else {
    print("Not all items match.")
}











