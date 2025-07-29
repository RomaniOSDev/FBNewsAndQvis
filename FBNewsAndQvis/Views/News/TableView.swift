//
//  TableView.swift
//  FBNewsAndQvisSwiftUI
//
//  Created by Роман Главацкий on 27.06.2025.
//

import SwiftUI

struct TableView: View {
    let rows: [TableRow]
    var body: some View {
        ScrollView {
            HStack {
                Text("#").frame(width: 24)
                Text("Team").frame(maxWidth: .infinity, alignment: .leading)
                Text("I").frame(width: 20)
                Text("V").frame(width: 20)
                Text("H").frame(width: 20)
                Text("P").frame(width: 20)
                Text("O").frame(width: 24)
            }.font(.caption).foregroundColor(.secondary)
            ForEach(rows) { row in
                TableRowView(row: row)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct TableRowView: View {
    let row: TableRow
    var body: some View {
        HStack {
            Text("\(row.position)").frame(width: 24)
            Text(row.team.name).frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.white)
            Text("\(row.playedGames)").frame(width: 20)
                .foregroundStyle(.yellow)
            Text("\(row.won)").frame(width: 20)
                .foregroundStyle(.green)
            Text("\(row.draw)").frame(width: 20)
                .foregroundStyle(.blue)
            Text("\(row.lost)").frame(width: 20)
                .foregroundStyle(.red)
            Text("\(row.points)").frame(width: 24)
                .foregroundStyle(.orange)
        }
        .font(.callout)
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
