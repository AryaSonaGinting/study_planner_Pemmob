import 'package:hive_flutter/hive_flutter.dart';

import '../models/activity.dart';
import '../models/student.dart';

/// Membaca dan menulis data ke penyimpanan lokal (Hive).
/// Berjalan di Android maupun Web tanpa perbedaan kode.
class LocalStorageService {
  static const String _activitiesBoxName = 'activities';
  static const String _profileBoxName = 'profile';
  static const String _settingsBoxName = 'settings';

  static const String _studentKey = 'student';
  static const String _seededKey = 'seeded';

  late Box<dynamic> _activitiesBox;
  late Box<dynamic> _profileBox;
  late Box<dynamic> _settingsBox;

  /// Menyiapkan Hive dan membuka semua "box" (semacam tabel).
  /// Parameter [path] hanya dipakai saat testing.
  Future<void> init({String? path}) async {
    if (path == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(path);
    }

    _activitiesBox = await Hive.openBox<dynamic>(_activitiesBoxName);
    _profileBox = await Hive.openBox<dynamic>(_profileBoxName);
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
  }

  // ---------------------------------------------------------------------------
  // Data awal
  // ---------------------------------------------------------------------------

  /// Memasukkan data contoh HANYA pada pembukaan pertama.
  /// Setelah itu tanda 'seeded' disimpan, jadi data contoh tidak akan
  /// dibuat lagi (bahkan jika pengguna menghapus semua aktivitas).
  Future<void> seedIfFirstRun({
    required List<Activity> activities,
    required Student student,
  }) async {
    final alreadySeeded = _settingsBox.get(_seededKey, defaultValue: false);
    if (alreadySeeded == true) return;

    for (final activity in activities) {
      await _activitiesBox.put(activity.id, activity.toMap());
    }
    await _profileBox.put(_studentKey, student.toMap());
    await _settingsBox.put(_seededKey, true);
  }

  // ---------------------------------------------------------------------------
  // Aktivitas
  // ---------------------------------------------------------------------------

  /// Mengambil semua aktivitas. Data yang rusak dilewati agar aplikasi
  /// tetap bisa dibuka.
  List<Activity> loadActivities() {
    final result = <Activity>[];

    for (final value in _activitiesBox.values) {
      try {
        result.add(Activity.fromMap(value as Map));
      } catch (_) {
        // Abaikan data yang formatnya salah.
      }
    }
    return result;
  }

  /// Menyimpan aktivitas baru atau memperbarui yang sudah ada (ID sama).
  Future<void> saveActivity(Activity activity) {
    return _activitiesBox.put(activity.id, activity.toMap());
  }

  Future<void> deleteActivity(String id) {
    return _activitiesBox.delete(id);
  }

  // ---------------------------------------------------------------------------
  // Profil
  // ---------------------------------------------------------------------------

  Student loadStudent() {
    final value = _profileBox.get(_studentKey);
    if (value == null) return Student.sample;
    return Student.fromMap(value as Map);
  }

  Future<void> saveStudent(Student student) {
    return _profileBox.put(_studentKey, student.toMap());
  }
}
