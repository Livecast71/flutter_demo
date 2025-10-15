# flutter_demo

A Flutter demonstration app showcasing a word list with favorites functionality and tab navigation.

## Features

### Word List Display
- Displays a randomized list of words (apple, banana, cherry, date, elderberry, fig, grape, honeydew)
- Each word is displayed in a full-width container with:
  - Random background colors
  - Rounded corners
  - Left padding for better readability
  - White text for contrast

### Favorites System
- Tap any word item to toggle it as a favorite
- Favorite status is indicated by a heart icon (filled for favorites, outline for non-favorites)
- Favorites are synchronized across both tabs

### Tab Navigation
- **List Tab**: Shows all words with their favorite status
- **Favorites Tab**: Shows only favorited words with a count in the header
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
- `android/` - Android platform-specific files
- `ios/` - iOS platform-specific files
- `web/` - Web platform-specific files
- `linux/` - Linux platform-specific files
- `windows/` - Windows platform-specific files
- `macos/` - macOS platform-specific files

## How It Works

1. **Word List**: On app start, a list of words is shuffled randomly and each word is assigned a random color
2. **Favorites**: Users can tap any word to add/remove it from favorites
3. **Tab Navigation**: Switch between viewing all words or just favorites using the bottom navigation bar
4. **State Management**: Uses Flutter's StatefulWidget to manage favorites and tab state

## Technologies Used

- Flutter Framework
- Material Design
- Dart Programming Language

## License

This project is open source and available for demonstration purposes.
