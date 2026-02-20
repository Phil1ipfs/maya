import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

/// Wallet model for storing user's wallet information
@HiveType(typeId: 0)
class WalletModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  double balance;

  @HiveField(2)
  final String ownerName;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isVerified;

  WalletModel({
    required this.id,
    required this.balance,
    required this.ownerName,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
  });

  /// Create a default wallet for new users
  factory WalletModel.create({
    required String id,
    required String ownerName,
    required String phoneNumber,
    double initialBalance = 0.0,
  }) {
    final now = DateTime.now();
    return WalletModel(
      id: id,
      balance: initialBalance,
      ownerName: ownerName,
      phoneNumber: phoneNumber,
      createdAt: now,
      updatedAt: now,
      isVerified: false,
    );
  }

  /// Add money to wallet
  void addMoney(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than zero');
    }
    balance += amount;
    updatedAt = DateTime.now();
  }

  /// Deduct money from wallet
  bool deductMoney(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than zero');
    }
    if (balance < amount) {
      return false; // Insufficient balance
    }
    balance -= amount;
    updatedAt = DateTime.now();
    return true;
  }

  /// Check if wallet has sufficient balance
  bool hasSufficientBalance(double amount) {
    return balance >= amount;
  }

  /// Create a copy with updated fields
  WalletModel copyWith({
    String? id,
    double? balance,
    String? ownerName,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
  }) {
    return WalletModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return 'WalletModel(id: $id, balance: $balance, ownerName: $ownerName, phoneNumber: $phoneNumber)';
  }
}
