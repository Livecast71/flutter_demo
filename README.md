# flutter_demo

A Flutter demonstration app showcasing a guitar brands list with favorites functionality, iCloud sync, iOS widget, and watchOS app support.

## Features

### Guitar Brands List Display
- Displays a randomized list of guitar brands (Fender, Gibson, Martin, Taylor, Yamaha, Ibanez, PRS, Epiphone)
- Each brand is displayed in a full-width container with:
  - Random background colors
  - Rounded corners
  - Left padding for better readability
  - White text for contrast

### Favorites System
- Tap any guitar brand item to toggle it as a favorite
- Favorite status is indicated by a heart icon (filled for favorites, outline for non-favorites)
- **Guitar sounds**: Plays a random guitar chord sound (C, G, A, D, or E major) when adding favorites
- Confetti animation with stars and hearts when adding favorites
- Favorites are synchronized across both tabs and synced via iCloud

### Tab Navigation
- **List Tab**: Shows all guitar brands with their favorite status
- **Favorites Tab**: Shows only favorited brands with a count in the header
- Bottom navigation bar for easy tab switching
- Instant tab switching without animation (using IndexedStack)

### UI Design
- Modern Material Design interface
- Full-width containers that span the screen
- Safe area support for bottom navigation
- Responsive layout with proper padding

## Getting Started

### Prerequisites
- Flutter SDK (3.38.1 or higher)
- Dart SDK (3.9.2 or higher)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Livecast71/flutter_demo.git
cd flutter_demo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

- `lib/main.dart` - Main application code with tab navigation and favorites functionality
- `lib/services/` - Service classes (app group storage, audio service)
- `lib/models/` - Data models (confetti particles)
- `lib/widgets/` - Reusable widget components
- `assets/sounds/` - Guitar chord sound files (from Wikimedia Commons)
- `AppIcons/` - App icons for all platforms
- `android/` - Android platform-specific files
- `ios/` - iOS platform-specific files (including widget and watch app)
- `web/` - Web platform-specific files
- `linux/` - Linux platform-specific files
- `windows/` - Windows platform-specific files
- `macos/` - macOS platform-specific files

## How It Works

1. **Guitar Brands List**: On app start, a list of guitar brands is shuffled randomly and each brand is assigned a random color
2. **Favorites**: Users can tap any guitar brand to add/remove it from favorites
   - Adding a favorite triggers a confetti animation and plays a random guitar chord sound
   - Sounds are sourced from Wikimedia Commons (free, open-source guitar chord samples)
3. **Tab Navigation**: Switch between viewing all brands or just favorites using the bottom navigation bar
4. **State Management**: Uses Flutter's StatefulWidget to manage favorites and tab state
5. **iCloud Sync**: Favorites are synced across devices via iCloud Key-Value Store
6. **Widget Extension**: iOS widget displays favorites on the home screen
7. **Watch App**: watchOS app shows favorites synced via iCloud
8. **Audio Feedback**: Uses `just_audio` package for cross-platform audio playback

## Technologies Used

- Flutter Framework
- Material Design
- Dart Programming Language
- just_audio - Cross-platform audio playback
- iCloud Key-Value Store - Cross-device synchronization
- App Groups - Shared storage between app and extensions
- WidgetKit - iOS widget support
- watchOS - Apple Watch app support

## License

This project is open source and available for demonstration purposes.
