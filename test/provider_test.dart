import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner_arya/models/activity.dart';
import 'package:study_planner_arya/providers/activity_provider.dart';

import 'fake_storage.dart';

void main() {
  late ActivityProvider provider;

  setUp(() async {
    provider = ActivityProvider(FakeStorage());
    await provider.load();
  });

  test('statistik dihitung dari aktivitas aktif', () {
    expect(provider.todayActivities.length, 1);
    expect(provider.countActive(ActivityType.task), 1);
    expect(provider.countActive(ActivityType.schedule), 1);
    expect(provider.countActive(ActivityType.achievement), 1);
  });

  test('aktivitas terdekat terurut dan dibatasi jumlahnya', () {
    final ids = provider.upcomingActivities(limit: 3).map((a) => a.id);
    expect(ids, ['sample-schedule-1', 'sample-task-1', 'sample-achievement-1']);
  });

  test('aktivitas selesai atau dibatalkan tidak dihitung', () async {
    await provider.markCompleted('sample-task-1');
    await provider.cancelActivity('sample-achievement-1');

    expect(provider.countActive(ActivityType.task), 0);
    expect(provider.countActive(ActivityType.achievement), 0);
    expect(provider.countActive(ActivityType.schedule), 1);
    expect(provider.upcomingActivities().map((a) => a.id), [
      'sample-schedule-1',
    ]);
  });
}
