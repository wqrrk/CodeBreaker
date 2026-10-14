// xcode: set sdk=iOS

import SwiftUI
import Playgrounds

struct CodeBreakerView: View {
    
    @State var game = CodeBreaker()
    
    var body: some View {
        NavigationStack {
            VStack {
                view(for: game.masterCode)
                ScrollView {
                    view(for: game.guess)
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        view(for: game.attempts[index])
                    }
                }
            }
            .navigationTitle("Code Breaker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    restartButton
                }
            }
            .padding()
        }
        
    }
    
    var guessButton: some View {
        Button("Guess") {
            if !game.hasAlreadyTriedCurrentGuess && !game.isEmptyGuess {
                withAnimation {
                    game.attemptGuess()
                }

            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restartButton: some View{
        Button {
            withAnimation {
                game.restart()
            }
        } label : {
            Image(systemName: "arrow.clockwise")
        }
    }
    
    func color(for peg: String) -> Color {
        switch peg {
        case "red":    return .red
        case "blue":   return .blue
        case "green":  return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "pink":   return .pink
        case "brown":  return .brown

        // Autumn Theme 🍂
        case "maroon": return Color(red: 0.50, green: 0.00, blue: 0.13)
        case "gold":   return Color(red: 1.00, green: 0.84, blue: 0.00)
        case "rust":   return Color(red: 0.72, green: 0.25, blue: 0.05)
        case "olive":  return Color(red: 0.50, green: 0.50, blue: 0.00)

        default: return .clear
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(color(for: code.pegs[index]))
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.gray)
                        }
                        if Code.emojiPegChoices.contains(code.pegs[index]) {
                            Text(code.pegs[index])
                                .font(.system(size: 120))
                                .minimumScaleFactor(9/120)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            
            
            switch code.kind {
            case .master: MatchMarkersView(matches: Array(repeating: .nomatch, count: code.pegs.count))
            case .guess: MatchMarkersView(matches: Array(repeating: .nomatch, count: code.pegs.count)).overlay {
                if code.kind == .guess {
                    guessButton
                }
            }
            default: MatchMarkersView(matches: code.matches)
            }
        }
    }
}

#Preview {
    CodeBreakerView()
}
