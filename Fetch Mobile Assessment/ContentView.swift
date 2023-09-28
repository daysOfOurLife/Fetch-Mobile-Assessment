//
//  ContentView.swift
//  Fetch Mobile Assessment
//
//  Created by Victor Nguyen on 9/28/23.
//

import SwiftUI

/// A model of an item after JSON data is decoded
struct Item: Decodable {
    let id: Int
    let listId: Int
    let name: String?
}

/// Possible errors that may occur from attempting to retrieve item data
enum RetrieveItemDataError: Error {
    case invalidURL
    case invalidData
}

struct ContentView: View {
    @State private var items = [Item]()

    var body: some View {
        List {
            ForEach(1 ... 4, id: \.self) { listId in
                Section {
                    ForEach(items.filter { $0.listId == listId }, id: \.id) { item in
                        if let itemName = item.name {
                            if !itemName.isEmpty {
                                Text("listId:\(item.listId), id:\(item.id), name:\(itemName)")
                            }
                        }
                    }
                } header: {
                    Text("listId: \(listId)")
                }
            }
        }
        .task {
            do {
                try await retrieveItems()
                customSort()
            } catch RetrieveItemDataError.invalidURL {
                print("- Invalid URL.")
            } catch RetrieveItemDataError.invalidData {
                print("- Unable to decode JSON data.")
            } catch {
                print("- Unexpected error. Something really went wrong.")
            }
        }
    }

    /// Retrieves ``Item``s from https://fetch-hiring.s3.amazonaws.com/hiring.json & assigns the resulting collection to `items`.
    func retrieveItems() async throws {
        let endpoint: String = "https://fetch-hiring.s3.amazonaws.com/hiring.json"

        guard let url = URL(string: endpoint) else {
            throw RetrieveItemDataError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse JSON data into a collection of ``Item``s and assign to `items`.
        do {
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            throw RetrieveItemDataError.invalidData
        }
    }

    /// Sorts by item listId. If listIds are equal, sort by item name.
    func customSort() {
        items.sort { item1, item2 in
            if item1.listId == item2.listId {
                return (item1.name ?? "") < (item2.name ?? "")
            } else {
                return item1.listId < item2.listId
            }
        }
    }

    /// Filters collection of ``Item``s that have the specified listId
    ///
    /// - Parameter listsId: listId property of ``Item``
    ///
    /// - Returns: A collection of ``Item``s that have the specified listId
    func filteredItems(by listId: Int) -> [Item] {
        return items.filter { $0.listId == listId }
    }
}

#Preview {
    ContentView()
}
