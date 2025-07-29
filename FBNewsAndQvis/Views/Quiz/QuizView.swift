import SwiftUI

struct QuizQuestion: Equatable {
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct ShuffledQuizQuestion: Equatable {
    let question: String
    let options: [String]
    let correctIndex: Int
    init(from base: QuizQuestion) {
        let zipped = base.options.enumerated().map { ($0.offset, $0.element) }
        let shuffled = zipped.shuffled()
        self.options = shuffled.map { $0.1 }
        self.question = base.question
        self.correctIndex = shuffled.firstIndex(where: { $0.0 == base.correctIndex }) ?? 0
    }
}

enum QuizLevel: String, CaseIterable, Identifiable {
    case easy = "Easy Level"
    case medium = "Medium Level"
    case hard = "Hard Level"
    var id: String { self.rawValue }
    var emoji: String {
        switch self {
        case .easy: return "⚽"
        case .medium: return "🟡"
        case .hard: return "🔴"
        }
    }
    var image: ImageResource{
        switch self {
            
        case .easy:
                return .easy
        case .medium:
            return .medium
        case .hard:
            return .hard
        }
    }
    var icon: ImageResource{
        switch self {
            case .easy:
        
            return .easyIcon
        case .medium:
            return .mediumIcon
        case .hard:
            return .hardIcon}
    }
}

struct QuizView: View {
    @State private var selectedLevel: QuizLevel? = nil
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: Int? = nil
    @State private var correctAnswers = 0
    @State private var showResult = false
    @State private var shuffledQuestions: [ShuffledQuizQuestion] = []

    var body: some View {
        NavigationView {
            ZStack{
                Image(.mainBack).resizable()
                    .ignoresSafeArea()
                VStack {
                    if let level = selectedLevel {
                        if showResult {
                            QuizResultView(score: correctAnswers, total: questions(for: level).count, onRestart: restart)
                        } else {
                            QuizQuestionView(
                                level: level,
                                question: shuffledQuestions[currentQuestionIndex],
                                questionNumber: currentQuestionIndex + 1,
                                totalQuestions: shuffledQuestions.count,
                                selectedOption: $selectedOption,
                                onNext: handleNext,
                                isLast: currentQuestionIndex == shuffledQuestions.count - 1,
                                onExit: restart
                            )
                        }
                    } else {
                        QuizLevelSelectionView(onSelect: { level in
                            selectedLevel = level
                            let base = questions(for: level)
                            shuffledQuestions = base.map { ShuffledQuizQuestion(from: $0) }
                        })
                    }
                }
            }
        }
    }

    func questions(for level: QuizLevel) -> [QuizQuestion] {
        switch level {
        case .easy: return easyQuestions
        case .medium: return mediumQuestions
        case .hard: return hardQuestions
        }
    }

    func handleNext(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1 }
        if currentQuestionIndex < shuffledQuestions.count - 1 {
            currentQuestionIndex += 1
            selectedOption = nil
        } else if let level = selectedLevel {
            showResult = true
            saveResultIfBest(level: level, score: correctAnswers, total: shuffledQuestions.count)
        }
    }

    func saveResultIfBest(level: QuizLevel, score: Int, total: Int) {
        let key = "quizResult_" + level.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let prev = UserDefaults.standard.integer(forKey: key)
        if score > prev {
            UserDefaults.standard.set(score, forKey: key)
        }
    }

    func restart() {
        selectedLevel = nil
        currentQuestionIndex = 0
        selectedOption = nil
        correctAnswers = 0
        showResult = false
        shuffledQuestions = []
    }
}

