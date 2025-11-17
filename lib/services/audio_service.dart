import 'package:just_audio/just_audio.dart';
import 'dart:math';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static final Random _random = Random();
  
  // List of available guitar chord sounds
  static final List<String> _guitarSounds = [
    'assets/sounds/guitar_c_major.ogg',
    'assets/sounds/guitar_g_major.ogg',
    'assets/sounds/guitar_a_major.ogg',
    'assets/sounds/guitar_d_major.ogg',
    'assets/sounds/guitar_e_major.ogg',
  ];
  
  /// Play a random guitar chord sound
  static Future<void> playGuitarSound() async {
    try {
      final randomSound = _guitarSounds[_random.nextInt(_guitarSounds.length)];
      // just_audio uses AssetSource with full asset path
      await _player.setAsset(randomSound);
      await _player.setVolume(0.7);
      await _player.play();
    } catch (e) {
      print('Error playing guitar sound: $e');
    }
  }
  
  /// Stop any currently playing sound
  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }
  
  /// Dispose the audio player
  static Future<void> dispose() async {
    await _player.dispose();
  }
}

