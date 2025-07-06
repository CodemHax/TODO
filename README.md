# Flutter TODO App with Riverpod

A simple TODO application built with Flutter and Riverpod for state management.

## Features

- ✅ Add new tasks
- ✏️ Edit existing tasks
- 🗑️ Delete tasks
- 📱 Clean and modern UI with Material Design
- 🔄 State management with Riverpod

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio or VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/navgi.git
cd navgi
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

- `flutter_riverpod` - State management
- `uuid` - Generate unique IDs for tasks

## Project Structure

```
lib/
├── main.dart          # Main app entry point
├── item.dart          # Item model
└── item_provider.dart # Riverpod provider for state management
```

## How it Works

1. **State Management**: Uses Riverpod's StateNotifier to manage the list of TODO items
2. **CRUD Operations**: 
   - Create: Add new tasks via floating action button
   - Read: Display tasks in a scrollable list
   - Update: Edit tasks by tapping the edit icon
   - Delete: Remove tasks by tapping the delete icon
