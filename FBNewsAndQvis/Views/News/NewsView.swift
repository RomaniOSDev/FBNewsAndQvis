import SwiftUI

enum NewsCategory: String, CaseIterable, Identifiable {
    case matches = "Матчи"
    case standings = "Таблицы"
    case scorers = "Бомбардиры"
    case teams = "Команды"
    var id: String { self.rawValue }
    
    var image: ImageResource {
        switch self {
            
        case .matches:
            return .matchLabel
        case .standings:
            return .tableLabel
        case .scorers:
            return .bombLabel
        case .teams:
            return .comandLabel
        }
    }
}

struct NewsView: View {
    @State private var selectedCategory: NewsCategory = .matches
    @State private var matches: [Match] = []
    @State private var standings: [TableRow] = []
    @State private var scorers: [Scorer] = []
    @State private var teams: [TeamListItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack{
                    Image(.newsLabel)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)
                    Spacer()
                }
                .padding(.horizontal)
                Picker("", selection: $selectedCategory) {
                    ForEach(NewsCategory.allCases) { category in
                        Image(category.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 29)
                            .tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
                Group {
                    switch selectedCategory {
                    case .matches:
                        if isLoading {
                            ProgressView()
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        } else {
                            ScrollView{
                                ForEach(matches) { match in
                                    MatchRow(match: match)
                                }
                            }
                        }
                    case .standings:
                        if isLoading {
                            ProgressView()
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        } else {
                            TableView(rows: standings)
                        }
                    case .scorers:
                        if isLoading {
                            ProgressView()
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        } else {
                            ScrollView{
                                ForEach(scorers) { scorer in
                                    ScorerRow(scorer: scorer)
                                }
                            }
                        }
                    case .teams:
                        if isLoading {
                            ProgressView()
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        } else {
                            ScrollView{
                                ForEach(teams) { team in
                                    TeamRow(team: team)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            
            .onAppear {
                loadCurrentCategory()
            }
            .onChange(of: selectedCategory) { _ in
                loadCurrentCategory()
            }
        }
    }
    
    private func loadCurrentCategory() {
        switch selectedCategory {
        case .matches:
            loadMatches()
        case .standings:
            loadStandings()
        case .scorers:
            loadScorers()
        case .teams:
            loadTeams()
        }
    }
    
    private func loadMatches() {
        isLoading = true
        errorMessage = nil
        FootballAPI.shared.fetchMatches { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let matches):
                    self.matches = matches
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func loadStandings() {
        isLoading = true
        errorMessage = nil
        FootballAPI.shared.fetchStandings { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let standings):
                    self.standings = standings
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func loadScorers() {
        isLoading = true
        errorMessage = nil
        FootballAPI.shared.fetchScorers { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let scorers):
                    self.scorers = scorers
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func loadTeams() {
        isLoading = true
        errorMessage = nil
        FootballAPI.shared.fetchTeams { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let teams):
                    self.teams = teams
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    NewsView()
}





struct ScorerRow: View {
    let scorer: Scorer
    var body: some View {
        HStack {
            Text(scorer.player.name)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            Spacer()
            Text(scorer.team.name)
                .foregroundStyle(.black)
            Spacer()
            Text("\(scorer.goals)")
                .font(.headline)
                .foregroundStyle(.red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .padding(.vertical, 4)
    }
}

struct TeamRow: View {
    let team: TeamListItem
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: team.crest ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(team.name).fontWeight(.bold)
                    .foregroundStyle(.white)
                if let venue = team.venue {
                    Text(venue).font(.caption).foregroundColor(.black)
                }
            }
            Spacer()
            if let tla = team.tla {
                Text(tla).font(.caption).foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .padding(.vertical, 4)
    }
} 
