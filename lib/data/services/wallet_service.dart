import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/hive_constants.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';

/// Service class for wallet operations
class WalletService {
  final Box<WalletModel> _walletBox;
  final Box<TransactionModel> _transactionBox;
  final Uuid _uuid = const Uuid();

  WalletService()
      : _walletBox = Hive.box<WalletModel>(HiveConstants.walletBox),
        _transactionBox = Hive.box<TransactionModel>(HiveConstants.transactionBox);

  /// Get or create the primary wallet
  WalletModel getOrCreateWallet({
    String ownerName = 'Demo User',
    String phoneNumber = '+63 912 345 6789',
  }) {
    WalletModel? wallet = _walletBox.get(HiveConstants.primaryWalletKey);

    if (wallet == null) {
      wallet = WalletModel.create(
        id: _uuid.v4(),
        ownerName: ownerName,
        phoneNumber: phoneNumber,
        initialBalance: 0.0,
      );
      _walletBox.put(HiveConstants.primaryWalletKey, wallet);
    }

    return wallet;
  }

  /// Get current wallet
  WalletModel? getWallet() {
    return _walletBox.get(HiveConstants.primaryWalletKey);
  }

  /// Get current balance
  double getBalance() {
    final wallet = getWallet();
    return wallet?.balance ?? 0.0;
  }

  /// Add money to wallet
  Future<TransactionModel> addMoney({
    required double amount,
    String description = 'Cash In',
  }) async {
    final wallet = getOrCreateWallet();

    // Update wallet balance
    wallet.addMoney(amount);
    await wallet.save();

    // Create transaction record
    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.addMoney,
      amount: amount,
      description: description,
      createdAt: DateTime.now(),
      referenceNumber: _generateReferenceNumber(),
      balanceAfter: wallet.balance,
    );

    await _transactionBox.put(transaction.id, transaction);

    return transaction;
  }

  /// Send money
  Future<TransactionModel?> sendMoney({
    required double amount,
    required String recipientName,
    required String recipientNumber,
    String description = 'Send Money',
  }) async {
    final wallet = getOrCreateWallet();

    // Check sufficient balance
    if (!wallet.hasSufficientBalance(amount)) {
      return null; // Insufficient balance
    }

    // Deduct from wallet
    wallet.deductMoney(amount);
    await wallet.save();

    // Create transaction record
    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.sendMoney,
      amount: amount,
      description: description,
      createdAt: DateTime.now(),
      recipientName: recipientName,
      recipientNumber: recipientNumber,
      referenceNumber: _generateReferenceNumber(),
      balanceAfter: wallet.balance,
    );

    await _transactionBox.put(transaction.id, transaction);

    return transaction;
  }

  /// Pay bills
  Future<TransactionModel?> payBills({
    required double amount,
    required String billerName,
    required String accountNumber,
    String description = 'Pay Bills',
  }) async {
    final wallet = getOrCreateWallet();

    if (!wallet.hasSufficientBalance(amount)) {
      return null;
    }

    wallet.deductMoney(amount);
    await wallet.save();

    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.payBills,
      amount: amount,
      description: '$description - $billerName',
      createdAt: DateTime.now(),
      recipientName: billerName,
      recipientNumber: accountNumber,
      referenceNumber: _generateReferenceNumber(),
      balanceAfter: wallet.balance,
    );

    await _transactionBox.put(transaction.id, transaction);

    return transaction;
  }

  /// Buy load
  Future<TransactionModel?> buyLoad({
    required double amount,
    required String phoneNumber,
    String description = 'Buy Load',
  }) async {
    final wallet = getOrCreateWallet();

    if (!wallet.hasSufficientBalance(amount)) {
      return null;
    }

    wallet.deductMoney(amount);
    await wallet.save();

    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.buyLoad,
      amount: amount,
      description: description,
      createdAt: DateTime.now(),
      recipientNumber: phoneNumber,
      referenceNumber: _generateReferenceNumber(),
      balanceAfter: wallet.balance,
    );

    await _transactionBox.put(transaction.id, transaction);

    return transaction;
  }

  /// Bank transfer
  Future<TransactionModel?> bankTransfer({
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountName,
    String description = 'Bank Transfer',
  }) async {
    final wallet = getOrCreateWallet();

    if (!wallet.hasSufficientBalance(amount)) {
      return null;
    }

    wallet.deductMoney(amount);
    await wallet.save();

    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.bankTransfer,
      amount: amount,
      description: '$description - $bankName',
      createdAt: DateTime.now(),
      recipientName: accountName,
      recipientNumber: accountNumber,
      referenceNumber: _generateReferenceNumber(),
      balanceAfter: wallet.balance,
    );

    await _transactionBox.put(transaction.id, transaction);

    return transaction;
  }

  /// Get all transactions (sorted by date, newest first)
  List<TransactionModel> getTransactions() {
    final transactions = _transactionBox.values.toList();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  /// Get recent transactions (limited count)
  List<TransactionModel> getRecentTransactions({int limit = 5}) {
    final transactions = getTransactions();
    return transactions.take(limit).toList();
  }

  /// Get transaction by ID
  TransactionModel? getTransactionById(String id) {
    return _transactionBox.get(id);
  }

  /// Generate a reference number
  String _generateReferenceNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString();
    return 'REF${timestamp.substring(timestamp.length - 10)}';
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    await _walletBox.clear();
    await _transactionBox.clear();
  }
}
