import Foundation

struct ScorersResponse: Decodable {
    let scorers: [Scorer]
}

struct Scorer: Decodable, Identifiable {
    let player: Player
    let team: Team
    let goals: Int
    var id: Int { player.id }
}


