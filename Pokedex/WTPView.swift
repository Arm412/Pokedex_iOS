//
//  WTPView.swift
//  Pokedex
//
//  Created by Adam Mitro on 8/19/24.
//

import SwiftUI

struct WTPView: View {
    var pokemon: [Pokemon]

    @State private var input: String = ""
    @State private var showHint: Bool = false
    @State private var currentPokemon: Pokemon
    @State private var pokemonName: String = ""
    @State private var guessResult: AnswerResult = .inProgress

    @Environment(\.colorScheme) var colorScheme

    init(pokemon: [Pokemon]) {
        self.pokemon = pokemon
        let randomPokemon = pokemon.randomElement()!
        _currentPokemon = State(initialValue: randomPokemon)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                if (guessResult != .giveUp && guessResult != .correct) {
                    Button {
                        withAnimation {
                            giveUp()
                        }
                    } label: {
                        Text("Give Up")
                    }
                    .font(.custom("Indie Flower", size: 30))
                    .foregroundStyle(Color.red)
                    .padding(.horizontal, 30)
                }
                Button(action: {
                    // Action to be performed when button is tapped
                    nextPokemon()
                }) {
                    Text("Next")
                        .font(.custom("Indie Flower", size: 30))
                }
                .font(.title)
                .foregroundColor(.black)
                .padding()
            }
            AsyncImage(url: currentPokemon.sprite) { image in
                if(guessResult == .correct || guessResult == .giveUp) {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    image
                        .resizable()
                        .scaledToFit()
                        .colorMultiply(.black)
                }
            } placeholder: {
                ProgressView()
            }
            if(guessResult == .correct) {
                Text("You are correct! This Pokemon is \(pokemonName.capitalized)!")
                    .font(.custom("Indie Flower", size: 35))
                    .padding()
                    .foregroundStyle(.black)
            } else if (guessResult == .giveUp) {
                Text("This Pokemon is \(pokemonName.capitalized)!")
                    .font(.custom("Indie Flower", size: 35))
                    .padding()
                    .foregroundStyle(.black)
            } else {
                Text("Who is that Pokemon?")
                    .font(.custom("Indie Flower", size: 35))
                    .padding()
                    .foregroundStyle(.black)
                if(showHint) {
                    Text("Anagram:")
                        .font(.custom("Indie Flower", size: 40))
                        .foregroundStyle(Color.blue)
                    Text("\(String(Array(currentPokemon.name!).sorted()))")
                        .font(.custom("Indie Flower", size: 40))
                        .foregroundStyle(Color.blue)
                        .textCase(.uppercase)
                } else {
                    Button {
                        withAnimation {
                            showHint.toggle()
                        }
                    } label: {
                        Text("Show Hint")
                    }
                    .font(.custom("Indie Flower", size: 30))
                    .foregroundStyle(Color.blue)
                    .padding(.horizontal, 30)
                }

                HStack {
                    WTPInput(guessResult: $guessResult, input: $input, pokemonName: $pokemonName)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
        .onAppear {
            pokemonName = _currentPokemon.wrappedValue.name!
        }
    }

    func nextPokemon() {
        self.showHint = false
        self.input = ""
        self.guessResult = .inProgress
        self.currentPokemon = pokemon.randomElement()!
        self.pokemonName = self.currentPokemon.name!
    }

    func giveUp() {
        self.showHint = false
        self.input = ""
        self.guessResult = .giveUp
    }
}

#Preview {
    WTPView(pokemon: [SamplePokemon.samplePokemon])
}
