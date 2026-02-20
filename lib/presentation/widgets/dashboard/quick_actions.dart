import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../common/zigzag_loading.dart';

class QuickActions extends StatefulWidget {
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
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  int? _loadingIndex;

  Future<void> _handleTap(int index, VoidCallback action) async {
    setState(() => _loadingIndex = index);

    // Brief loading animation before navigating
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _loadingIndex = null);
      action();
    }
  }

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
              isLoading: _loadingIndex == 0,
              onTap: () => _handleTap(0, widget.onAddMoney),
            ),
            _ActionButton(
              icon: Icons.send_rounded,
              label: 'Send',
              color: AppColors.accentBlue,
              isLoading: _loadingIndex == 1,
              onTap: () => _handleTap(1, widget.onSendMoney),
            ),
            _ActionButton(
              icon: Icons.receipt_long_rounded,
              label: 'Pay Bills',
              color: AppColors.accentOrange,
              isLoading: _loadingIndex == 2,
              onTap: () => _handleTap(2, widget.onPayBills),
            ),
            _ActionButton(
              icon: Icons.phone_android_rounded,
              label: 'Buy Load',
              color: AppColors.accentPurple,
              isLoading: _loadingIndex == 3,
              onTap: () => _handleTap(3, widget.onBuyLoad),
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
  final bool isLoading;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isLoading ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: isLoading
                ? Center(
                    child: ZigzagLoading(
                      width: 35,
                      height: 20,
                      activeColor: color,
                      inactiveColor: color.withValues(alpha: 0.3),
                    ),
                  )
                : Icon(
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
