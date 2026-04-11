# Foodz Dashboard | منصة التوصيل

A comprehensive **Food Delivery Admin Dashboard** built with Flutter. This application provides a complete management system for food delivery platforms, enabling administrators to manage restaurants, orders, couriers, categories, and more through an intuitive Arabic-language interface.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 **Authentication** | Secure login system with session management |
| 📊 **Home Dashboard** | Overview with statistics and quick actions |
| 🍽️ **Restaurants** | Manage restaurants, details, and sections |
| 📂 **Categories & Sections** | Organize food items with categories |
| 📦 **Orders** | Track and manage customer orders |
| 🚚 **Couriers** | Courier management and tracking |
| 🚫 **Blacklist** | Blocked users/entities management |
| 💰 **Money Management** | Financial tracking and reports |
| 📢 **Home Ads** | Advertisement banner management |
| 🗺️ **Maps Integration** | Google Maps for location services |
| 🔔 **Notifications** | Firebase push notifications |

---

## 🛠️ Tech Stack

**State Management:**
- `flutter_bloc` - BLoC pattern for scalable state management
- `provider` - Additional state management
- `get` - Navigation and dependency injection

**Networking & API:**
- `dio` - HTTP client for API requests
- `pretty_dio_logger` - Request/response logging

**UI & UX:**
- `responsive_sizer` - Responsive design across devices
- `flutter_animate` - Smooth animations
- `google_nav_bar` - Bottom navigation
- `carousel_slider` - Image carousels
- `shimmer` - Loading skeletons
- `cached_network_image` - Efficient image loading

**Utilities:**
- `shared_preferences` - Local storage
- `get_it` - Service locator / DI
- `dartz` - Functional programming
- `equatable` - Value equality

**Media & Location:**
- `google_maps_flutter` - Maps integration
- `geolocator` + `geocoding` - Location services
- `image_picker` - Camera/gallery access
- `file_picker` - File selection

**Notifications:**
- `firebase_core` + `firebase_messaging` - Push notifications
- `flutter_local_notifications` - Local notifications

---

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities & shared components
│   ├── utils/              # Utilities, constants, colors
│   └── ...
├── features/               # Feature-based modules
│   ├── auth/              # Authentication
│   ├── home/              # Dashboard home
│   ├── restaurants/       # Restaurant management
│   ├── restaurant_details/# Restaurant details
│   ├── category_sections/ # Categories
│   ├── sections/          # Sections
│   ├── orders/            # Order management
│   ├── couriers/          # Courier management
│   ├── blacklist/         # Blacklist management
│   ├── money_management/  # Financial features
│   ├── home_ads/          # Advertisements
│   └── product_sections/  # Products
└── main.dart              # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.8.1`
- Dart SDK compatible version
- Android Studio / Xcode (for emulators)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd foodzdashbord

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Commands

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

---

## ⚙️ Configuration

### Firebase Setup (Required for Notifications)

1. Add your `google-services.json` (Android) to `android/app/`
2. Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
3. Configure Firebase project in [Firebase Console](https://console.firebase.google.com/)

### API Configuration

Update API base URL in the core configuration files under `lib/core/`.

---

## 📱 Screenshots

> _Add your app screenshots here_

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 📞 Support

For support, contact the development team or create an issue.

---

<p align="center">Built with ❤️ using Flutter</p>
# FODZ_Dashbord
