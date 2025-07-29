import Foundation

class FootballAPI {
    static let shared = FootballAPI()
    private let baseURL = "https://api.football-data.org/v4/"
    private let apiToken = "1b3c1b7bfcbe409b9bfcb544947470c9"
    
    func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        // Пример: матчи Лиги чемпионов (id=2001)
        let urlString = baseURL + "competitions/2001/matches?limit=15"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(MatchesResponse.self, from: data)
                completion(.success(decoded.matches))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchStandings(completion: @escaping (Result<[TableRow], Error>) -> Void) {
        let urlString = baseURL + "competitions/2001/standings"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(StandingsResponse.self, from: data)
                if let total = decoded.standings.first(where: { $0.type == "TOTAL" }) {
                    completion(.success(total.table))
                } else {
                    completion(.failure(NSError(domain: "NoTable", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchScorers(completion: @escaping (Result<[Scorer], Error>) -> Void) {
        let urlString = baseURL + "competitions/2001/scorers?limit=20"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(ScorersResponse.self, from: data)
                completion(.success(decoded.scorers))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchTeams(completion: @escaping (Result<[TeamListItem], Error>) -> Void) {
        let urlString = baseURL + "competitions/2001/teams"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(TeamListResponse.self, from: data)
                completion(.success(decoded.teams))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct MatchesResponse: Decodable {
    let matches: [Match]
}

//struct StandingsResponse: Decodable {
//    let standings: [Standing]
//} 
