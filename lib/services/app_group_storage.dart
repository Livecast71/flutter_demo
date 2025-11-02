import 'package:flutter/services.dart';
import 'dart:convert';

class AppGroupStorage {
  static const MethodChannel _channel = MethodChannel('com.livecast.flutterApp/storage');
  static const String _favoritesKey = 'favorites';

  /// Save favorites list to app group UserDefaults
  static Future<void> saveFavorites(List<String> favorites) async {
    try {
      await _channel.invokeMethod('saveFavorites', {
        'favorites': favorites,
      });
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  /// Load favorites list from app group UserDefaults
  static Future<List<String>> loadFavorites() async {
    try {
      final result = await _channel.invokeMethod('loadFavorites');
      if (result != null && result is List) {
        return List<String>.from(result);
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
    return [];
  }

  /// Clear all favorites
  static Future<void> clearFavorites() async {
    try {
      await _channel.invokeMethod('clearFavorites');
    } catch (e) {
      print('Error clearing favorites: $e');
    }
  }
}

