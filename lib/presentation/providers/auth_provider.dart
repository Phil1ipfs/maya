import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/services/wallet_service.dart';

/// Authentication state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? userName;
  final String? phoneNumber;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userName,
    this.phoneNumber,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? userName,
    String? phoneNumber,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage,
    );
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuthStatus();
  }

  static const String _authBoxName = 'auth_box';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userNameKey = 'user_name';
  static const String _phoneNumberKey = 'phone_number';
  static const String _pinKey = 'pin';

  /// Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      final isLoggedIn = box.get(_isLoggedInKey, defaultValue: false);

      if (isLoggedIn) {
        final userName = box.get(_userNameKey, defaultValue: 'User');
        final phoneNumber = box.get(_phoneNumberKey, defaultValue: '');

        state = state.copyWith(
          isAuthenticated: true,
          userName: userName,
          phoneNumber: phoneNumber,
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to check auth status');
    }
  }

  /// Login with phone number and PIN
  Future<bool> login({
    required String phoneNumber,
    required String pin,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final box = await Hive.openBox(_authBoxName);

      // Check if user exists
      final storedPhone = box.get(_phoneNumberKey);
      final storedPin = box.get(_pinKey);

      // For demo: accept default credentials or registered user
      final isValidCredentials =
          (phoneNumber == '09123456789' && pin == '123456') ||
          (storedPhone == phoneNumber && storedPin == pin);

      if (isValidCredentials) {
        final userName = box.get(_userNameKey, defaultValue: 'Demo User');

        await box.put(_isLoggedInKey, true);
        if (storedPhone == null) {
          await box.put(_phoneNumberKey, phoneNumber);
          await box.put(_userNameKey, 'Demo User');
        }

        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          userName: userName,
          phoneNumber: phoneNumber,
        );

        // Initialize wallet for the user
        final walletService = WalletService();
        walletService.getOrCreateWallet(
          ownerName: userName,
          phoneNumber: phoneNumber,
        );

        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid credentials',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed: ${e.toString()}',
      );
      return false;
    }
  }

  /// Register a new user
  Future<bool> register({
    required String name,
    required String phoneNumber,
    required String pin,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final box = await Hive.openBox(_authBoxName);

      // Check if phone number is already registered
      final existingPhone = box.get(_phoneNumberKey);
      if (existingPhone == phoneNumber) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Phone number already registered',
        );
        return false;
      }

      // Save user credentials
      await box.put(_userNameKey, name);
      await box.put(_phoneNumberKey, phoneNumber);
      await box.put(_pinKey, pin);
      await box.put(_isLoggedInKey, true);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userName: name,
        phoneNumber: phoneNumber,
      );

      // Initialize wallet for the new user
      final walletService = WalletService();
      walletService.getOrCreateWallet(
        ownerName: name,
        phoneNumber: phoneNumber,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed: ${e.toString()}',
      );
      return false;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.put(_isLoggedInKey, false);

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Logout failed');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      return box.get(_isLoggedInKey, defaultValue: false);
    } catch (e) {
      return false;
    }
  }
}
