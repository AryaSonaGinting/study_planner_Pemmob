import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Kartu progress capaian: judul, persen, dan bar LinearProgressIndicator.
class ProgressCard extends StatelessWidget {
  final String title;

  /// Nilai 0 - 100.
  final int progress;

  const ProgressCard({super.key, required this.title, required this.progress});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('$progress%', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
