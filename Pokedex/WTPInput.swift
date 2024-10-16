import SwiftUI

struct WTPInput: View {
    @Binding var guessResult: AnswerResult
    @Binding var input: String
    @Binding var pokemonName: String
    @FocusState private var inputIsFocused: Bool
    @State private var answerArray: [String] = []
    @State private var currentIndex: Int = 0
    @State private var maxLength: Int = 0

    var body: some View {
        ZStack {
            TextField(
                "",
                text: $input
            )
            .foregroundColor(.clear)
            .tint(.clear)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 100)
            .onChange(of: input) { newValue in
                currentIndex = newValue.count
                if currentIndex > maxLength {
                    input = String(input.prefix(maxLength))
                }
                updateArray()

                if (input.count < pokemonName.count) {
                    guessResult = .inProgress
                } else {
                    if (input.lowercased() == pokemonName.lowercased()) {
                        guessResult = .correct
                    } else {
                        guessResult = .incorrect
                    }
                }
            }
            .focused($inputIsFocused)
            .disableAutocorrection(true)
            .onChange(of: pokemonName) { newPokemonName in
                maxLength = newPokemonName.count
                answerArray = [String](repeating: "", count: maxLength)
                updateArray()
            }

            HStack {
                ForEach(Array(pokemonName).indices, id: \.self) { index in
                    VStack {
                        Text("\(answerArray[safe: index] ?? "")") // Safe indexing
                            .font(.custom("Indie Flower", size: 20))
                            .padding(.bottom, -50)
                            .foregroundStyle(Color.black)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(
                                guessResult == AnswerResult.inProgress ?
                                ((index == currentIndex && inputIsFocused) ? .blue : .black)
                                : .red
                            )
                            .offset(y: 24)
                            .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.horizontal, 5)
        }
        .onAppear {
            maxLength = pokemonName.count
            answerArray = [String](repeating: "", count: maxLength)
            updateArray()
        }
    }

    private func updateArray() {
        let length = answerArray.count
        if input.count <= length {
            for (index, char) in input.enumerated() {
                answerArray[index] = String(char).capitalized
            }
            // Clear any remaining characters if input is shorter than the array length
            if input.count < length {
                for index in input.count..<length {
                    answerArray[index] = ""
                }
            }
        } else {
            answerArray = Array(input.prefix(length)).map { String($0) }
        }
    }
}

// Safe subscript extension for Array
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// Example Parent View using WTPInput
struct ParentView: View {
    @State private var pokemonName: String = "Pikachu"  // Example initial value
    @State var input: String = ""
    @State var guessResult: AnswerResult = .inProgress

    var body: some View {
        VStack {
            Text("Pokemon Name: \(pokemonName)")
            WTPInput(guessResult: $guessResult, input: $input, pokemonName: $pokemonName)  // Pass binding to child
            Button("Change Pokemon") {
                pokemonName = pokemonName == "Pikachu" ? "Charizard" : "Pikachu"
            }
        }
    }
}

#Preview {
    ParentView()
}
