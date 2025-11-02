//
//  ContentView.swift
//  FavWatch Watch App
//
//  Created by Jeffrey Snijder on 17/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var favorites: [String] = []
    @State private var isLoading = true
    @State private var observer: NSObjectProtocol?
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else if favorites.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("No favorites yet")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Add favorites in the iOS app")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Text("They will sync via iCloud")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                    Section {
                        ForEach(favorites, id: \.self) { favorite in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(favorite.capitalized)
                                    .font(.body)
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Favorites")
                                .font(.headline)
                        }
                    } footer: {
                        Text("\(favorites.count) favorite\(favorites.count == 1 ? "" : "s")")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            loadFavorites()
            // Listen for iCloud sync changes
            observer = NotificationCenter.default.addObserver(
                forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: NSUbiquitousKeyValueStore.default,
                queue: .main
            ) { _ in
                print("Watch: iCloud data changed, reloading favorites")
                loadFavorites()
            }
        }
        .onDisappear {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        .refreshable {
            loadFavorites()
        }
    }
    
    private func loadFavorites() {
        isLoading = true
        
        // Try iCloud Key-Value Store first (for cross-device sync)
        let cloudStore = NSUbiquitousKeyValueStore.default
        let syncResult = cloudStore.synchronize()
        print("Watch: iCloud sync result: \(syncResult)")
        
        // Log all iCloud data for debugging
        print("Watch: === iCloud Key-Value Store Contents ===")
        let cloudDict = cloudStore.dictionaryRepresentation
        print("Watch: Total keys in iCloud: \(cloudDict.count)")
        for (key, value) in cloudDict {
            print("Watch: iCloud key '\(key)' = \(value)")
        }
        print("Watch: === End iCloud Contents ===")
        
        // Wait a moment for sync to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var loadedFavorites: [String] = []
            
            // Try iCloud first
            if let cloudFavorites = cloudStore.array(forKey: "favorites") as? [String], !cloudFavorites.isEmpty {
                print("Watch: ✅ Loaded \(cloudFavorites.count) favorites from iCloud: \(cloudFavorites)")
                loadedFavorites = cloudFavorites
            } else {
                print("Watch: ⚠️ No favorites found in iCloud (key 'favorites' not found or empty)")
                
                // Try app group as fallback (but log the error first)
                let appGroupID = "group.com.livecast.flutterApp"
                print("Watch: Attempting to access app group: \(appGroupID)")
                
                // Access app group UserDefaults more carefully
                if let userDefaults = UserDefaults(suiteName: appGroupID) {
                    print("Watch: ✅ Successfully accessed app group UserDefaults")
                    
                    // Log all app group keys
                    let allKeys = userDefaults.dictionaryRepresentation().keys
                    print("Watch: App group keys: \(Array(allKeys))")
                    
                    if let groupFavorites = userDefaults.array(forKey: "favorites") as? [String], !groupFavorites.isEmpty {
                        print("Watch: ✅ Loaded \(groupFavorites.count) favorites from app group: \(groupFavorites)")
                        loadedFavorites = groupFavorites
                        
                        // Sync to iCloud for future cross-device access
                        cloudStore.set(groupFavorites, forKey: "favorites")
                        let syncResult = cloudStore.synchronize()
                        print("Watch: Synced app group favorites to iCloud, sync result: \(syncResult)")
                    } else {
                        print("Watch: ⚠️ App group exists but 'favorites' key not found or empty")
                    }
                } else {
                    print("Watch: ❌ Failed to access app group UserDefaults")
                    print("Watch: Make sure app group entitlement is configured correctly")
                }
            }
            
            if loadedFavorites.isEmpty {
                print("Watch: ❌ No favorites found in iCloud or app group")
            }
            
            DispatchQueue.main.async {
                self.favorites = loadedFavorites
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
}
