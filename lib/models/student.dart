/// Data profil mahasiswa.
class Student {
  final String name;
  final String nim;
  final String studyProgram; // program studi
  final String faculty; // fakultas
  final int semester;
  final String university;
  final String email;

  /// Lokasi foto profil. Sementara belum dipakai (null = tampilkan avatar).
  /// Disiapkan agar fitur foto bisa dikembangkan kemudian.
  final String? photoPath;

  const Student({
    required this.name,
    required this.nim,
    required this.studyProgram,
    required this.faculty,
    required this.semester,
    required this.university,
    required this.email,
    this.photoPath,
  });

  /// Data awal profil (dipakai saat aplikasi pertama kali dibuka).
  static const Student sample = Student(
    name: 'Arya',
    nim: '12345678',
    studyProgram: 'Teknik Informatika',
    faculty: 'Fakultas Ilmu Komputer',
    semester: 3,
    university: 'Universitas ABC',
    email: 'aryaa@email.com',
  );

  Student copyWith({
    String? name,
    String? nim,
    String? studyProgram,
    String? faculty,
    int? semester,
    String? university,
    String? email,
    String? photoPath,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      studyProgram: studyProgram ?? this.studyProgram,
      faculty: faculty ?? this.faculty,
      semester: semester ?? this.semester,
      university: university ?? this.university,
      email: email ?? this.email,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nim': nim,
      'studyProgram': studyProgram,
      'faculty': faculty,
      'semester': semester,
      'university': university,
      'email': email,
      'photoPath': photoPath,
    };
  }

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    return Student(
      name: map['name'] as String? ?? '',
      nim: map['nim'] as String? ?? '',
      studyProgram: map['studyProgram'] as String? ?? '',
      faculty: map['faculty'] as String? ?? '',
      semester: map['semester'] as int? ?? 1,
      university: map['university'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoPath: map['photoPath'] as String?,
    );
  }
}
