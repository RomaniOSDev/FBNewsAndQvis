//
//  MatchRow.swift
//  FBNewsAndQvisSwiftUI
//
//  Created by Роман Главацкий on 27.06.2025.
//
import SwiftUI

struct MatchRow: View {
    let match: Match
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(match.homeTeam.name)
                    .foregroundStyle(.white)
                Spacer()
                Text(scoreText)
                    .foregroundStyle(.red)
                    .font(.headline)
                Spacer()
                Text(match.awayTeam.name)
                    .foregroundStyle(.white)
            }
            Text(dateText)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .padding(.vertical, 4)
    }
    var scoreText: String {
        let home = match.score.fullTime?.home
        let away = match.score.fullTime?.away
        if let home = home, let away = away {
            return "\(home) : \(away)"
        } else {
            return "- : -"
        }
    }
    var dateText: String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: match.utcDate) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return match.utcDate
    }
}
