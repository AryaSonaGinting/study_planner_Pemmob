import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../screens/activity_form_screen.dart';

/// Aksi yang dipakai bersama oleh card dan halaman detail.
class ActivityActions {
  static void edit(BuildContext context, Activity activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ActivityFormScreen(type: activity.type, activity: activity),
      ),
    );
  }

  static Future<void> complete(BuildContext context, Activity activity) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<ActivityProvider>();
    final ok = await provider.markCompleted(activity.id);
    _showSnack(messenger, provider, ok, 'Aktivitas ditandai selesai.');
  }

  static Future<void> cancel(BuildContext context, Activity activity) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<ActivityProvider>();
    final ok = await provider.cancelActivity(activity.id);
    _showSnack(messenger, provider, ok, 'Aktivitas dibatalkan.');
  }

  /// Dialog konfirmasi, lalu hapus jika disetujui.
  /// [closeScreenAfter] = true jika dipanggil dari halaman detail.
  static Future<void> delete(
    BuildContext context,
    Activity activity, {
    bool closeScreenAfter = false,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final provider = context.read<ActivityProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Aktivitas?'),
        content: const Text('Apakah Anda yakin ingin menghapus aktivitas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok = await provider.deleteActivity(activity.id);
    _showSnack(messenger, provider, ok, 'Aktivitas berhasil dihapus.');
    if (ok && closeScreenAfter) navigator.pop();
  }

  static void _showSnack(
    ScaffoldMessengerState messenger,
    ActivityProvider provider,
    bool ok,
    String successMessage,
  ) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(ok ? successMessage : provider.errorMessage)),
      );
  }
}
