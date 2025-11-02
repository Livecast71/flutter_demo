//
//  FavoritesLiveActivity.swift
//  Favorites
//
//  Created by Jeffrey Snijder on 17/11/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FavoritesAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FavoritesLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FavoritesAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FavoritesAttributes {
    fileprivate static var preview: FavoritesAttributes {
        FavoritesAttributes(name: "World")
    }
}

extension FavoritesAttributes.ContentState {
    fileprivate static var smiley: FavoritesAttributes.ContentState {
        FavoritesAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FavoritesAttributes.ContentState {
         FavoritesAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FavoritesAttributes.preview) {
   FavoritesLiveActivity()
} contentStates: {
    FavoritesAttributes.ContentState.smiley
    FavoritesAttributes.ContentState.starEyes
}
