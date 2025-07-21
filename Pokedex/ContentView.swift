import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>

    @State var filterByFavorites = false
    @State var inputSearch = ""
    @State var showSearch = false
    @State var showShiny = false
    @State var showTypeFilterMenu = false
    @State var typeFilter = FilterTypes.noFilter.rawValue

    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())

    @Environment(\.colorScheme) var colorScheme

    private var filteredPokemon: [Pokemon] {
        var pokemonArray: [Pokemon] = Array(pokedex)

        if(!inputSearch.isEmpty) {
            pokemonArray = pokemonArray.filter { $0.name!.contains(inputSearch.lowercased()) }
        }

        if typeFilter == FilterTypes.noFilter.rawValue {
            if filterByFavorites {
                pokemonArray = pokemonArray.filter { $0.favorite == filterByFavorites }
            }
        } else {
            if filterByFavorites {
                pokemonArray = pokemonArray.filter { $0.favorite == filterByFavorites && $0.types!.contains(typeFilter) }
            } else {
                pokemonArray = pokemonArray.filter { $0.types!.contains($typeFilter.wrappedValue) }
            }
        }
        return pokemonArray
    }

    var body: some View {
        switch pokemonVM.status {
        case .success:
            // Filtered List here
            NavigationStack {
                ZStack {
                    VStack {
                        if showSearch {
                            TextField(
                                "Search for Pokemon here",
                                text: $inputSearch
                            )
                            .padding()
                            .background(colorScheme == .light ? .white : .black)
                            .border(colorScheme == .light ? .black : .white, width: 1)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(colorScheme == .light ? .black : .white, lineWidth: 1)
                            )
                            .padding()
                            .shadow(radius: 5)
                        }

                        FilteredList(showFavorites: $filterByFavorites, showShiny: $showShiny, typeFilter: $typeFilter, filteredPokemon: filteredPokemon)
                            .navigationTitle(showTypeFilterMenu ? "Filter" : "Pokedex")
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    NavigationLink("WTP", destination: WTPLandingView(pokemon: Array(pokedex)))
                                        .foregroundStyle(Color.red)
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    HStack {
                                        Button {
                                            withAnimation {
                                                showTypeFilterMenu.toggle()
                                            }
                                        } label: {
                                            Label("Filter by types", systemImage: showTypeFilterMenu ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                        }
                                        .font(.title)
                                        .foregroundColor(.blue)

                                        Button {
                                            withAnimation {
                                                filterByFavorites.toggle()
                                            }
                                        } label: {
                                            Label("Filter by favorites", systemImage: filterByFavorites ? "star.fill" : "star")
                                        }
                                        .font(.title)
                                        .foregroundColor(.yellow)

                                        Button {
                                            withAnimation {
                                                showSearch.toggle()
                                            }
                                        } label: {
                                            Label("Show search", systemImage: showSearch ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                                        }
                                        .font(.title)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    }
                                }
                            }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    showShiny.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: showShiny ? "wand.and.stars" : "wand.and.stars.inverse")
                                        .foregroundColor(.white)
                                        .imageScale(.large)
                                        .padding()
                                }
                                .background(showShiny ? Color.yellow : Color.blue)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .padding(.trailing, 25)
                            }
                        }
                    }
                    if showTypeFilterMenu {
                        FilterTypesMenu(typeFilter: $typeFilter)
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.light)
}
