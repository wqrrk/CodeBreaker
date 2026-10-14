// xcode: set sdk=iOS

//
//  MatchMarkersView.swift
//  CodeBreaker
//
//  Created by Wark on 05.10.2026.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkersView: View {
    var matches: [Match]
    var body: some View {
        let rows = (matches.count + 1) / 2
        VStack {
            HStack {
                ForEach(0..<rows, id: \.self) { index in
                    matchMarker(peg: index)
                }
                
            }
            
            HStack {
                ForEach(rows..<matches.count, id: \.self) { index in
                    matchMarker(peg: index)
                }
                //using a modificator hidden to draw a circle where there is no match to fix the scaling issue
                if matches.count % 2 != 0 { //if the count of matches is not even, then generate a hidden circle
                    Circle()
                        .hidden()
                        .aspectRatio(1, contentMode: .fit) //same as in the helicopter view
                }
            }
        }
    }
    
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count(where: { $0 == .exact})
        let foundCount = matches.count(where: { $0 != .nomatch})
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MatchMarkersView(matches: [.exact, .inexact, .inexact, .exact, .inexact])
}
