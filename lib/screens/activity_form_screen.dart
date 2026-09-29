import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../utils/date_helper.dart';

/// Form untuk TAMBAH (activity == null) dan EDIT (activity != null).
class ActivityFormScreen extends StatefulWidget {
  final ActivityType type;
  final Activity? activity;

  const ActivityFormScreen({super.key, required this.type, this.activity});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _courseCtrl;
  late final TextEditingController _lecturerCtrl;
  late final TextEditingController _roomCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _startCtrl;
  late final TextEditingController _endCtrl;

  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Priority _priority = Priority.medium;
  ActivityStatus _status = ActivityStatus.notStarted;
  double _progress = 0;
  bool _isSaving = false;

  bool get _isEdit => widget.activity != null;
  ActivityType get _type => widget.type;

  @override
  void initState() {
    super.initState();
    final a = widget.activity;

    _titleCtrl = TextEditingController(text: a?.title ?? '');
    _descCtrl = TextEditingController(text: a?.description ?? '');
    _courseCtrl = TextEditingController(text: a?.courseName ?? '');
    _lecturerCtrl = TextEditingController(text: a?.lecturer ?? '');
    _roomCtrl = TextEditingController(text: a?.room ?? '');
    _notesCtrl = TextEditingController(text: a?.notes ?? '');

    _date = a?.date;
    _startTime = a?.startTime;
    _endTime = a?.endTime;

    _dateCtrl = TextEditingController(
      text: a == null ? '' : DateHelper.shortDate(a.date),
    );
    _startCtrl = TextEditingController(
      text: a?.startTime == null ? '' : DateHelper.time(a!.startTime!),
    );
    _endCtrl = TextEditingController(
      text: a?.endTime == null ? '' : DateHelper.time(a!.endTime!),
    );

    if (a != null) {
      _priority = a.priority;
      _status = a.status;
      _progress = a.progress.toDouble();
    }
  }

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descCtrl,
      _courseCtrl,
      _lecturerCtrl,
      _roomCtrl,
      _notesCtrl,
      _dateCtrl,
      _startCtrl,
      _endCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------- Picker ----------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateCtrl.text = DateHelper.shortDate(picked);
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _startCtrl.text = DateHelper.time(picked);
        } else {
          _endTime = picked;
          _endCtrl.text = DateHelper.time(picked);
        }
      });
    }
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  // ---------- Simpan ----------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Jam selesai harus setelah jam mulai.
    if (_type == ActivityType.schedule &&
        _toMinutes(_endTime!) <= _toMinutes(_startTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jam selesai harus setelah jam mulai')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final old = widget.activity;
    final activity = Activity(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      courseName: _courseCtrl.text.trim(),
      lecturer: _lecturerCtrl.text.trim(),
      room: _roomCtrl.text.trim(),
      date: _date!,
      startTime: _startTime,
      endTime: _type == ActivityType.schedule ? _endTime : null,
      priority: _priority,
      status: _status,
      isFavorite: old?.isFavorite ?? false,
      notes: _notesCtrl.text.trim(),
      progress: _progress.round(),
    );

    final provider = context.read<ActivityProvider>();
    final ok = _isEdit
        ? await provider.updateActivity(activity)
        : await provider.addActivity(activity);

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (_isEdit
                    ? 'Aktivitas berhasil diperbarui.'
                    : 'Aktivitas berhasil ditambahkan.')
              : provider.errorMessage,
        ),
      ),
    );
    if (ok) Navigator.pop(context);
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final action = _isEdit ? 'Edit' : 'Tambah';

    return Scaffold(
      appBar: AppBar(title: Text('$action ${_type.label}')),
      body: Center(
        child: ConstrainedBox(
          // Agar form tidak terlalu lebar di Web.
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _textField(
                  _titleCtrl,
                  'Judul',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Judul wajib diisi'
                      : null,
                ),
                if (_type != ActivityType.achievement)
                  _textField(_courseCtrl, 'Mata Kuliah'),
                if (_type == ActivityType.schedule) ...[
                  _textField(_lecturerCtrl, 'Dosen'),
                  _textField(_roomCtrl, 'Ruangan'),
                ] else
                  _textField(_descCtrl, 'Deskripsi', maxLines: 3),

                // Tanggal
                _pickerField(
                  controller: _dateCtrl,
                  label: switch (_type) {
                    ActivityType.task => 'Tanggal Deadline',
                    ActivityType.schedule => 'Tanggal',
                    ActivityType.achievement => 'Target Tanggal',
                  },
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                  errorText: 'Tanggal wajib dipilih',
                ),

                // Waktu
                if (_type == ActivityType.task)
                  _pickerField(
                    controller: _startCtrl,
                    label: 'Waktu Deadline',
                    icon: Icons.access_time,
                    onTap: () => _pickTime(isStart: true),
                    errorText: 'Waktu wajib dipilih',
                  ),
                if (_type == ActivityType.schedule) ...[
                  _pickerField(
                    controller: _startCtrl,
                    label: 'Jam Mulai',
                    icon: Icons.access_time,
                    onTap: () => _pickTime(isStart: true),
                    errorText: 'Jam mulai wajib dipilih',
                  ),
                  _pickerField(
                    controller: _endCtrl,
                    label: 'Jam Selesai',
                    icon: Icons.access_time,
                    onTap: () => _pickTime(isStart: false),
                    errorText: 'Jam selesai wajib dipilih',
                  ),
                ],

                // Prioritas (khusus tugas)
                if (_type == ActivityType.task)
                  _dropdown<Priority>(
                    label: 'Prioritas',
                    value: _priority,
                    items: Priority.values,
                    itemLabel: (p) => p.label,
                    onChanged: (v) => setState(() => _priority = v!),
                  ),

                // Status
                _dropdown<ActivityStatus>(
                  label: 'Status',
                  value: _status,
                  items: ActivityStatus.values,
                  itemLabel: (s) => s.label,
                  onChanged: (v) => setState(() => _status = v!),
                ),

                // Progress (khusus capaian)
                if (_type == ActivityType.achievement) ...[
                  Text('Progress: ${_progress.round()}%'),
                  Slider(
                    value: _progress,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_progress.round()}%',
                    onChanged: (v) => setState(() => _progress = v),
                  ),
                ],

                _textField(_notesCtrl, 'Catatan', maxLines: 3),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isSaving ? null : _save,
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Widget kecil agar kode tidak berulang ----------
  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _pickerField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required String errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) => (v == null || v.isEmpty) ? errorText : null,
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((i) => DropdownMenuItem(value: i, child: Text(itemLabel(i))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
