import Foundation

struct AwningEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var location: String
    var lastCleaned: String
    var motorType: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), location: String, lastCleaned: String, motorType: String, notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.location = location
        self.lastCleaned = lastCleaned
        self.motorType = motorType
        self.notes = notes
        self.createdAt = createdAt
    }
}
