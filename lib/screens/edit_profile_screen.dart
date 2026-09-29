import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';

/// Form untuk mengubah data profil mahasiswa.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _nimCtrl;
  late final TextEditingController _programCtrl;
  late final TextEditingController _facultyCtrl;
  late final TextEditingController _semesterCtrl;
  late final TextEditingController _universityCtrl;
  late final TextEditingController _emailCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // read: cukup ambil data awal sekali, tidak perlu rebuild.
    final s = context.read<ActivityProvider>().student;
    _nameCtrl = TextEditingController(text: s.name);
    _nimCtrl = TextEditingController(text: s.nim);
    _programCtrl = TextEditingController(text: s.studyProgram);
    _facultyCtrl = TextEditingController(text: s.faculty);
    _semesterCtrl = TextEditingController(text: '${s.semester}');
    _universityCtrl = TextEditingController(text: s.university);
    _emailCtrl = TextEditingController(text: s.email);
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _nimCtrl,
      _programCtrl,
      _facultyCtrl,
      _semesterCtrl,
      _universityCtrl,
      _emailCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = context.read<ActivityProvider>();
    final updated = provider.student.copyWith(
      name: _nameCtrl.text.trim(),
      nim: _nimCtrl.text.trim(),
      studyProgram: _programCtrl.text.trim(),
      faculty: _facultyCtrl.text.trim(),
      semester: int.parse(_semesterCtrl.text.trim()),
      university: _universityCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    );

    final ok = await provider.updateStudent(updated);

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Profil berhasil diperbarui.' : provider.errorMessage,
        ),
      ),
    );
    if (ok) Navigator.pop(context);
  }

  String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  String? _validateSemester(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null || n < 1 || n > 14) return 'Semester harus 1 - 14';
    return null;
  }

  String? _validateEmail(String? v) {
    final email = (v ?? '').trim();
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    return valid ? null : 'Masukkan email yang valid';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _field(
                  _nameCtrl,
                  'Nama',
                  validator: (v) => _required(v, 'Nama wajib diisi'),
                ),
                _field(
                  _nimCtrl,
                  'NIM',
                  validator: (v) => _required(v, 'NIM wajib diisi'),
                ),
                _field(
                  _programCtrl,
                  'Program Studi',
                  validator: (v) => _required(v, 'Program studi wajib diisi'),
                ),
                _field(
                  _facultyCtrl,
                  'Fakultas',
                  validator: (v) => _required(v, 'Fakultas wajib diisi'),
                ),
                _field(
                  _semesterCtrl,
                  'Semester',
                  keyboardType: TextInputType.number,
                  validator: _validateSemester,
                ),
                _field(
                  _universityCtrl,
                  'Universitas',
                  validator: (v) => _required(v, 'Universitas wajib diisi'),
                ),
                _field(
                  _emailCtrl,
                  'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
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

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }
}
