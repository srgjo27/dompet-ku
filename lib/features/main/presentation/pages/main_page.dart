import 'package:dompet_ku/features/main/presentation/cubit/navigation_cubit.dart';
import 'package:dompet_ku/features/settings/presentation/pages/settings_page.dart';
import 'package:dompet_ku/features/statistics/presentation/pages/statistic_page.dart';
import 'package:dompet_ku/features/transactions/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: [HomePage(), StatisticPage(), SettingsPage()],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 36,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Transaksi',
                    isSelected: currentIndex == 0,
                    onTap: () => context.read<NavigationCubit>().changeTab(0),
                  ),
                  _NavItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    label: 'Laporan',
                    isSelected: currentIndex == 1,
                    onTap: () => context.read<NavigationCubit>().changeTab(1),
                  ),
                  _NavItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Setting',
                    isSelected: currentIndex == 2,
                    onTap: () => context.read<NavigationCubit>().changeTab(2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            if (isSelected) ...[
              Text(
                label,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
