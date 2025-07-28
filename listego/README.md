# ListeGo - Smart Shopping Lists

ListeGo is a modern, feature-rich shopping list mobile app built with Flutter. It provides an intuitive interface for managing shopping lists with local notifications, data persistence, and a beautiful Material Design 3 UI.

## Features

### 🛒 Core Features
- **Create and manage shopping lists** - Organize your shopping with multiple lists
- **Add items with details** - Include quantity, notes, and reminders for each item
- **Mark items as completed** - Track your shopping progress
- **Archive completed lists** - Keep your active lists clean and organized
- **Duplicate lists** - Reuse your favorite shopping lists

### 🔔 Smart Notifications
- **Item reminders** - Set reminders for specific items
- **List completion notifications** - Get notified when you complete a list
- **Customizable notification settings** - Control when and how you receive notifications

### 🎨 Modern UI/UX
- **Material Design 3** - Beautiful, modern interface following Google's design guidelines
- **Dark/Light theme support** - Choose your preferred theme or follow system settings
- **Responsive design** - Works seamlessly across different screen sizes
- **Smooth animations** - Delightful user experience with fluid transitions

### 💾 Data Management
- **Local data persistence** - Your data stays on your device using Hive database
- **Offline functionality** - Works without internet connection
- **Data export/import** - Backup and restore your shopping lists (coming soon)

## Screens

### 1. Splash Screen
- Beautiful animated introduction to the app
- Initializes services and loads data
- Smooth transition to the main app

### 2. Home Screen
- Overview of all shopping lists
- Statistics dashboard showing total lists, items, and completion
- Quick actions to create new lists
- Archive/unarchive functionality

### 3. List Detail Screen
- View and manage items in a specific list
- Progress tracking with visual indicators
- Add, edit, and remove items
- Clear completed items functionality

### 4. Add List Screen
- Create new shopping lists with name and description
- Quick templates for common list types
- Form validation and user guidance

### 5. Add Item Screen
- Add items with quantity, notes, and reminders
- Quick add buttons for common items
- Date/time picker for setting reminders
- Real-time form validation

### 6. Settings Screen
- Notification preferences
- Theme and appearance settings
- List management options
- Data management tools

## Technical Architecture

### Project Structure
```
lib/
├── models/           # Data models with Hive annotations
├── providers/        # State management using Provider
├── screens/          # UI screens
├── services/         # Business logic and external services
├── utils/           # Utility functions and helpers
└── widgets/         # Reusable UI components
```

### Key Technologies
- **Flutter 3.16+** - Cross-platform mobile development
- **Material Design 3** - Modern UI design system
- **Hive** - Lightweight NoSQL database for local storage
- **Provider** - State management solution
- **flutter_local_notifications** - Local notification system
- **intl** - Internationalization and date formatting
- **timezone** - Timezone support for notifications

### Data Models
- **ShoppingItem** - Individual items with properties like name, quantity, notes, reminders
- **ShoppingList** - Collections of items with metadata and completion tracking
- **AppSettings** - User preferences and app configuration

### Services
- **DatabaseService** - Handles all Hive database operations
- **NotificationService** - Manages local notifications and reminders

## Getting Started

### Prerequisites
- Flutter SDK 3.16.0 or higher
- Dart SDK 3.8.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd listego
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

## Development

### Code Generation
The app uses Hive for data persistence, which requires code generation. After making changes to model classes, run:
```bash
flutter packages pub run build_runner build
```

### Testing
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## Features in Development

- [ ] Data export/import functionality
- [ ] Cloud sync capabilities
- [ ] Shopping list sharing
- [ ] Barcode scanning for items
- [ ] Voice input for adding items
- [ ] Shopping history and analytics
- [ ] Multiple language support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Hive team for the lightweight database solution
- Material Design team for the design system
- All contributors and users of the app

---

**ListeGo** - Making shopping lists smart and beautiful! 🛒✨
