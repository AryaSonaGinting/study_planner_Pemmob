import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner_arya/models/activity.dart';
import 'package:study_planner_arya/models/student.dart';

void main() {
  group('Activity', () {
    test('toMap lalu fromMap menghasilkan data yang sama', () {
      final original = Activity(
        id: '1',
        type: ActivityType.schedule,
        title: 'Kuliah Basis Data',
        date: DateTime(2026, 9, 30),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
        lecturer: 'Budi',
        room: 'Lab 2',
        isFavorite: true,
      );

      final copy = Activity.fromMap(original.toMap());

      expect(copy.id, '1');
      expect(copy.type, ActivityType.schedule);
      expect(copy.title, 'Kuliah Basis Data');
      expect(copy.date, DateTime(2026, 9, 30));
      expect(copy.startTime, const TimeOfDay(hour: 10, minute: 0));
      expect(copy.endTime, const TimeOfDay(hour: 12, minute: 0));
      expect(copy.lecturer, 'Budi');
      expect(copy.isFavorite, true);
    });

    test('cancel mengubah status tanpa menghapus data', () {
      final task = Activity(
        id: '2',
        type: ActivityType.task,
        title: 'Tugas Pemrograman Mobile',
        date: DateTime(2026, 9, 30),
      );

      final cancelled = task.cancel();

      expect(cancelled.status, ActivityStatus.cancelled);
      expect(cancelled.title, 'Tugas Pemrograman Mobile');
      expect(cancelled.isActive, false);
    });

    test('markCompleted pada Capaian membuat progress 100', () {
      final goal = Activity(
        id: '3',
        type: ActivityType.achievement,
        title: 'Belajar Flutter',
        date: DateTime(2026, 10, 15),
        progress: 60,
      );

      final done = goal.markCompleted();

      expect(done.status, ActivityStatus.completed);
      expect(done.progress, 100);
    });

    test('withProgress 100 otomatis Selesai', () {
      final goal = Activity(
        id: '4',
        type: ActivityType.achievement,
        title: 'Membaca 2 Bab',
        date: DateTime(2026, 10, 1),
      );

      expect(goal.withProgress(50).status, ActivityStatus.inProgress);
      expect(goal.withProgress(100).status, ActivityStatus.completed);
    });

    test('toggleFavorite membalik status favorit', () {
      final task = Activity(
        id: '5',
        type: ActivityType.task,
        title: 'Tugas',
        date: DateTime(2026, 9, 30),
      );

      expect(task.toggleFavorite().isFavorite, true);
      expect(task.toggleFavorite().toggleFavorite().isFavorite, false);
    });
  });

  group('Student', () {
    test('toMap lalu fromMap menghasilkan data yang sama', () {
      final copy = Student.fromMap(Student.sample.toMap());

      expect(copy.name, 'Arya');
      expect(copy.nim, '12345678');
      expect(copy.semester, 3);
      expect(copy.email, 'aryaa@email.com');
    });
  });
}
