import 'package:study_planner_arya/models/activity.dart';
import 'package:study_planner_arya/models/student.dart';
import 'package:study_planner_arya/services/local_storage_service.dart';

/// Penyimpanan palsu di memori, khusus untuk test.
class FakeStorage extends LocalStorageService {
  final Map<String, Activity> _items = {};
  Student _student = Student.sample;

  @override
  Future<void> init({String? path}) async {}

  @override
  Future<void> seedIfFirstRun({
    required List<Activity> activities,
    required Student student,
  }) async {
    for (final activity in activities) {
      _items[activity.id] = activity;
    }
    _student = student;
  }

  @override
  List<Activity> loadActivities() => _items.values.toList();

  @override
  Future<void> saveActivity(Activity activity) async {
    _items[activity.id] = activity;
  }

  @override
  Future<void> deleteActivity(String id) async {
    _items.remove(id);
  }

  @override
  Student loadStudent() => _student;

  @override
  Future<void> saveStudent(Student student) async {
    _student = student;
  }
}
