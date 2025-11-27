// lib/screens/role_selection_screen.dart

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/session_manager.dart';
import 'customer/customer_home_screen.dart';
import 'merchant/merchant_home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    // Show merchant name dialog if merchant selected
    if (role == 'merchant') {
      final merchantName = await _showMerchantNameDialog(context);
      if (merchantName == null || merchantName.isEmpty) return;

      await SessionManager.saveMerchantName(merchantName);
    }

    await SessionManager.saveRole(role);

    if (!context.mounted) return;

    // Navigate to appropriate home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => role == 'customer'
            ? const CustomerHomeScreen()
            : const MerchantHomeScreen(),
      ),
    );
  }

  Future<String?> _showMerchantNameDialog(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nama Merchant'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama toko/usaha',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                'Pilih Peran Anda',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Silakan pilih sebagai Customer atau Merchant',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Customer Card
              _RoleCard(
                icon: Icons.person_outline,
                title: 'Customer',
                description: 'Scan QR dan bayar dengan mudah',
                color: AppColors.primary,
                onTap: () => _selectRole(context, 'customer'),
              ),

              const SizedBox(height: 20),

              // Merchant Card
              _RoleCard(
                icon: Icons.store_outlined,
                title: 'Merchant',
                description: 'Terima pembayaran dari customer',
                color: AppColors.accent,
                onTap: () => _selectRole(context, 'merchant'),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
