import 'package:flutter/material.dart';

/// Format tanggal & jam bahasa Indonesia, tanpa package tambahan.
class DateHelper {
  static const _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static const _monthsFull = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // DateTime.weekday: 1 = Senin ... 7 = Minggu
  static const _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  /// Dipertahankan agar main.dart tidak perlu diubah.
  /// Tidak ada yang perlu disiapkan karena format dibuat manual.
  static Future<void> init() async {}

  /// 30 Sep 2026
  static String shortDate(DateTime date) {
    return '${date.day} ${_monthsShort[date.month - 1]} ${date.year}';
  }

  /// Rabu, 30 September 2026
  static String fullDate(DateTime date) {
    return '${_days[date.weekday - 1]}, ${date.day} '
        '${_monthsFull[date.month - 1]} ${date.year}';
  }

  /// "Hari ini", "Besok", atau "Rabu, 30 Sep 2026"
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Besok';
    return '${_days[date.weekday - 1]}, ${shortDate(date)}';
  }

  /// 10:00
  static String time(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
