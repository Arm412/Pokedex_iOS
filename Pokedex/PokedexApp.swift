//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Adam Mitro on 8/1/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
