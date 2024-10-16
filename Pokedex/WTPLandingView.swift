//
//  WTPLandingView.swift
//  Pokedex
//
//  Created by Adam Mitro on 8/20/24.
//

import SwiftUI

struct WTPLandingView: View {
    var pokemon: [Pokemon]

    var body: some View {
        VStack {
            Text("WHO's THAT POKEMON?")
                .font(.custom("Indie Flower", size: 60))
            .multilineTextAlignment(.center)
            .padding(.top, 100)
            .foregroundStyle(Color.black)
            Spacer()
            NavigationLink(destination: WTPView(pokemon: pokemon)) {
                Text("Play")
                    .font(.custom("Indie Flower", size: 60))
                    .foregroundStyle(Color.red)
                    .navigationBarTitle("Who's That Pokemon", displayMode: .inline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

#Preview {
    WTPLandingView(pokemon: [SamplePokemon.samplePokemon])
}
