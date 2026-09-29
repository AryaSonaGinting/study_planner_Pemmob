import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/constants.dart';

/// Kartu angka ringkasan (contoh: "Tugas" -> 2).
/// [isHighlighted] membuat kartu berlatar hitam untuk data utama.
class StatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlighted;

  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mainColor = isHighlighted ? AppColors.white : AppColors.black;
    final subColor = isHighlighted
        ? AppColors.disabled
        : AppColors.textSecondary;

    return Card(
      color: isHighlighted ? AppColors.black : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: subColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(color: subColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(color: mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
