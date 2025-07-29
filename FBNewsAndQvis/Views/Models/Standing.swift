import Foundation

struct StandingsResponse: Decodable {
    let standings: [Standing]
}

struct Standing: Decodable, Identifiable {
    let stage: String?
    let type: String?
    let group: String?
    let table: [TableRow]
    var id: String { (stage ?? "") + (type ?? "") + (group ?? "") }
}

struct TableRow: Decodable, Identifiable {
    let position: Int
    let team: Team
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    var id: Int { position }
} 