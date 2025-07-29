//
//  QuizResultsSheet.swift
//  FBNewsAndQvisSwiftUI
//
//  Created by Роман Главацкий on 27.06.2025.
//
import SwiftUI

struct QuizResultsSheet: View {
    @Environment(\.dismiss) var dismiss
    let results: [(level: String, emoji: String, key: String)] = [
        ("", "", "quizResult_easylevel"),
        ("", "", "quizResult_mediumlevel"),
        ("", "", "quizResult_hardlevel")
    ]
    var body: some View {
        ZStack{
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 16) {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(.closeButton)
                            .resizable()
                            .frame(width: 54, height: 57)
                    }
                    Spacer()

                }
                Image(.resultLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 175)
                
                //MARK: - Table
                ZStack(alignment: .bottomTrailing){
                    Image(.scoreTable)
                        .resizable()
                        .frame(width: 340, height: 370)
                    VStack(spacing: 40) {
                    ForEach(results, id: \ .key) { item in
                            Text("\(UserDefaults.standard.integer(forKey: item.key))/10")
                            .font(.system(size: 29, weight: .bold))
                            .foregroundStyle(.white)
                        }
                    }.padding(30)
                        .padding(.bottom, 10)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    QuizResultsSheet()
}
