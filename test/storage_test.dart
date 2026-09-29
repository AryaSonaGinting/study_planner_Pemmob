import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_planner_arya/models/activity.dart';
import 'package:study_planner_arya/providers/activity_provider.dart';
import 'package:study_planner_arya/services/local_storage_service.dart';

void main() {
  late Directory tempDir;
  late LocalStorageService storage;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('planner_test');
    storage = LocalStorageService();
    await storage.init(path: tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('pembukaan pertama memasukkan data contoh, tidak diulang', () async {
    final first = ActivityProvider(storage);
    await first.load();
    expect(first.activities.length, 3);

    // Simulasi aplikasi dibuka lagi.
    final second = ActivityProvider(storage);
    await second.load();
    expect(second.activities.length, 3);
  });

  test('aktivitas baru tetap ada setelah dimuat ulang', () async {
    final provider = ActivityProvider(storage);
    await provider.load();

    final ok = await provider.addActivity(
      Activity(
        id: 'baru-1',
        type: ActivityType.task,
        title: 'Tugas Baru',
        date: DateTime(2026, 10, 5),
      ),
    );
    expect(ok, true);

    final reloaded = ActivityProvider(storage);
    await reloaded.load();
    expect(reloaded.getById('baru-1')?.title, 'Tugas Baru');
  });

  test('favorit dan pembatalan tersimpan', () async {
    final provider = ActivityProvider(storage);
    await provider.load();

    await provider.toggleFavorite('sample-schedule-1');
    await provider.cancelActivity('sample-achievement-1');

    final reloaded = ActivityProvider(storage);
    await reloaded.load();
    expect(reloaded.getById('sample-schedule-1')!.isFavorite, true);
    expect(
      reloaded.getById('sample-achievement-1')!.status,
      ActivityStatus.cancelled,
    );
    expect(reloaded.getById('sample-achievement-1'), isNotNull);
  });

  test('hapus aktivitas tidak membuat data contoh muncul lagi', () async {
    final provider = ActivityProvider(storage);
    await provider.load();

    await provider.deleteActivity('sample-task-1');
    expect(provider.getById('sample-task-1'), isNull);

    final reloaded = ActivityProvider(storage);
    await reloaded.load();
    expect(reloaded.activities.length, 2);
  });

  test('data yang tidak ada menghasilkan pesan error', () async {
    final provider = ActivityProvider(storage);
    await provider.load();

    final ok = await provider.toggleFavorite('tidak-ada');
    expect(ok, false);
    expect(provider.errorMessage, provider.notFoundMessage);
  });
}
