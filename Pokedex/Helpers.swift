//
//  Helpers.swift
//  Pokedex
//
//  Created by Adam Mitro on 8/14/24.
//

import Foundation
import SwiftUI

enum FilterTypes: String, CaseIterable {
    case normal
    case fire
    case water
    case grass
    case flying
    case fighting
    case poison
    case electric
    case ground
    case rock
    case psychic
    case ice
    case bug
    case ghost
    case steel
    case dragon
    case dark
    case fairy
    case noFilter = "No Filter"
}

enum AnswerResult: String {
    case inProgress
    case correct
    case incorrect
    case giveUp
}
