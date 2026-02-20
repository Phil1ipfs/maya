import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/wallet_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/wallet_service.dart';

/// Provider for WalletService instance
final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService();
});

/// Provider for current wallet state
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final walletService = ref.watch(walletServiceProvider);
  return WalletNotifier(walletService);
});

/// Provider for transaction list
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  final walletService = ref.watch(walletServiceProvider);
  return TransactionsNotifier(walletService);
});

/// Provider for recent transactions (limited to 5)
final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.take(5).toList();
});

/// Wallet state class
class WalletState {
  final WalletModel? wallet;
  final bool isLoading;
  final String? errorMessage;

  const WalletState({
    this.wallet,
    this.isLoading = false,
    this.errorMessage,
  });

  WalletState copyWith({
    WalletModel? wallet,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  double get balance => wallet?.balance ?? 0.0;
}

/// Wallet state notifier
class WalletNotifier extends StateNotifier<WalletState> {
  final WalletService _walletService;

  WalletNotifier(this._walletService) : super(const WalletState()) {
    _loadWallet();
  }

  void _loadWallet() {
    final wallet = _walletService.getOrCreateWallet();
    state = state.copyWith(wallet: wallet);
  }

  /// Refresh wallet data
  void refresh() {
    _loadWallet();
  }

  /// Add money to wallet
  Future<TransactionModel?> addMoney({
    required double amount,
    String description = 'Cash In',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transaction = await _walletService.addMoney(
        amount: amount,
        description: description,
      );
      _loadWallet();
      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add money: ${e.toString()}',
      );
      return null;
    }
  }

  /// Send money
  Future<TransactionModel?> sendMoney({
    required double amount,
    required String recipientName,
    required String recipientNumber,
    String description = 'Send Money',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transaction = await _walletService.sendMoney(
        amount: amount,
        recipientName: recipientName,
        recipientNumber: recipientNumber,
        description: description,
      );

      if (transaction == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Insufficient balance',
        );
        return null;
      }

      _loadWallet();
      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send money: ${e.toString()}',
      );
      return null;
    }
  }

  /// Pay bills
  Future<TransactionModel?> payBills({
    required double amount,
    required String billerName,
    required String accountNumber,
    String description = 'Pay Bills',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transaction = await _walletService.payBills(
        amount: amount,
        billerName: billerName,
        accountNumber: accountNumber,
        description: description,
      );

      if (transaction == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Insufficient balance',
        );
        return null;
      }

      _loadWallet();
      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to pay bills: ${e.toString()}',
      );
      return null;
    }
  }

  /// Buy load
  Future<TransactionModel?> buyLoad({
    required double amount,
    required String phoneNumber,
    String description = 'Buy Load',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transaction = await _walletService.buyLoad(
        amount: amount,
        phoneNumber: phoneNumber,
        description: description,
      );

      if (transaction == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Insufficient balance',
        );
        return null;
      }

      _loadWallet();
      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to buy load: ${e.toString()}',
      );
      return null;
    }
  }

  /// Bank transfer
  Future<TransactionModel?> bankTransfer({
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountName,
    String description = 'Bank Transfer',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transaction = await _walletService.bankTransfer(
        amount: amount,
        bankName: bankName,
        accountNumber: accountNumber,
        accountName: accountName,
        description: description,
      );

      if (transaction == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Insufficient balance',
        );
        return null;
      }

      _loadWallet();
      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to transfer: ${e.toString()}',
      );
      return null;
    }
  }
}

/// Transactions state notifier
class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final WalletService _walletService;

  TransactionsNotifier(this._walletService) : super([]) {
    _loadTransactions();
  }

  void _loadTransactions() {
    state = _walletService.getTransactions();
  }

  /// Refresh transactions
  void refresh() {
    _loadTransactions();
  }

  /// Get transaction by ID
  TransactionModel? getById(String id) {
    return _walletService.getTransactionById(id);
  }
}
