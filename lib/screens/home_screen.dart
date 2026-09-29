import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../utils/constants.dart';
import '../utils/date_helper.dart';
import '../widgets/activity_summary_tile.dart';
import '../widgets/progress_card.dart';
import '../widgets/statistic_card.dart';

/// Halaman Beranda: greeting, statistik, aktivitas terdekat,
/// progress capaian, dan favorit.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: halaman otomatis dibangun ulang saat data berubah.
    final provider = context.watch<ActivityProvider>();
    final textTheme = Theme.of(context).textTheme;

    final upcoming = provider.upcomingActivities(limit: 3);
    final achievements = provider.activeAchievements;
    final favorites = provider.favorites.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // --- Greeting ---
          Text('Selamat datang,', style: textTheme.bodySmall),
          Text(provider.student.name, style: textTheme.headlineSmall),
          Text(DateHelper.fullDate(DateTime.now()), style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),

          // --- Statistik ---
          StatisticCard(
            label: 'Aktivitas Hari Ini',
            value: '${provider.todayActivities.length} Aktivitas',
            icon: Icons.today,
            isHighlighted: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: StatisticCard(
                  label: 'Tugas',
                  value: '${provider.countActive(ActivityType.task)}',
                  icon: Icons.assignment_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatisticCard(
                  label: 'Jadwal',
                  value: '${provider.countActive(ActivityType.schedule)}',
                  icon: Icons.schedule,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatisticCard(
                  label: 'Capaian',
                  value: '${provider.countActive(ActivityType.achievement)}',
                  icon: Icons.flag_outlined,
                ),
              ),
            ],
          ),

          // --- Aktivitas Terdekat ---
          const _SectionTitle('Aktivitas Terdekat'),
          if (upcoming.isEmpty)
            const _SectionMessage('Belum ada aktivitas terdekat')
          else
            ...upcoming.map(_buildTile),

          // --- Progress Capaian ---
          const _SectionTitle('Progress Capaian'),
          if (achievements.isEmpty)
            const _SectionMessage('Belum ada capaian yang berjalan')
          else
            ...achievements.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ProgressCard(title: a.title, progress: a.progress),
              ),
            ),

          // --- Aktivitas Favorit ---
          const _SectionTitle('Aktivitas Favorit'),
          if (favorites.isEmpty)
            const _SectionMessage('Belum ada aktivitas favorit')
          else
            ...favorites.map(_buildTile),
        ],
      ),
    );
  }

  Widget _buildTile(Activity activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ActivitySummaryTile(activity: activity),
    );
  }
}

/// Judul tiap bagian di Beranda.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

/// Pesan singkat jika sebuah bagian belum punya isi.
class _SectionMessage extends StatelessWidget {
  final String message;

  const _SectionMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(message, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
