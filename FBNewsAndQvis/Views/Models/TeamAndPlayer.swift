import Foundation

struct Team: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct Player: Decodable, Identifiable {
    let id: Int
    let name: String
} 