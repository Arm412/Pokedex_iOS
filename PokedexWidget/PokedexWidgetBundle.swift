//
//  PokedexWidgetBundle.swift
//  PokedexWidget
//
//  Created by Adam Mitro on 8/8/24.
//

import WidgetKit
import SwiftUI

@main
struct PokedexWidgetBundle: WidgetBundle {
    var body: some Widget {
        PokedexWidget()
        PokedexWidgetLiveActivity()
    }
}
