import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../utils/activity_actions.dart';
import '../utils/date_helper.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityId;

  const ActivityDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    // watch: halaman otomatis update setelah edit / ubah status.
    final provider = context.watch<ActivityProvider>();
    final activity = provider.getById(activityId);

    if (activity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Aktivitas')),
        body: Center(child: Text(provider.notFoundMessage)),
      );
    }

    final isCancelled = activity.status == ActivityStatus.cancelled;
    final isCompleted = activity.status == ActivityStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        actions: [
          IconButton(
            tooltip: 'Favorit',
            icon: Icon(activity.isFavorite ? Icons.star : Icons.star_border),
            onPressed: () =>
                context.read<ActivityProvider>().toggleFavorite(activity.id),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                activity.title,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _row('Jenis', activity.type.label),
              _row('Status', activity.status.label),
              if (activity.type == ActivityType.task)
                _row('Prioritas', activity.priority.label),
              if (activity.courseName.isNotEmpty)
                _row('Mata Kuliah', activity.courseName),
              if (activity.lecturer.isNotEmpty)
                _row('Dosen', activity.lecturer),
              if (activity.room.isNotEmpty) _row('Ruangan', activity.room),
              _row('Tanggal', DateHelper.fullDate(activity.date)),
              if (activity.startTime != null)
                _row(
                  'Waktu',
                  activity.endTime != null
                      ? '${DateHelper.time(activity.startTime!)} - '
                            '${DateHelper.time(activity.endTime!)}'
                      : DateHelper.time(activity.startTime!),
                ),
              if (activity.type == ActivityType.achievement) ...[
                _row('Progress', '${activity.progress}%'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(
                    value: activity.progress / 100,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
              _row('Favorit', activity.isFavorite ? 'Ya' : 'Tidak'),
              if (activity.description.isNotEmpty)
                _row('Deskripsi', activity.description),
              if (activity.notes.isNotEmpty) _row('Catatan', activity.notes),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => ActivityActions.edit(context, activity),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                  if (!isCompleted && !isCancelled)
                    OutlinedButton.icon(
                      onPressed: () =>
                          ActivityActions.complete(context, activity),
                      icon: const Icon(Icons.check),
                      label: const Text('Selesai'),
                    ),
                  if (!isCancelled)
                    OutlinedButton.icon(
                      onPressed: () =>
                          ActivityActions.cancel(context, activity),
                      icon: const Icon(Icons.block),
                      label: const Text('Batalkan'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => ActivityActions.delete(
                      context,
                      activity,
                      closeScreenAfter: true,
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
