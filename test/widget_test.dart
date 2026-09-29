import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:study_planner_arya/main.dart';
import 'package:study_planner_arya/providers/activity_provider.dart';
import 'package:study_planner_arya/utils/date_helper.dart';

import 'fake_storage.dart';

void main() {
  setUpAll(() async {
    await DateHelper.init();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // Simulasikan layar HP yang cukup tinggi.
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final provider = ActivityProvider(FakeStorage());
    await tester.runAsync(() => provider.load());

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const StudyPlannerApp(),
      ),
    );
  }

  testWidgets('Beranda menampilkan greeting, statistik, dan aktivitas', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Selamat datang,'), findsOneWidget);
    expect(find.text('Arya'), findsOneWidget);
    expect(find.text('Aktivitas Hari Ini'), findsOneWidget);
    expect(find.text('Aktivitas Terdekat'), findsOneWidget);
    // Muncul di Aktivitas Terdekat dan di Favorit.
    expect(find.text('Tugas Pemrograman Mobile'), findsWidgets);
  });

  testWidgets('Navigasi bawah berpindah antar halaman', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Aktivitas'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
