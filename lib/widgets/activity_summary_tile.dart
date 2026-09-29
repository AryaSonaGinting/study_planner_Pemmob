import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../utils/activity_ui.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

/// Baris ringkas satu aktivitas: ikon jenis, judul, dan keterangan singkat.
class ActivitySummaryTile extends StatelessWidget {
  final Activity activity;

  /// Dikosongkan dulu. Halaman detail dibuat di Tahap 8.
  final VoidCallback? onTap;

  const ActivitySummaryTile({super.key, required this.activity, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(activity.type.icon, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      activitySubtitle(activity),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
