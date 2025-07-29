//
//  ContentView.swift
//  FBNewsAndQvisSwiftUI
//
//  Created by Роман Главацкий on 19.06.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Image(.newsbut)
                      
                }
            QuizView()
                .tabItem {
                    Image(.quizbut)
                       
                }
            SettingsView()
                .tabItem {
                    Image(.settingBut)
                       
                }
        }
    }
}

#Preview {
    ContentView()
}
