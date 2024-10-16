//
//  FilterTypesMenu.swift
//  Pokedex
//
//  Created by Adam Mitro on 8/14/24.
//

import SwiftUI

struct FilterTypesMenu: View {
    @Binding var typeFilter: String

    @Environment(\.colorScheme) var colorScheme

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View { // Need to adjust background to theme of the phone
        VStack {
            Text("Select Type to filter")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(colorScheme == .light ? .black : .white)

            HStack {
                Text("Selected filter:")
                    .font(.title)

                Text(typeFilter.capitalized)
                    .font(.title2)
                    .shadow(color: .white, radius: 1)
                    .padding([.top, .bottom], 7)
                    .padding([.leading, .trailing])
                    .background(typeFilter.capitalized != "No Filter" ? Color(typeFilter.capitalized) : colorScheme == .light ? .white : .black)
                    .cornerRadius(50)
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(FilterTypes.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .border(colorScheme == .light ? .black : .white, width: 4)
                            .background(type.rawValue.capitalized != "No Filter" ? Color(type.rawValue.capitalized) : colorScheme == .light ? .white : .black)
                            .cornerRadius(8)
                            .padding(.bottom, 4)
                            .onTapGesture {
                                typeFilter = type.rawValue
                            }
                    }
                }
                .padding()
            }
        }
        .background(colorScheme == .light ? .white : .black)
    }
}

struct PreviewWrapper: View {
    @State private var typeFilter: String = "fire"

    var body: some View {
        FilterTypesMenu(typeFilter: $typeFilter)
    }
}

struct FilterTypesMenu_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits) // Adjust as needed
            .padding()

        // Dark mode preview
        PreviewWrapper()
            .previewLayout(.sizeThatFits) // Adjust as needed
            .padding()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
