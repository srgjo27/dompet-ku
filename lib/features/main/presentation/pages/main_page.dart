import 'package:dompet_ku/features/main/presentation/cubit/navigation_cubit.dart';
import 'package:dompet_ku/features/main/presentation/widgets/custom_bottom_navigation_bar.dart';
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
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: currentIndex,
          ),
        );
      },
    );
  }
}
