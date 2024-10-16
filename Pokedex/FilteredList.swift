//
//  FilteredList.swift
//  Pokedex
//
//  Created by Adam Mitro on 8/14/24.
//

import SwiftUI

struct FilteredList: View {
    @Binding var showFavorites: Bool
    @Binding var typeFilter: String

    @Environment(\.colorScheme) var colorScheme

    var filteredPokemon: [Pokemon]

    var body: some View {
        List(filteredPokemon) { pokemon in
            NavigationLink(value: pokemon) {
                AsyncImage(url: pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)

                Text(pokemon.name!.capitalized)

                if pokemon.favorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(colorScheme == .light ? .white : .black)
        .navigationDestination(for: Pokemon.self, destination: { pokemon in
            PokemonDetail()
                .environmentObject(pokemon)
        })
    }
}

// Preview Provider
struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        // Create a binding for showFavorites and typeFilter
        // For preview purposes, you can use simple state bindings
        let showFavorites = Binding<Bool>(
            get: { true },
            set: { _ in }
        )

        let typeFilter = Binding<String>(
            get: { "all" },
            set: { _ in }
        )

        FilteredList(
            showFavorites: showFavorites,
            typeFilter: typeFilter,
            filteredPokemon: [SamplePokemon.samplePokemon]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
