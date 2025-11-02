//
//  FavoritesBundle.swift
//  Favorites
//
//  Created by Jeffrey Snijder on 17/11/2025.
//

import WidgetKit
import SwiftUI

@main
struct FavoritesBundle: WidgetBundle {
    var body: some Widget {
        Favorites()
        FavoritesControl()
        FavoritesLiveActivity()
    }
}
