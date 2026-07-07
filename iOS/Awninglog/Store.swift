import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [AwningEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Awninglog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
        if entries.isEmpty {
            seed()
        }
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: AwningEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: AwningEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: AwningEntry) {
        entries.removeAll(where: { $0.id == entry.id })
        save()
    }

    private func seed() {
        entries = [
            AwningEntry(location: "Front", lastCleaned: "Recently checked", motorType: "Good", notes: "Seed entry"),
            AwningEntry(location: "Back", lastCleaned: "Last month", motorType: "Needs attention", notes: "Seed entry"),
            AwningEntry(location: "Side", lastCleaned: "Two months ago", motorType: "Good", notes: "Seed entry"),
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([AwningEntry].self, from: data) else { return }
        entries = decoded
    }
}
