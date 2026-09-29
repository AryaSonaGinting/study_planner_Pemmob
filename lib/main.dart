import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/activity_provider.dart';
import 'screens/main_navigation.dart';
import 'services/local_storage_service.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'utils/date_helper.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum memakai plugin sebelum runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Siapkan format tanggal bahasa Indonesia.
  await DateHelper.init();

  // Siapkan penyimpanan lokal dan muat data sebelum aplikasi tampil.
  final storage = LocalStorageService();
  await storage.init();

  final activityProvider = ActivityProvider(storage);
  await activityProvider.load();

  runApp(
    ChangeNotifierProvider(
      create: (_) => activityProvider,
      child: const StudyPlannerApp(),
    ),
  );
}

/// Widget utama aplikasi.
/// Tidak ada login: aplikasi langsung membuka halaman Beranda.
class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainNavigation(),
    );
  }
}
