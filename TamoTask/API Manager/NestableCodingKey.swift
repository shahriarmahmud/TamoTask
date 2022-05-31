//
//  NestableCodingKey.swift
//  TamoTask
//
//  Created by Shahriar Mahmud on 4/7/20.
//  Copyright © 2020 Shahriar Mahmud. All rights reserved.
//

/**
 https://gist.github.com/AliSoftware/89b275d7259d23ebf12d377b6ffe15cd#file-nestablecodingkey-swift
 */

/**
 https://medium.com/@nictheawesome/using-codable-with-nested-json-is-both-easy-and-fun-19375246c9ff
 */

/**
 https://www.stencia.com/blog/2019/2/28/swift-codable-and-nested-keys
 https://www.appcoda.com/json-codable-swift/
 */

/**
 https://github.com/dgrzeszczak/KeyedCodable

 */

import Foundation
//: # NestedKey
///
/// Use this to annotate the properties that require a depth traversal during decoding.
/// The corresponding `CodingKey` for this property must be a `NestableCodingKey`
@propertyWrapper
struct NestedKey<T: Decodable>: Decodable {
    var wrappedValue: T
    struct AnyCodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    init(from decoder: Decoder) throws {
        let key = decoder.codingPath.last!
        guard let nestedKey = key as? NestableCodingKey else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Key \(key) is not a NestableCodingKey"))
        }
        let nextKeys = nestedKey.path.dropFirst()

        // key descent
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        let lastLeaf = try nextKeys.indices.dropLast().reduce(container) { (nestedContainer, keyIdx) in
            do {
                return try nestedContainer.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue: nextKeys[keyIdx]))
            } catch DecodingError.keyNotFound(let key, let ctx) {
                try NestedKey.keyNotFound(key: key, ctx: ctx, container: container, nextKeys: nextKeys[..<keyIdx])
            }
        }
        // key leaf
        do {
            self.wrappedValue = try lastLeaf.decode(T.self, forKey: AnyCodingKey(stringValue: nextKeys.last!))
        } catch DecodingError.keyNotFound(let key, let ctx) {
            try NestedKey.keyNotFound(key: key, ctx: ctx, container: container, nextKeys: nextKeys.dropLast())
        }
    }

    private static func keyNotFound<C: Collection>(
        key: CodingKey, ctx: DecodingError.Context,
        container: KeyedDecodingContainer<AnyCodingKey>, nextKeys: C) throws -> Never
        where C.Element == String
    {
        throw DecodingError.keyNotFound(key, DecodingError.Context(
            codingPath: container.codingPath + nextKeys.map(AnyCodingKey.init(stringValue:)),
            debugDescription: "NestedKey: No value associated with key \"\(key.stringValue)\"",
            underlyingError: ctx.underlyingError
        ))
    }
}

//: # NestableCodingKey
/// Use this instead of `CodingKey` to annotate your `enum CodingKeys: String, NestableCodingKey`.
/// Use a `/` to separate the components of the path to nested keys
protocol NestableCodingKey: CodingKey {
    var path: [String] { get }
}

extension NestableCodingKey where Self: RawRepresentable, Self.RawValue == String {
    init?(stringValue: String) {
        self.init(rawValue: stringValue)
    }
    var stringValue: String {
        path.first!
    }

    init?(intValue: Int) {
        fatalError()
    }
    var intValue: Int? { nil }

    var path: [String] {
        self.rawValue.components(separatedBy: "/")
    }
}
