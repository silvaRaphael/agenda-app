import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:agenda/repositories/appointments.dart';
import 'package:agenda/repositories/bills.dart';

import 'package:agenda/screens/home.dart';

import 'package:agenda/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  await Hive.openBox('appointments');
  await Hive.openBox('bills');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentsRepository()),
        ChangeNotifierProvider(create: (_) => BillsRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.primary,
        drawerTheme: DrawerThemeData(
          elevation: 0,
          scrimColor: Colors.black.withOpacity(.05),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.poppins(
            textStyle: textTheme.bodyMedium,
            height: 1.125,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
