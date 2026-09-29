import 'package:flutter/foundation.dart';

import '../models/activity.dart';
import '../models/student.dart';
import '../services/local_storage_service.dart';
import '../utils/sample_data.dart';

class ActivityProvider extends ChangeNotifier {
  final LocalStorageService _storage;

  ActivityProvider(this._storage);

  List<Activity> _activities = [];
  Student _student = Student.sample;
  // ---------- Pesan ----------
  static const String _saveError = 'Gagal menyimpan data.\nSilakan coba lagi.';
  String _errorMessage = _saveError;

  /// Pesan error terakhir (gagal simpan, atau data tidak ditemukan).
  String get errorMessage => _errorMessage;
  String get notFoundMessage => 'Data tidak ditemukan.';

  bool _fail(String message) {
    _errorMessage = message;
    return false;
  }

  // ---------- Data ----------
  List<Activity> get activities => List.unmodifiable(_activities);
  Student get student => _student;

  /// Dipanggil sekali di main.dart. Data contoh hanya dimasukkan
  /// pada pembukaan pertama (diatur oleh seedIfFirstRun).
  Future<void> load() async {
    await _storage.seedIfFirstRun(
      activities: SampleData.activities(),
      student: Student.sample,
    );
    _activities = _storage.loadActivities();
    _student = _storage.loadStudent();
    notifyListeners();
  }

  Activity? getById(String id) {
    for (final a in _activities) {
      if (a.id == id) return a;
    }
    return null;
  }

  // ---------- Data turunan (dipakai Beranda) ----------

  bool _isActive(Activity a) =>
      a.status != ActivityStatus.completed &&
      a.status != ActivityStatus.cancelled;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int _minutes(Activity a) =>
      a.startTime == null ? 0 : a.startTime!.hour * 60 + a.startTime!.minute;

  /// Aktivitas yang masih aktif dan tanggalnya hari ini.
  List<Activity> get todayActivities {
    final now = DateTime.now();
    final list =
        _activities
            .where((a) => _isActive(a) && _isSameDay(a.date, now))
            .toList()
          ..sort((a, b) => _minutes(a).compareTo(_minutes(b)));
    return list;
  }

  /// Aktivitas aktif terdekat (mulai hari ini), diurutkan tanggal lalu jam.
  List<Activity> upcomingActivities({int limit = 3}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list =
        _activities
            .where((a) => _isActive(a) && !a.date.isBefore(today))
            .toList()
          ..sort((a, b) {
            final byDate = a.date.compareTo(b.date);
            return byDate != 0 ? byDate : _minutes(a).compareTo(_minutes(b));
          });
    return list.take(limit).toList();
  }

  /// Capaian yang belum selesai/dibatalkan.
  List<Activity> get activeAchievements => _activities
      .where((a) => a.type == ActivityType.achievement && _isActive(a))
      .toList();

  List<Activity> get favorites =>
      _activities.where((a) => a.isFavorite).toList();

  /// Jumlah aktivitas aktif untuk satu jenis.
  int countActive(ActivityType type) =>
      _activities.where((a) => a.type == type && _isActive(a)).length;
  // ---------- CREATE ----------
  Future<bool> addActivity(Activity activity) async {
    final item = _applyAutoStatus(activity);
    _activities.add(item);
    return _persist(item);
  }

  // ---------- UPDATE ----------
  Future<bool> updateActivity(Activity updated) async {
    final index = _activities.indexWhere((a) => a.id == updated.id);
    if (index == -1) return _fail(notFoundMessage);
    final item = _applyAutoStatus(updated);
    _activities[index] = item;
    return _persist(item);
  }

  Future<bool> markCompleted(String id) async {
    final activity = getById(id);
    if (activity == null) return _fail(notFoundMessage);
    return updateActivity(activity.markCompleted());
  }

  Future<bool> cancelActivity(String id) async {
    final activity = getById(id);
    if (activity == null) return _fail(notFoundMessage);
    return updateActivity(activity.cancel());
  }

  Future<bool> toggleFavorite(String id) async {
    final activity = getById(id);
    if (activity == null) return _fail(notFoundMessage);
    return updateActivity(activity.toggleFavorite());
  }

  // ---------- DELETE ----------
  Future<bool> deleteActivity(String id) async {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index == -1) return _fail(notFoundMessage);
    try {
      await _storage.deleteActivity(id);
      _activities.removeAt(index);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Gagal menghapus: $e');
      return _fail(_saveError);
    }
  }

  // ---------- Profil (dipakai di tahap 11) ----------
  Future<bool> updateStudent(Student student) async {
    try {
      await _storage.saveStudent(student);
      _student = student;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Gagal menyimpan profil: $e');
      return _fail(_saveError);
    }
  }

  // ---------- Helper ----------

  /// Capaian dengan progress 100% otomatis berstatus Selesai.
  Activity _applyAutoStatus(Activity a) {
    if (a.type == ActivityType.achievement &&
        a.progress >= 100 &&
        a.status != ActivityStatus.cancelled) {
      return a.copyWith(status: ActivityStatus.completed);
    }
    return a;
  }

  /// Simpan satu aktivitas ke Hive. Return false jika gagal.
  Future<bool> _persist(Activity activity) async {
    try {
      await _storage.saveActivity(activity);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Gagal menyimpan: $e');
      return _fail(_saveError);
    }
  }
}
