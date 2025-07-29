import Foundation

struct Match: Identifiable, Decodable {
    let id: Int
    let utcDate: String
    let status: String
    let homeTeam: TeamInfo
    let awayTeam: TeamInfo
    let score: Score
    
    struct TeamInfo: Decodable {
        let id: Int
        let name: String
    }
    struct Score: Decodable {
        let fullTime: Result?
        struct Result: Decodable {
            let home: Int?
            let away: Int?
        }
    }
} 