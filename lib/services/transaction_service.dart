// lib/services/transaction_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'transactions';

  // Create new transaction
  Future<String> createTransaction({
    required String merchantName,
    required int amount,
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'merchant_name': merchantName,
        'amount': amount,
        'status': 'pending',
        'payment_method': null,
        'created_at': FieldValue.serverTimestamp(),
        'paid_at': null,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Update transaction status (when customer pays)
  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
    required String paymentMethod,
  }) async {
    try {
      await _firestore.collection(_collection).doc(transactionId).update({
        'status': status,
        'payment_method': paymentMethod,
        'paid_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  // Get transaction by ID
  Future<TransactionModel?> getTransaction(String transactionId) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(transactionId)
          .get();

      if (!doc.exists) return null;

      return TransactionModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  // Listen to transaction changes (for merchant waiting payment)
  Stream<TransactionModel> listenToTransaction(String transactionId) {
    return _firestore
        .collection(_collection)
        .doc(transactionId)
        .snapshots()
        .map((doc) => TransactionModel.fromFirestore(doc));
  }

  // Cancel transaction
  Future<void> cancelTransaction(String transactionId) async {
    try {
      await _firestore.collection(_collection).doc(transactionId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      throw Exception('Failed to cancel transaction: $e');
    }
  }
}
