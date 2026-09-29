/// Nilai-nilai tetap yang dipakai di seluruh aplikasi.
/// Dikumpulkan di satu tempat agar tidak ada angka "ajaib" di kode lain.
class AppConstants {
  AppConstants._(); // mencegah class ini dibuat objeknya

  static const String appName = 'Student Study Planner';

  /// Lebar layar (px) mulai dari mana layout dianggap "lebar" (web/desktop).
  /// Di bawah angka ini: BottomNavigationBar. Di atasnya: menu di samping.
  static const double wideScreenBreakpoint = 800;

  /// Lebar maksimum konten agar tidak terlalu melebar di layar besar.
  static const double maxContentWidth = 900;
}

/// Jarak (spacing) yang konsisten.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Ukuran sudut membulat (rounded corners).
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}
