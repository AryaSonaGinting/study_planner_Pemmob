import 'package:flutter/material.dart';

enum ActivityType { task, schedule, achievement }

enum ActivityStatus { notStarted, inProgress, completed, cancelled }

enum Priority { low, medium, high }

/// Label teks. (Icon jenis aktivitas ada di utils/activity_ui.dart)
extension ActivityTypeX on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.task:
        return 'Tugas';
      case ActivityType.schedule:
        return 'Jadwal';
      case ActivityType.achievement:
        return 'Capaian';
    }
  }
}

extension ActivityStatusX on ActivityStatus {
  String get label {
    switch (this) {
      case ActivityStatus.notStarted:
        return 'Belum Dimulai';
      case ActivityStatus.inProgress:
        return 'Sedang Berjalan';
      case ActivityStatus.completed:
        return 'Selesai';
      case ActivityStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  /// Warna sederhana sebagai indikator status.
  Color get color {
    switch (this) {
      case ActivityStatus.notStarted:
        return Colors.grey;
      case ActivityStatus.inProgress:
        return Colors.orange;
      case ActivityStatus.completed:
        return Colors.green;
      case ActivityStatus.cancelled:
        return Colors.red;
    }
  }
}

extension PriorityX on Priority {
  String get label {
    switch (this) {
      case Priority.low:
        return 'Rendah';
      case Priority.medium:
        return 'Sedang';
      case Priority.high:
        return 'Tinggi';
    }
  }
}

/// Satu model untuk semua jenis aktivitas (tugas, jadwal, capaian).
/// Field yang tidak relevan dengan jenisnya dibiarkan kosong.
class Activity {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final String courseName; // mata kuliah
  final String lecturer; // dosen (jadwal)
  final String room; // ruangan (jadwal)
  final DateTime date; // deadline / tanggal jadwal / target tanggal
  final TimeOfDay? startTime; // jam deadline (tugas) / jam mulai (jadwal)
  final TimeOfDay? endTime; // jam selesai (jadwal)
  final Priority priority; // hanya tugas
  final ActivityStatus status;
  final bool isFavorite;
  final String notes;
  final int progress; // 0-100 (hanya capaian)

  const Activity({
    required this.id,
    required this.type,
    required this.title,
    this.description = '',
    this.courseName = '',
    this.lecturer = '',
    this.room = '',
    required this.date,
    this.startTime,
    this.endTime,
    this.priority = Priority.medium,
    this.status = ActivityStatus.notStarted,
    this.isFavorite = false,
    this.notes = '',
    this.progress = 0,
  });

  Activity copyWith({
    String? title,
    String? description,
    String? courseName,
    String? lecturer,
    String? room,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Priority? priority,
    ActivityStatus? status,
    bool? isFavorite,
    String? notes,
    int? progress,
  }) {
    return Activity(
      id: id,
      type: type,
      title: title ?? this.title,
      description: description ?? this.description,
      courseName: courseName ?? this.courseName,
      lecturer: lecturer ?? this.lecturer,
      room: room ?? this.room,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
      progress: progress ?? this.progress,
    );
  }

  // ---------- Status ----------

  /// Aktif = belum selesai dan belum dibatalkan.
  bool get isActive =>
      status != ActivityStatus.completed && status != ActivityStatus.cancelled;

  /// Tandai selesai. Untuk capaian, progress otomatis 100%.
  Activity markCompleted() {
    return copyWith(
      status: ActivityStatus.completed,
      progress: type == ActivityType.achievement ? 100 : progress,
    );
  }

  /// Batalkan (data tidak dihapus).
  Activity cancel() => copyWith(status: ActivityStatus.cancelled);

  Activity toggleFavorite() => copyWith(isFavorite: !isFavorite);

  /// Ubah progress. 100 otomatis Selesai, >0 otomatis Sedang Berjalan.
  Activity withProgress(int value) {
    final p = value.clamp(0, 100);
    if (status == ActivityStatus.cancelled) return copyWith(progress: p);
    if (p >= 100) {
      return copyWith(progress: 100, status: ActivityStatus.completed);
    }
    if (status == ActivityStatus.completed ||
        (p > 0 && status == ActivityStatus.notStarted)) {
      return copyWith(progress: p, status: ActivityStatus.inProgress);
    }
    return copyWith(progress: p);
  }

  // ---------- Penyimpanan (Hive) ----------
  // Hanya memakai tipe sederhana (String, int, bool) agar aman disimpan.

  static int? _timeToInt(TimeOfDay? t) =>
      t == null ? null : t.hour * 60 + t.minute;

  static TimeOfDay? _intToTime(int? m) =>
      m == null ? null : TimeOfDay(hour: m ~/ 60, minute: m % 60);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'courseName': courseName,
      'lecturer': lecturer,
      'room': room,
      'date': date.millisecondsSinceEpoch,
      'startTime': _timeToInt(startTime),
      'endTime': _timeToInt(endTime),
      'priority': priority.name,
      'status': status.name,
      'isFavorite': isFavorite,
      'notes': notes,
      'progress': progress,
    };
  }

  /// Melempar error jika format salah. Error ini ditangkap
  /// di LocalStorageService.loadActivities agar data rusak dilewati.
  factory Activity.fromMap(Map<dynamic, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      type: ActivityType.values.byName(map['type'] as String),
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      courseName: map['courseName'] as String? ?? '',
      lecturer: map['lecturer'] as String? ?? '',
      room: map['room'] as String? ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      startTime: _intToTime(map['startTime'] as int?),
      endTime: _intToTime(map['endTime'] as int?),
      priority: Priority.values.byName(
        map['priority'] as String? ?? Priority.medium.name,
      ),
      status: ActivityStatus.values.byName(
        map['status'] as String? ?? ActivityStatus.notStarted.name,
      ),
      isFavorite: map['isFavorite'] as bool? ?? false,
      notes: map['notes'] as String? ?? '',
      progress: map['progress'] as int? ?? 0,
    );
  }
}
