import 'package:flutter/material.dart';

import '../models/activity.dart';
import 'date_helper.dart';

/// Ikon untuk setiap jenis aktivitas.
extension ActivityTypeUi on ActivityType {
  IconData get icon {
    switch (this) {
      case ActivityType.task:
        return Icons.assignment_outlined;
      case ActivityType.schedule:
        return Icons.schedule;
      case ActivityType.achievement:
        return Icons.flag_outlined;
    }
  }
}

/// Teks ringkas di bawah judul aktivitas, menyesuaikan jenisnya.
///
/// Tugas     : Deadline: 30 Sep 2026, 23:59
/// Jadwal    : Hari ini, 10:00 - 12:00
/// Capaian   : Progress: 60% • Target: 14 Okt 2026
String activitySubtitle(Activity activity) {
  final start = activity.startTime;
  final end = activity.endTime;

  switch (activity.type) {
    case ActivityType.task:
      final time = start == null ? '' : ', ${DateHelper.time(start)}';
      return 'Deadline: ${DateHelper.shortDate(activity.date)}$time';

    case ActivityType.schedule:
      var time = '';
      if (start != null && end != null) {
        time = ', ${DateHelper.time(start)} - ${DateHelper.time(end)}';
      } else if (start != null) {
        time = ', ${DateHelper.time(start)}';
      }
      return '${DateHelper.relativeDate(activity.date)}$time';

    case ActivityType.achievement:
      return 'Progress: ${activity.progress}% • '
          'Target: ${DateHelper.shortDate(activity.date)}';
  }
}
