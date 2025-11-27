// lib/models/transaction_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionStatus { pending, success, failed, cancelled }

class TransactionModel {
  final String id;
  final String merchantId;
  final String merchantName;
  final String? customerId;
  final String? customerName;
  final int amount;
  final TransactionStatus status;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? paidAt;

  TransactionModel({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    this.customerId,
    this.customerName,
    required this.amount,
    required this.status,
    this.paymentMethod,
    required this.createdAt,
    this.paidAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'merchant_id': merchantId,
      'merchant_name': merchantName,
      'customer_id': customerId,
      'customer_name': customerName,
      'amount': amount,
      'status': status.name,
      'payment_method': paymentMethod,
      'created_at': Timestamp.fromDate(createdAt),
      'paid_at': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
    };
  }

  // Create from Firestore
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      merchantId: data['merchant_id'] ?? '',
      merchantName: data['merchant_name'] ?? '',
      customerId: data['customer_id'],
      customerName: data['customer_name'],
      amount: data['amount'] ?? 0,
      status: _statusFromString(data['status']),
      paymentMethod: data['payment_method'],
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paidAt: (data['paid_at'] as Timestamp?)?.toDate(),
    );
  }

  // Create from Map
  factory TransactionModel.fromMap(Map<String, dynamic> data, String id) {
    return TransactionModel(
      id: id,
      merchantId: data['merchant_id'] ?? '',
      merchantName: data['merchant_name'] ?? '',
      customerId: data['customer_id'],
      customerName: data['customer_name'],
      amount: data['amount'] ?? 0,
      status: _statusFromString(data['status']),
      paymentMethod: data['payment_method'],
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paidAt: (data['paid_at'] as Timestamp?)?.toDate(),
    );
  }

  // Helper to convert string to enum
  static TransactionStatus _statusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
        return TransactionStatus.success;
      case 'failed':
        return TransactionStatus.failed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }

  // Copy with method
  TransactionModel copyWith({
    String? id,
    String? merchantId,
    String? merchantName,
    String? customerId,
    String? customerName,
    int? amount,
    TransactionStatus? status,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? paidAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  // Helper getters
  bool get isPending => status == TransactionStatus.pending;
  bool get isSuccess => status == TransactionStatus.success;
  bool get isFailed => status == TransactionStatus.failed;
  bool get isCancelled => status == TransactionStatus.cancelled;

  // Format amount to rupiah
  String get formattedAmount {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