struct QuizLevelSelectionView: View {
    let onSelect: (QuizLevel) -> Void
    var body: some View {
        VStack(spacing: 32) {
            Image(.penalty)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 30)
            Spacer()
            Image(.chooselevel)
                .resizable()
                .frame(width: 212, height: 159)
                
                Spacer()
            HStack {
                ForEach(QuizLevel.allCases) { level in
                    Button(action: { onSelect(level) }) {
                        Image(level.icon)
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}
#Preview(body: {
    QuizView()
})

struct QuizQuestionView: View {
    let level: QuizLevel
    let question: ShuffledQuizQuestion
    let questionNumber: Int
    let totalQuestions: Int
    @Binding var selectedOption: Int?
    let onNext: (Bool) -> Void
    let isLast: Bool
    let onExit: () -> Void
    @State private var answerChecked = false
    @State private var wasCorrect = false

    var body: some View {
        
        VStack(spacing: 24) {
            Image(level.image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.top, 16)

            Text(question.question)
                .font(.system(size: 29, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                
            ForEach(0..<question.options.count, id: \ .self) { idx in
                Button(action: {
                    if !answerChecked {
                        selectedOption = idx
                        answerChecked = true
                        wasCorrect = idx == question.correctIndex
                    }
                }) {
                   AnswerCellView(text: question.options[idx])
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedOption == idx ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            .background(selectedOption == idx ? Color.blue.opacity(0.08) : Color.clear)
                    )
                }
                .disabled(answerChecked)
            }
            Spacer()
            HStack(spacing: 16) {
                Button(action: onExit) {
                    Text("BACK")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                if answerChecked {
                    Button(action: { onNext(wasCorrect) }) {
                        Text(isLast ? "Complete" : "NEXT")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .animation(.default, value: answerChecked)
        .onChange(of: question) { _ in
            answerChecked = false
            wasCorrect = false
        }
    }
}

struct QuizResultView: View {
    let score: Int
    let total: Int
    let onRestart: () -> Void
    var body: some View {
        VStack(spacing: 32) {
            Text("LEVEL COMPLETE")
                .font(.system(size: 29, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Image(.cupWin)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 270)
            Spacer()
            Button(action: onRestart) {
                Image(.finishQuiz)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
            }
            
        }
        .padding()
    }
}

// MARK: - Questions Data

let easyQuestions: [QuizQuestion] = [
    QuizQuestion(question: "Which country won the FIFA World Cup in 2018?", options: ["France", "Croatia"], correctIndex: 0),
    QuizQuestion(question: "How many players are on the field per team?", options: ["11", "10"], correctIndex: 0),
    QuizQuestion(question: "What is the name of the ball used in a match?", options: ["Football", "Handball"], correctIndex: 0),
    QuizQuestion(question: "Which part of the body can't touch the ball (except the goalkeeper)?", options: ["Hands", "Feet"], correctIndex: 0),
    QuizQuestion(question: "Where does a penalty kick take place?", options: ["Penalty area", "Corner"], correctIndex: 0),
    QuizQuestion(question: "What color card means a player is sent off?", options: ["Red", "Yellow"], correctIndex: 0),
    QuizQuestion(question: "How long is a regular football match?", options: ["90 minutes", "60 minutes"], correctIndex: 0),
    QuizQuestion(question: "Which country hosts the Premier League?", options: ["England", "Germany"], correctIndex: 0),
    QuizQuestion(question: "What is scored when the ball crosses the goal line?", options: ["Goal", "Foul"], correctIndex: 0),
    QuizQuestion(question: "Who wears gloves on the field?", options: ["Goalkeeper", "Striker"], correctIndex: 0)
]

let mediumQuestions: [QuizQuestion] = [
    QuizQuestion(question: "Who won the UEFA Euro 2020?", options: ["Italy", "England"], correctIndex: 0),
    QuizQuestion(question: "Which player is known as 'CR7'?", options: ["Cristiano Ronaldo", "Neymar"], correctIndex: 0),
    QuizQuestion(question: "What is the max number of substitutions allowed (regular time)?", options: ["5", "7"], correctIndex: 0),
    QuizQuestion(question: "Which club has the most UEFA Champions League titles?", options: ["Real Madrid", "Barcelona"], correctIndex: 0),
    QuizQuestion(question: "How many points is a win worth in league play?", options: ["3", "2"], correctIndex: 0),
    QuizQuestion(question: "Who hosts El Clásico?", options: ["Real Madrid & Barcelona", "PSG & Marseille"], correctIndex: 0),
    QuizQuestion(question: "Which nation won the first ever World Cup (1930)?", options: ["Uruguay", "Argentina"], correctIndex: 0),
    QuizQuestion(question: "Where is Bayern Munich from?", options: ["Germany", "Spain"], correctIndex: 0),
    QuizQuestion(question: "Who can score with a header?", options: ["Any player", "Only defenders"], correctIndex: 0),
    QuizQuestion(question: "What is VAR used for?", options: ["Reviewing decisions", "Measuring speed"], correctIndex: 0)
]

let hardQuestions: [QuizQuestion] = [
    QuizQuestion(question: "Which goalkeeper has the most clean sheets in EPL history?", options: ["Petr Čech", "David De Gea"], correctIndex: 0),
    QuizQuestion(question: "Who scored the 'Hand of God' goal?", options: ["Maradona", "Pelé"], correctIndex: 0),
    QuizQuestion(question: "Which club is nicknamed 'The Old Lady'?", options: ["Juventus", "AC Milan"], correctIndex: 0),
    QuizQuestion(question: "In which year did Lionel Messi join PSG?", options: ["2021", "2022"], correctIndex: 0),
    QuizQuestion(question: "Which African country reached the World Cup semi-final in 2022?", options: ["Morocco", "Senegal"], correctIndex: 0),
    QuizQuestion(question: "Who won the Ballon d'Or in 2023?", options: ["Lionel Messi", "Erling Haaland"], correctIndex: 0),
    QuizQuestion(question: "Which stadium is home to Manchester United?", options: ["Old Trafford", "Etihad Stadium"], correctIndex: 0),
    QuizQuestion(question: "Who is Brazil's all-time top scorer (as of 2023)?", options: ["Neymar", "Ronaldo"], correctIndex: 0),
    QuizQuestion(question: "Which team did Erling Haaland play for before Man City?", options: ["Borussia Dortmund", "Ajax"], correctIndex: 0),
    QuizQuestion(question: "Who is known as 'The Egyptian King'?", options: ["Mohamed Salah", "Riyad Mahrez"], correctIndex: 0)
] 
