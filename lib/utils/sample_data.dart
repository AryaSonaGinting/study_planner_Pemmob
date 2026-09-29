import 'package:flutter/material.dart';

import '../models/activity.dart';

/// Data contoh. Hanya dimasukkan saat aplikasi pertama kali dibuka.
class SampleData {
  static List<Activity> activities() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      Activity(
        id: 'sample-task-1',
        type: ActivityType.task,
        title: 'Tugas Pemrograman Mobile',
        description: 'Membuat aplikasi Student Study Planner.',
        courseName: 'Pemrograman Mobile',
        date: today.add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 23, minute: 59),
        priority: Priority.high,
        status: ActivityStatus.inProgress,
        isFavorite: true,
      ),
      Activity(
        id: 'sample-schedule-1',
        type: ActivityType.schedule,
        title: 'Kuliah Basis Data',
        courseName: 'Basis Data',
        lecturer: 'Budi',
        room: 'Ruang Lab 2',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      Activity(
        id: 'sample-achievement-1',
        type: ActivityType.achievement,
        title: 'Menyelesaikan Flutter Fundamental',
        description: 'Target belajar dasar-dasar Flutter.',
        date: today.add(const Duration(days: 14)),
        progress: 60,
        status: ActivityStatus.inProgress,
      ),
    ];
  }
}
