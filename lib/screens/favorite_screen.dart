import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state.dart';

/// Halaman Favorit: hanya menampilkan aktivitas dengan isFavorite = true.
/// Edit, hapus, selesai, batalkan, dan hapus-dari-favorit (tekan bintang)
/// sudah tersedia lewat ActivityCard.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<ActivityProvider>().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.star_border,
              title: 'Belum ada favorit',
              message:
                  'Tambahkan aktivitas ke favorit\n'
                  'untuk melihatnya di sini.',
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.length,
                  itemBuilder: (_, i) => ActivityCard(activity: favorites[i]),
                ),
              ),
            ),
    );
  }
}
