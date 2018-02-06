//
//  RealmQuery.swift
//  RealmSample
//
//  Created by Naoto Onagi on H30/02/06.
//  Copyright © 平成30年 Naoto Onagi. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - ColumnType

protocol ColumnType: Hashable {
    var keyPath: String { get }
}

extension ColumnType where Self: RawRepresentable, Self.RawValue == String {
    var keyPath: String {
        return self.rawValue
    }
}

// MARK: - Editable

protocol Editable {
    associatedtype Column: ColumnType
}

extension Results where Element: Editable {
    func filter<P: Predicate>(_ expression: @autoclosure () -> P) -> Results<Element> where P.ObjectType == Element {
        return self.filter(expression().predicate)
    }
    
    func sorted(by column: Element.Column, ascending: Bool) -> Results<Element> {
        return self.sorted(byKeyPath: column.keyPath, ascending: ascending)
    }
}

// MARK: - Predicate

protocol Predicate {
    associatedtype ObjectType: Editable
    var predicate: NSPredicate { get }
}

struct BasicPredicate<RealmObject: Editable>: Predicate {
    typealias ObjectType = RealmObject

    let format: String
    let argument: Any

    var predicate: NSPredicate {
        return NSPredicate(format: self.format, argumentArray: [self.argument])
    }
}

struct AndPredicate<RealmObject: Editable>: Predicate {
    typealias ObjectType = RealmObject

    let left: BasicPredicate<RealmObject>
    let right: BasicPredicate<RealmObject>

    var predicate: NSPredicate {
        return NSCompoundPredicate(type: .and, subpredicates: [self.left.predicate, self.right.predicate])
    }
}

struct OrPredicate<RealmObject: Editable>: Predicate {
    typealias ObjectType = RealmObject
    
    let left: BasicPredicate<RealmObject>
    let right: BasicPredicate<RealmObject>
    
    var predicate: NSPredicate {
        return NSCompoundPredicate(type: .or, subpredicates: [self.left.predicate, self.right.predicate])
    }
}

struct NotPredicate<RealmObject: Editable>: Predicate {
    typealias ObjectType = RealmObject
    
    let original: BasicPredicate<RealmObject>
    
    var predicate: NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self.original.predicate)
    }
}

func == <ObjectType: Editable>(lhs: ObjectType.Column, rhs: Any) -> BasicPredicate<ObjectType> {
    return BasicPredicate(format: "\(lhs.keyPath) == %@", argument: rhs)
}

func != <ObjectType: Editable>(lhs: ObjectType.Column, rhs: Any) -> BasicPredicate<ObjectType> {
    return BasicPredicate(format: "\(lhs.keyPath) != %@", argument: rhs)
}

func < <ObjectType: Editable>(lhs: ObjectType.Column, rhs: Any) -> BasicPredicate<ObjectType> {
    return BasicPredicate(format: "\(lhs.keyPath) < %@", argument: rhs)
}

func > <ObjectType: Editable>(lhs: ObjectType.Column, rhs: Any) -> BasicPredicate<ObjectType> {
    return BasicPredicate(format: "\(lhs.keyPath) > %@", argument: rhs)
}

func <= <ObjectType: Editable>(lhs: ObjectType.Column, rhs: Any) -> BasicPredicate<ObjectType> {
    return BasicPredicate(format: "\(lhs.keyPath) <= %@", argument: rhs)
}

func >= <ObjectType: Editable>(lhs: ObjectType.Column, rhs: Any) -> BasicPredicate<ObjectType> {
    return BasicPredicate(format: "\(lhs.keyPath) >= %@", argument: rhs)
}

func && <ObjectType>(lhs: BasicPredicate<ObjectType>, rhs: BasicPredicate<ObjectType>) -> AndPredicate<ObjectType> {
    return AndPredicate(left: lhs, right: rhs)
}

func || <ObjectType>(lhs: BasicPredicate<ObjectType>, rhs: BasicPredicate<ObjectType>) -> OrPredicate<ObjectType> {
    return OrPredicate(left: lhs, right: rhs)
}

prefix func ! <ObjectType>(predicate: BasicPredicate<ObjectType>) -> NotPredicate<ObjectType> {
    return NotPredicate(original: predicate)
}
