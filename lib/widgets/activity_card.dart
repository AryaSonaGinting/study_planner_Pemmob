import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../screens/activity_detail_screen.dart';
import '../utils/activity_actions.dart';
import '../utils/activity_ui.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCancelled = activity.status == ActivityStatus.cancelled;
    final isCompleted = activity.status == ActivityStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(activityId: activity.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul + tombol favorit
              Row(
                children: [
                  Expanded(
                    child: Text(
                      activity.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isCancelled
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Favorit',
                    icon: Icon(
                      activity.isFavorite ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () => context
                        .read<ActivityProvider>()
                        .toggleFavorite(activity.id),
                  ),
                ],
              ),
              // Jenis
              Row(
                children: [
                  Icon(activity.type.icon, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    activity.type.label,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(activitySubtitle(activity), style: textTheme.bodyMedium),
              if (activity.type == ActivityType.task)
                Text(
                  'Prioritas: ${activity.priority.label}',
                  style: textTheme.bodyMedium,
                ),
              const SizedBox(height: 8),
              // Status
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: activity.status.color),
                  const SizedBox(width: 6),
                  Text(
                    'Status: ${activity.status.label}',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              if (activity.type == ActivityType.achievement) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: activity.progress / 100,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
              const SizedBox(height: 8),
              // Tombol aksi
              Row(
                children: [
                  if (!isCompleted && !isCancelled)
                    TextButton(
                      onPressed: () =>
                          ActivityActions.complete(context, activity),
                      child: const Text('Selesai'),
                    ),
                  TextButton(
                    onPressed: () => ActivityActions.edit(context, activity),
                    child: const Text('Edit'),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (value) {
                      if (value == 'cancel') {
                        ActivityActions.cancel(context, activity);
                      } else if (value == 'delete') {
                        ActivityActions.delete(context, activity);
                      }
                    },
                    itemBuilder: (_) => [
                      if (!isCancelled)
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Text('Batalkan'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
