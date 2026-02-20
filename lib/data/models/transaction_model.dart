import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

/// Transaction types for wallet operations
@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  addMoney,

  @HiveField(1)
  sendMoney,

  @HiveField(2)
  payBills,

  @HiveField(3)
  buyLoad,

  @HiveField(4)
  bankTransfer,

  @HiveField(5)
  receive,
}

/// Extension to get display properties for transaction types
extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.addMoney:
        return 'Add Money';
      case TransactionType.sendMoney:
        return 'Send Money';
      case TransactionType.payBills:
        return 'Pay Bills';
      case TransactionType.buyLoad:
        return 'Buy Load';
      case TransactionType.bankTransfer:
        return 'Bank Transfer';
      case TransactionType.receive:
        return 'Received';
    }
  }

  String get icon {
    switch (this) {
      case TransactionType.addMoney:
        return '💰';
      case TransactionType.sendMoney:
        return '📤';
      case TransactionType.payBills:
        return '📄';
      case TransactionType.buyLoad:
        return '📱';
      case TransactionType.bankTransfer:
        return '🏦';
      case TransactionType.receive:
        return '📥';
    }
  }

  bool get isCredit {
    return this == TransactionType.addMoney || this == TransactionType.receive;
  }
}

/// Transaction model for storing transaction history
@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final TransactionType type;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? recipientName;

  @HiveField(6)
  final String? recipientNumber;

  @HiveField(7)
  final String? referenceNumber;

  @HiveField(8)
  final double balanceAfter;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.recipientName,
    this.recipientNumber,
    this.referenceNumber,
    required this.balanceAfter,
  });

  /// Create a copy with updated fields
  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? description,
    DateTime? createdAt,
    String? recipientName,
    String? recipientNumber,
    String? referenceNumber,
    double? balanceAfter,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      recipientName: recipientName ?? this.recipientName,
      recipientNumber: recipientNumber ?? this.recipientNumber,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      balanceAfter: balanceAfter ?? this.balanceAfter,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, type: $type, amount: $amount, description: $description)';
  }
}
