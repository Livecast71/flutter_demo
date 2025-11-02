import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    let storageChannel = FlutterMethodChannel(name: "com.livecast.flutterApp/storage",
                                              binaryMessenger: controller.binaryMessenger)
    
    storageChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "saveFavorites" || call.method == "loadFavorites" || call.method == "clearFavorites" else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      // Use app group UserDefaults instead of standard UserDefaults
      // This ensures data is stored in the app group container, not standard UserDefaults
      let appGroupID = "group.com.livecast.flutterApp"
      guard let userDefaults = UserDefaults(suiteName: appGroupID) else {
        print("ERROR: Failed to access app group UserDefaults with ID: \(appGroupID)")
        print("Make sure the app group is configured in both Runner and FavoritesExtension entitlements")
        result(FlutterError(code: "STORAGE_ERROR",
                           message: "Failed to access app group. Check entitlements configuration.",
                           details: nil))
        return
      }
      
      // Verify we're using app group, not standard UserDefaults
      print("SUCCESS: Using app group UserDefaults: \(appGroupID)")
      
      switch call.method {
      case "saveFavorites":
        if let args = call.arguments as? [String: Any],
           let favorites = args["favorites"] as? [String] {
          // Save to app group (for widget access)
          userDefaults.set(favorites, forKey: "favorites")
          userDefaults.synchronize()
          
          // Also save to iCloud Key-Value Store (for cross-device sync with watch app)
          let cloudStore = NSUbiquitousKeyValueStore.default
          cloudStore.set(favorites, forKey: "favorites")
          let syncResult = cloudStore.synchronize()
          print("App: iCloud sync result: \(syncResult)")
          
          // Log all iCloud data for debugging
          print("App: === iCloud Key-Value Store Contents ===")
          let cloudDict = cloudStore.dictionaryRepresentation
          print("App: Total keys in iCloud: \(cloudDict.count)")
          for (key, value) in cloudDict {
            print("App: iCloud key '\(key)' = \(value)")
          }
          print("App: === End iCloud Contents ===")
          
          // Verify the save worked by reading it back
          if let saved = userDefaults.array(forKey: "favorites") as? [String] {
            print("App: ✅ Verified - Saved \(saved.count) favorites to app group UserDefaults: \(saved)")
          } else {
            print("App: ❌ ERROR: Failed to verify save to app group UserDefaults")
          }
          
          if let cloudSaved = cloudStore.array(forKey: "favorites") as? [String] {
            print("App: ✅ Verified - Saved \(cloudSaved.count) favorites to iCloud Key-Value Store: \(cloudSaved)")
          } else {
            print("App: ⚠️ WARNING: Failed to verify save to iCloud Key-Value Store")
            print("App: This might be normal if iCloud sync hasn't completed yet")
          }
          
          // Reload widget timeline to show updated favorites
          if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: "Favorites")
            print("App: Reloaded widget timeline")
          }
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT",
                             message: "Invalid arguments",
                             details: nil))
        }
        
      case "loadFavorites":
        // Try app group first (faster, local)
        if let favorites = userDefaults.array(forKey: "favorites") as? [String] {
          print("App: Loaded \(favorites.count) favorites from app group: \(favorites)")
          result(favorites)
        } else {
          // Fallback to iCloud if app group is empty
          let cloudStore = NSUbiquitousKeyValueStore.default
          cloudStore.synchronize()
          if let cloudFavorites = cloudStore.array(forKey: "favorites") as? [String] {
            print("App: Loaded \(cloudFavorites.count) favorites from iCloud: \(cloudFavorites)")
            // Sync back to app group for faster future access
            userDefaults.set(cloudFavorites, forKey: "favorites")
            userDefaults.synchronize()
            result(cloudFavorites)
          } else {
            print("App: No favorites found in app group or iCloud")
            result([])
          }
        }
        
      case "clearFavorites":
        // Clear from app group
        userDefaults.removeObject(forKey: "favorites")
        userDefaults.synchronize()
        // Also clear from iCloud
        let cloudStore = NSUbiquitousKeyValueStore.default
        cloudStore.removeObject(forKey: "favorites")
        cloudStore.synchronize()
        // Reload widget timeline to show cleared favorites
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadTimelines(ofKind: "Favorites")
        }
        result(nil)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
