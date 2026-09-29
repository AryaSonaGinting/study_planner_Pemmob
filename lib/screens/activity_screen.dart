import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/activity_ui.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import 'activity_form_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  /// Bottom sheet pilihan jenis aktivitas yang akan ditambahkan.
  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final type in ActivityType.values)
              ListTile(
                leading: Icon(type.icon),
                title: Text('Tambah ${type.label}'),
                onTap: () {
                  Navigator.pop(sheetContext); // tutup bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActivityFormScreen(type: type),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<ActivityProvider>().activities;

    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.add),
      ),
      body: activities.isEmpty
          ? _buildEmptyState(context)
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activities.length,
                  itemBuilder: (_, i) => ActivityCard(activity: activities[i]),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_note_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Belum ada aktivitas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan tugas, jadwal,\natau capaian pertama kamu.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showAddOptions(context),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Aktivitas'),
          ),
        ],
      ),
    );
  }
}
