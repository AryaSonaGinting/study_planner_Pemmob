import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/constants.dart';

/// Tampilan sederhana untuk halaman yang belum punya isi.
/// Dipakai ulang di Aktivitas, Favorit, dan bagian lainnya.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  /// Tombol opsional, misalnya "+ Tambah Aktivitas".
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.disabled),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
