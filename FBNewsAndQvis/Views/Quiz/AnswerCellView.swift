//
//  AnswerCellView.swift
//  FBNewsAndQvisSwiftUI
//
//  Created by Роман Главацкий on 26.06.2025.
//

import SwiftUI

struct AnswerCellView: View {
    var text: String
    var body: some View {
        ZStack(alignment: .center) {
            Image(.backAnswer)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 63)
                
            Text(text)
                .padding(.leading, 50)
                .foregroundStyle(.black)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

#Preview {
    AnswerCellView(text: "werdfgdfgg")
}
