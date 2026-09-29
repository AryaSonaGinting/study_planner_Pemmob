import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'edit_profile_screen.dart';

/// Halaman Profil mahasiswa.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = context.watch<ActivityProvider>().student;
    final textTheme = Theme.of(context).textTheme;

    // Foto belum dipakai: tampilkan huruf pertama nama sebagai avatar.
    final initial = student.name.isEmpty ? '?' : student.name[0].toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.black,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 36,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(child: Text(student.name, style: textTheme.headlineSmall)),
              Center(child: Text(student.email, style: textTheme.bodySmall)),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      _row('NIM', student.nim),
                      _row('Program Studi', student.studyProgram),
                      _row('Fakultas', student.faculty),
                      _row('Semester', '${student.semester}'),
                      _row('Universitas', student.university),
                      _row('Email', student.email, isLast: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}
