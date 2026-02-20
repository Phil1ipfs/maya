import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../providers/wallet_provider.dart';
import '../widgets/dashboard/balance_card.dart';
import '../widgets/dashboard/quick_actions.dart';
import '../widgets/dashboard/recent_transactions.dart';
import 'add_money_screen.dart';
import 'send_money_screen.dart';
import 'pay_bills_screen.dart';
import 'buy_load_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(walletProvider.notifier).refresh();
            ref.read(transactionsProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, walletState),

                // Balance Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BalanceCard(
                    balance: walletState.balance,
                    ownerName: walletState.wallet?.ownerName ?? 'User',
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: QuickActions(
                    onAddMoney: () => _navigateToAddMoney(context),
                    onSendMoney: () => _navigateToSendMoney(context),
                    onPayBills: () => _navigateToPayBills(context),
                    onBuyLoad: () => _navigateToBuyLoad(context),
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Transactions
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RecentTransactions(),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WalletState walletState) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  walletState.wallet?.ownerName ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Notification icon
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _navigateToAddMoney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMoneyScreen()),
    );
  }

  void _navigateToSendMoney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SendMoneyScreen()),
    );
  }

  void _navigateToPayBills(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PayBillsScreen()),
    );
  }

  void _navigateToBuyLoad(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BuyLoadScreen()),
    );
  }
}
