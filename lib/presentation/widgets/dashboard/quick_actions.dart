import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAddMoney;
  final VoidCallback onSendMoney;
  final VoidCallback onPayBills;
  final VoidCallback onBuyLoad;

  const QuickActions({
    super.key,
    required this.onAddMoney,
    required this.onSendMoney,
    required this.onPayBills,
    required this.onBuyLoad,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionButton(
              icon: Icons.add_rounded,
              label: 'Add Money',
              color: AppColors.primary,
              onTap: onAddMoney,
            ),
            _ActionButton(
              icon: Icons.send_rounded,
              label: 'Send',
              color: AppColors.accentBlue,
              onTap: onSendMoney,
            ),
            _ActionButton(
              icon: Icons.receipt_long_rounded,
              label: 'Pay Bills',
              color: AppColors.accentOrange,
              onTap: onPayBills,
            ),
            _ActionButton(
              icon: Icons.phone_android_rounded,
              label: 'Buy Load',
              color: AppColors.accentPurple,
              onTap: onBuyLoad,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
