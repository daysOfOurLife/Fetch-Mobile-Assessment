//
//  ContentView.swift
//  Fetch Mobile Assessment
//
//  Created by Victor Nguyen on 9/28/23.
//

import SwiftUI

struct Item: Codable {
    let id: Int
    let listId: Int
    let name: String?
}

struct ContentView: View {
    @State private var items = [Item]()

    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                if let itemName = item.name {
                    if !itemName.isEmpty {
                        Text("listId:\(item.listId), id:\(item.id), name:\(itemName)")
                            .padding(3)
                    }
                }
            }
        }
        .task {
            do {
                try await retrieveItems()
                customSort()
            } catch {
                print("Error!")
            }
        }
    }

    /// Retrieves ``Item``s from https://fetch-hiring.s3.amazonaws.com/hiring.json & assigns the resulting collection to `items`.
    func retrieveItems() async throws {
        let endpoint: String = "https://fetch-hiring.s3.amazonaws.com/hiring.json"

        guard let url = URL(string: endpoint) else { return }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        items = try decoder.decode([Item].self, from: data)
    }

    /// Sorts by item listId. If listIds are equal, sort by item name
    func customSort() {
        items.sort { item1, item2 in
            if item1.listId == item2.listId {
                return (item1.name ?? "") < (item2.name ?? "")
            } else {
                return item1.listId < item2.listId
            }
        }
    }
}

#Preview {
    ContentView()
}
