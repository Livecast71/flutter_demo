//
//  Favorites.swift
//  Favorites
//
//  Created by Jeffrey Snijder on 17/11/2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), favorites: ["apple", "banana", "cherry"])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let favorites = loadFavorites()
        return SimpleEntry(date: Date(), configuration: configuration, favorites: favorites)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let favorites = loadFavorites()
        let entry = SimpleEntry(date: Date(), configuration: configuration, favorites: favorites)
        
        // Refresh every 5 minutes to ensure widget stays up to date
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    private func loadFavorites() -> [String] {
        let appGroupID = "group.com.livecast.flutterApp"
        guard let userDefaults = UserDefaults(suiteName: appGroupID) else {
            print("Widget ERROR: Failed to access app group UserDefaults with ID: \(appGroupID)")
            print("Widget: Make sure FavoritesExtension has app group entitlement configured")
            // Try standard UserDefaults as fallback (for debugging)
            let standardDefaults = UserDefaults.standard
            if let fallback = standardDefaults.array(forKey: "favorites") as? [String] {
                print("Widget WARNING: Found favorites in standard UserDefaults (not app group): \(fallback)")
            }
            return []
        }
        
        // Verify we're using app group, not standard UserDefaults
        print("Widget SUCCESS: Using app group UserDefaults: \(appGroupID)")
        let favorites = userDefaults.array(forKey: "favorites") as? [String] ?? []
        print("Widget: Loaded \(favorites.count) favorites from app group: \(favorites)")
        return favorites
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let favorites: [String]
}

struct FavoritesEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("Favorites")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("\(entry.favorites.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if entry.favorites.isEmpty {
                VStack(spacing: 4) {
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("No favorites yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(entry.favorites.prefix(5), id: \.self) { favorite in
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(favorite.capitalized)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    }
                    
                    if entry.favorites.count > 5 {
                        Text("+ \(entry.favorites.count - 5) more")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
                }
            }
        }
        .padding()
    }
}

struct Favorites: Widget {
    let kind: String = "Favorites"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            FavoritesEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var defaultConfig: ConfigurationAppIntent {
        ConfigurationAppIntent()
    }
}

#Preview(as: .systemSmall) {
    Favorites()
} timeline: {
    SimpleEntry(date: .now, configuration: .defaultConfig, favorites: ["apple", "banana", "cherry", "date", "elderberry"])
    SimpleEntry(date: .now, configuration: .defaultConfig, favorites: [])
}
