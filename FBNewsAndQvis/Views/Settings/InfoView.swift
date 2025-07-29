//
//  InfoView.swift
//  FBNewsAndQvisSwiftUI
//
//  Created by Роман Главацкий on 27.06.2025.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack{
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
                Image(.info)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    InfoView()
}
