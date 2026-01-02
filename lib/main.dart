import 'package:dompet_ku/features/main/presentation/cubit/navigation_cubit.dart';
import 'package:dompet_ku/features/main/presentation/pages/main_page.dart';
import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:dompet_ku/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);
  await di.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (context) =>
              di.sl<TransactionBloc>()..add(GetTransactionsEvent()),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => di.sl<NavigationCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'DompetKu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('id', 'ID'), Locale('en', 'US')],
        home: MainPage(),
      ),
    );
  }
}
