import SwiftUI
import Playgrounds

struct CodeBreakerView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .green, .blue, .green])
            pegs(colors: [.red, .yellow, .yellow, .green])
            pegs(colors: [.green, .yellow, .red, .blue])
        }
    }
    
    func pegs(colors: Array<Color>) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 20)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    CodeBreakerView()
}
