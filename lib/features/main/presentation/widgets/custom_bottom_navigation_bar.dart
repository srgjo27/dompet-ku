import 'package:dompet_ku/features/main/presentation/cubit/navigation_cubit.dart';
import 'package:dompet_ku/features/main/presentation/widgets/custom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Transaksi',
              isSelected: currentIndex == 0,
              onTap: () => context.read<NavigationCubit>().changeTab(0),
            ),
            CustomNavItem(
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart,
              label: 'Laporan',
              isSelected: currentIndex == 1,
              onTap: () => context.read<NavigationCubit>().changeTab(1),
            ),
            CustomNavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: 'Setting',
              isSelected: currentIndex == 2,
              onTap: () => context.read<NavigationCubit>().changeTab(2),
            ),
          ],
        ),
      ),
    );
  }
}
