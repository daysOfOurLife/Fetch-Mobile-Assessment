//
//  Item.swift
//  Fetch Mobile Assessment
//
//  Created by Victor Nguyen on 10/9/23.
//

import Foundation

/// A model of an item after JSON data is decoded
struct Item: Decodable {
    let id: Int
    let listId: Int
    let name: String?
}
