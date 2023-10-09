//
//  RetrieveItemDataError.swift
//  Fetch Mobile Assessment
//
//  Created by Victor Nguyen on 10/9/23.
//

import Foundation

/// Possible errors that may occur from attempting to retrieve item data
enum RetrieveItemDataError: Error {
    case invalidURL
    case invalidData
}
