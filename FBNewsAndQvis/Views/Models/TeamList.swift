import Foundation

struct TeamListResponse: Decodable {
    let teams: [TeamListItem]
}

struct TeamListItem: Decodable, Identifiable {
    let id: Int
    let name: String
    let shortName: String?
    let tla: String?
    let crest: String?
    let venue: String?
} 