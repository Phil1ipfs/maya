# Maya - Digital Wallet Application

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [User Guide](#user-guide)
6. [Application Flow](#application-flow)
7. [Technical Implementation](#technical-implementation)
8. [Data Models](#data-models)
9. [State Management](#state-management)
10. [Local Storage](#local-storage)
11. [UI/UX Design](#uiux-design)
12. [Security Considerations](#security-considerations)

---

## Overview

Maya is a modern, offline-first digital wallet application built with Flutter. Inspired by the Maya Philippines fintech app, it provides users with essential financial services including money transfers, bill payments, mobile load purchases, and transaction history tracking.

### Key Highlights
- **Offline-First Architecture**: All data is stored locally using Hive database
- **Modern UI/UX**: Clean, intuitive interface with Maya's signature green branding
- **Secure Authentication**: PIN-based login with phone number verification
- **Real-time Balance Updates**: Instant balance reflection after transactions
- **Custom Loading Animations**: Signature zigzag loading animation throughout the app

---

## Features

### 1. User Authentication
- User registration with phone number and PIN
- Secure login with phone number and password/PIN
- Session persistence (stay logged in)

### 2. Dashboard
- Real-time balance display with card-style UI
- Quick action buttons for common transactions
- Recent transactions preview
- Pull-to-refresh functionality

### 3. Add Money (Cash In)
- Add funds to wallet
- Quick amount selection buttons (₱100, ₱500, ₱1,000, ₱2,000, ₱5,000, ₱10,000)
- Custom amount input
- Optional description/note

### 4. Send Money
- Transfer money to other users
- Recipient details (name and mobile number)
- Amount validation against balance
- Transaction confirmation

### 5. Pay Bills
- Multiple biller categories:
  - Electric Company
  - Water District
  - Internet Provider
  - Cable TV
  - Credit Card
  - Insurance
- Account number input
- Amount specification

### 6. Buy Load
- Mobile prepaid load purchase
- Preset denominations (₱10, ₱20, ₱50, ₱100, ₱200, ₱300, ₱500, ₱1,000)
- Phone number validation (11-digit format)
- Balance check before purchase

### 7. Transaction History
- Complete transaction log
- Filter by transaction type
- Transaction details including:
  - Reference number
  - Date and time
  - Amount
  - Transaction type
  - Status

### 8. User Profile
- Account information display
- Account number
- Logout functionality

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | Riverpod |
| Local Database | Hive |
| Architecture | Clean Architecture |
| Platform Support | iOS, Android, Web |

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9      # State management
  hive: ^2.2.3                   # Local database
  hive_flutter: ^1.1.0           # Hive Flutter integration
  uuid: ^4.2.2                   # Unique ID generation
  intl: ^0.19.0                  # Internationalization & formatting
```

---

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Color palette (Maya Green theme)
│   │   └── app_constants.dart         # App-wide constants
│   └── utils/
│       └── currency_formatter.dart    # Philippine Peso formatting
├── data/
│   ├── models/
│   │   ├── user_model.dart            # User data model
│   │   ├── wallet_model.dart          # Wallet data model
│   │   └── transaction_model.dart     # Transaction data model
│   ├── repositories/
│   │   ├── auth_repository.dart       # Authentication logic
│   │   ├── wallet_repository.dart     # Wallet operations
│   │   └── transaction_repository.dart # Transaction operations
│   └── services/
│       └── hive_service.dart          # Hive database service
└── presentation/
    ├── providers/
    │   ├── auth_provider.dart         # Authentication state
    │   └── wallet_provider.dart       # Wallet & transaction state
    ├── screens/
    │   ├── splash_screen.dart         # App launch screen
    │   ├── login_screen.dart          # User login
    │   ├── register_screen.dart       # New user registration
    │   ├── main_screen.dart           # Bottom navigation container
    │   ├── dashboard_screen.dart      # Home/Dashboard
    │   ├── transactions_screen.dart   # Transaction history
    │   ├── profile_screen.dart        # User profile
    │   ├── add_money_screen.dart      # Cash in
    │   ├── send_money_screen.dart     # Money transfer
    │   ├── pay_bills_screen.dart      # Bill payments
    │   └── buy_load_screen.dart       # Mobile load
    └── widgets/
        ├── common/
        │   ├── zigzag_loading.dart    # Custom loading animations
        │   └── success_screen.dart    # Transaction success
        └── dashboard/
            ├── balance_card.dart      # Balance display card
            ├── quick_actions.dart     # Action buttons
            └── recent_transactions.dart # Transaction preview
```

---

## User Guide

### Getting Started

#### 1. Registration
1. Open the Maya app
2. On the login screen, tap "Don't have an account? Register"
3. Enter your details:
   - Full Name
   - Phone Number (09XX XXX XXXX format)
   - Password (minimum 6 characters)
4. Tap "Create Account"
5. You'll be automatically logged in with ₱0.00 initial balance

#### 2. Login
1. Enter your registered phone number
2. Enter your password
3. Tap "Sign In"
4. You'll be directed to the Dashboard

### Using the Dashboard

The Dashboard is your home screen showing:
- **Balance Card**: Your current wallet balance in a green gradient card
- **Quick Actions**: Four main features (Add Money, Send, Pay Bills, Buy Load)
- **Recent Transactions**: Your last 5 transactions

### Adding Money

1. Tap "Add Money" from Quick Actions
2. Wait for the loading animation
3. Choose a quick amount OR enter custom amount
4. Add an optional description
5. Tap "Add Money"
6. View success confirmation with reference number
7. Tap "Back to Home"

### Sending Money

1. Tap "Send" from Quick Actions
2. Enter recipient details:
   - Recipient Name
   - Mobile Number
3. Enter the amount to send
4. Tap "Send Money"
5. View success confirmation
6. Balance is automatically deducted

### Paying Bills

1. Tap "Pay Bills" from Quick Actions
2. Select a biller from the grid
3. Enter your account number
4. Enter the payment amount
5. Tap "Pay Bill"
6. View success confirmation

### Buying Load

1. Tap "Buy Load" from Quick Actions
2. Enter the recipient mobile number
3. Select a load amount from the grid
4. Tap "Buy Load"
5. View success confirmation

### Viewing Transaction History

1. Tap "History" in the bottom navigation
2. View all transactions sorted by date (newest first)
3. Each transaction shows:
   - Icon indicating transaction type
   - Description
   - Date and time
   - Amount (green for incoming, red for outgoing)

### Managing Your Profile

1. Tap "Profile" in the bottom navigation
2. View your account information
3. See your account number
4. Tap "Logout" to sign out

---

## Application Flow

### Authentication Flow
```
App Launch
    ↓
Splash Screen (2 seconds)
    ↓
Check Auth State
    ↓
┌─────────────────┬─────────────────┐
│   Logged In     │   Not Logged In │
│       ↓         │        ↓        │
│  Main Screen    │  Login Screen   │
│                 │        ↓        │
│                 │  Register (opt) │
│                 │        ↓        │
│                 │  Main Screen    │
└─────────────────┴─────────────────┘
```

### Transaction Flow
```
User Initiates Transaction
         ↓
Loading Animation (Quick Action Button)
         ↓
Transaction Screen with Loading
         ↓
User Fills Form
         ↓
Validation
         ↓
┌─────────────────┬─────────────────┐
│    Valid        │    Invalid      │
│      ↓          │       ↓         │
│  Processing     │  Error Message  │
│      ↓          │       ↓         │
│  Update Wallet  │  Fix & Retry    │
│      ↓          │                 │
│ Save Transaction│                 │
│      ↓          │                 │
│ Success Screen  │                 │
│      ↓          │                 │
│  Back to Home   │                 │
└─────────────────┴─────────────────┘
```

### Navigation Flow
```
Main Screen (Scaffold with IndexedStack)
         │
         ├── Tab 0: Dashboard Screen
         │         ├── Add Money → Success → Dashboard
         │         ├── Send Money → Success → Dashboard
         │         ├── Pay Bills → Success → Dashboard
         │         └── Buy Load → Success → Dashboard
         │
         ├── Tab 1: Transactions Screen
         │
         └── Tab 2: Profile Screen
                    └── Logout → Login Screen
```

---

## Technical Implementation

### State Management with Riverpod

The app uses Riverpod for reactive state management:

#### Auth Provider
```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
```

Manages:
- User authentication state
- Login/logout operations
- Registration
- Session persistence

#### Wallet Provider
```dart
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref.read(walletRepositoryProvider));
});
```

Manages:
- Wallet balance
- Add money operations
- Send money operations
- Pay bills operations
- Buy load operations

#### Transactions Provider
```dart
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  return TransactionsNotifier(ref.read(transactionRepositoryProvider));
});
```

Manages:
- Transaction history
- Transaction filtering
- Recent transactions

### Repository Pattern

Each feature has a dedicated repository that encapsulates data operations:

```dart
class WalletRepository {
  final HiveService _hiveService;

  Future<WalletModel?> getWallet(String oderId) async {...}
  Future<void> updateBalance(String oderId, double newBalance) async {...}
  Future<TransactionModel> addMoney({...}) async {...}
  Future<TransactionModel?> sendMoney({...}) async {...}
  Future<TransactionModel?> payBills({...}) async {...}
  Future<TransactionModel?> buyLoad({...}) async {...}
}
```

---

## Data Models

### User Model
```dart
class UserModel {
  final String id;           // UUID
  final String name;         // Full name
  final String phoneNumber;  // 09XX XXX XXXX
  final String password;     // Hashed password
  final DateTime createdAt;  // Registration date
}
```

### Wallet Model
```dart
class WalletModel {
  final String id;           // UUID
  final String userId;       // Owner reference
  final double balance;      // Current balance
  final DateTime updatedAt;  // Last update
}
```

### Transaction Model
```dart
class TransactionModel {
  final String id;               // UUID
  final String oderId;          // Wallet reference
  final TransactionType type;    // Enum: addMoney, sendMoney, etc.
  final double amount;           // Transaction amount
  final String description;      // Transaction description
  final String referenceNumber;  // Unique reference (e.g., TXN-XXXXXXXX)
  final DateTime createdAt;      // Transaction date
  final String? recipientName;   // For send money
  final String? recipientNumber; // For send money/buy load
  final String? billerName;      // For pay bills
  final String? accountNumber;   // For pay bills
}
```

### Transaction Types
```dart
enum TransactionType {
  addMoney,    // Cash in
  sendMoney,   // Money transfer
  receiveMoney, // Incoming transfer
  payBills,    // Bill payment
  buyLoad,     // Mobile load
}
```

---

## Local Storage

### Hive Database Setup

The app uses three Hive boxes:

```dart
class HiveService {
  static const String userBox = 'users';
  static const String walletBox = 'wallets';
  static const String transactionBox = 'transactions';
  static const String authBox = 'auth';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(userBox);
    await Hive.openBox(walletBox);
    await Hive.openBox(transactionBox);
    await Hive.openBox(authBox);
  }
}
```

### Data Persistence

All data is stored as JSON maps in Hive boxes:

```dart
// Saving a transaction
await _transactionBox.put(transaction.id, transaction.toJson());

// Retrieving transactions
final transactions = _transactionBox.values
    .map((json) => TransactionModel.fromJson(Map<String, dynamic>.from(json)))
    .where((t) => t.oderId == oderId)
    .toList();
```

---

## UI/UX Design

### Color Palette

```dart
class AppColors {
  // Primary colors (Maya Green)
  static const Color primary = Color(0xFF00A652);
  static const Color primaryDark = Color(0xFF008542);
  static const Color primaryLight = Color(0xFF33B873);

  // Accent colors
  static const Color accentOrange = Color(0xFFFF8C42);  // Pay Bills
  static const Color accentBlue = Color(0xFF4A90D9);    // Send Money
  static const Color accentPurple = Color(0xFF7B68EE);  // Buy Load

  // Background
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
}
```

### Custom Zigzag Loading Animation

The app features a signature zigzag loading animation used throughout:

```dart
class ZigzagLoading extends StatefulWidget {
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  // Creates animated zigzag path with moving colored segment
}
```

**Usage Locations:**
- Splash screen
- Quick action buttons (while navigating)
- Bottom navigation (while switching tabs)
- Transaction screens (initial loading)
- Button loading states

### Loading States

1. **Quick Action Loading**: 500ms animation on button before navigation
2. **Screen Initial Loading**: 1500ms full-screen zigzag animation
3. **Bottom Navigation Loading**: 400ms animation while switching tabs
4. **Transaction Processing**: Circular progress indicator on submit buttons

### Responsive Design

The app is designed to work across multiple screen sizes:
- Mobile phones (primary target)
- Tablets
- Web browsers

---

## Security Considerations

### Current Implementation

1. **Password Storage**: Passwords are stored in local Hive database
2. **Session Management**: User ID stored in auth box for session persistence
3. **Input Validation**: All forms validate user input before processing
4. **Balance Checks**: Transactions verify sufficient balance before execution

### Recommended Enhancements for Production

1. **Password Hashing**: Implement bcrypt or similar hashing
2. **Biometric Authentication**: Add fingerprint/face ID support
3. **PIN Encryption**: Encrypt stored PINs
4. **Transaction Signing**: Sign transactions for integrity
5. **SSL/TLS**: Use HTTPS for any network communications
6. **Certificate Pinning**: Prevent man-in-the-middle attacks
7. **Secure Storage**: Use flutter_secure_storage for sensitive data
8. **Session Timeout**: Auto-logout after inactivity
9. **Device Binding**: Tie accounts to specific devices
10. **Fraud Detection**: Monitor for suspicious transaction patterns

---

## Building and Running

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK
- Android Studio / VS Code
- Chrome (for web development)

### Installation

```bash
# Clone or navigate to project
cd maya

# Get dependencies
flutter pub get

# Run on Chrome/Web
flutter run -d chrome

# Run on Edge
flutter run -d edge

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Build for release
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

### Debug Credentials

For testing purposes:
- **Phone Number**: Any valid format (e.g., 09123456789)
- **Password**: 123456 (minimum 6 characters)

---

## Future Enhancements

1. **QR Code Payments**: Scan to pay functionality
2. **Bank Transfers**: Link bank accounts
3. **Savings Goals**: Set and track savings targets
4. **Investment Features**: Micro-investing options
5. **Rewards Program**: Cashback and loyalty points
6. **Multi-Currency**: Support for USD, etc.
7. **Scheduled Payments**: Recurring bill payments
8. **Spending Analytics**: Charts and insights
9. **Push Notifications**: Transaction alerts
10. **Dark Mode**: Theme switching

---

## Credits

- **Inspired by**: Maya Philippines (https://www.maya.ph)
- **Framework**: Flutter by Google
- **Icons**: Material Icons
- **State Management**: Riverpod by Remi Rousselet

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024 | Initial release with core features |

---

## License

This project is created for educational purposes, demonstrating Flutter development best practices and fintech app architecture.

---

*Documentation created for Maya Digital Wallet Application*
