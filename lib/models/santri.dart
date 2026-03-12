class Santri {
  const Santri({
    this.id,
    required this.nis,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.nik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.namaAyah,
    required this.namaIbu,
    required this.noHpWali,
    required this.tahunMasuk,
    required this.angkatan,
    required this.kelasMadin,
    required this.kamar,
    required this.statusSantri,
    required this.nomorKts,
    required this.catatan,
    required this.fotoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String nis;
  final String namaLengkap;
  final String namaPanggilan;
  final String nik;
  final String tempatLahir;
  final String tanggalLahir;
  final String alamat;
  final String namaAyah;
  final String namaIbu;
  final String noHpWali;
  final String tahunMasuk;
  final String angkatan;
  final String kelasMadin;
  final String kamar;
  final String statusSantri;
  final String nomorKts;
  final String catatan;
  final String fotoPath;
  final String createdAt;
  final String updatedAt;

  factory Santri.empty() {
    return const Santri(
      nis: '',
      namaLengkap: '',
      namaPanggilan: '',
      nik: '',
      tempatLahir: '',
      tanggalLahir: '',
      alamat: '',
      namaAyah: '',
      namaIbu: '',
      noHpWali: '',
      tahunMasuk: '',
      angkatan: '',
      kelasMadin: '',
      kamar: '',
      statusSantri: 'Aktif',
      nomorKts: '',
      catatan: '',
      fotoPath: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  factory Santri.fromMap(Map<String, Object?> map) {
    return Santri(
      id: map['id'] as int?,
      nis: _asString(map['nis']),
      namaLengkap: _asString(map['nama_lengkap']),
      namaPanggilan: _asString(map['nama_panggilan']),
      nik: _asString(map['nik']),
      tempatLahir: _asString(map['tempat_lahir']),
      tanggalLahir: _asString(map['tanggal_lahir']),
      alamat: _asString(map['alamat']),
      namaAyah: _asString(map['nama_ayah']),
      namaIbu: _asString(map['nama_ibu']),
      noHpWali: _asString(map['no_hp_wali']),
      tahunMasuk: _asString(map['tahun_masuk']),
      angkatan: _asString(map['angkatan']),
      kelasMadin: _asString(map['kelas_madin']),
      kamar: _asString(map['kamar']),
      statusSantri: _asString(map['status_santri'], fallback: 'Aktif'),
      nomorKts: _asString(map['nomor_kts']),
      catatan: _asString(map['catatan']),
      fotoPath: _asString(map['foto_path']),
      createdAt: _asString(map['created_at']),
      updatedAt: _asString(map['updated_at']),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nis': nis.trim(),
      'nama_lengkap': namaLengkap.trim(),
      'nama_panggilan': namaPanggilan.trim(),
      'nik': nik.trim(),
      'tempat_lahir': tempatLahir.trim(),
      'tanggal_lahir': tanggalLahir.trim(),
      'alamat': alamat.trim(),
      'nama_ayah': namaAyah.trim(),
      'nama_ibu': namaIbu.trim(),
      'no_hp_wali': noHpWali.trim(),
      'tahun_masuk': tahunMasuk.trim(),
      'angkatan': angkatan.trim(),
      'kelas_madin': kelasMadin.trim(),
      'kamar': kamar.trim(),
      'status_santri': statusSantri.trim().isEmpty ? 'Aktif' : statusSantri.trim(),
      'nomor_kts': nomorKts.trim(),
      'catatan': catatan.trim(),
      'foto_path': fotoPath.trim(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Santri copyWith({
    int? id,
    String? nis,
    String? namaLengkap,
    String? namaPanggilan,
    String? nik,
    String? tempatLahir,
    String? tanggalLahir,
    String? alamat,
    String? namaAyah,
    String? namaIbu,
    String? noHpWali,
    String? tahunMasuk,
    String? angkatan,
    String? kelasMadin,
    String? kamar,
    String? statusSantri,
    String? nomorKts,
    String? catatan,
    String? fotoPath,
    String? createdAt,
    String? updatedAt,
  }) {
    return Santri(
      id: id ?? this.id,
      nis: nis ?? this.nis,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      namaPanggilan: namaPanggilan ?? this.namaPanggilan,
      nik: nik ?? this.nik,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      alamat: alamat ?? this.alamat,
      namaAyah: namaAyah ?? this.namaAyah,
      namaIbu: namaIbu ?? this.namaIbu,
      noHpWali: noHpWali ?? this.noHpWali,
      tahunMasuk: tahunMasuk ?? this.tahunMasuk,
      angkatan: angkatan ?? this.angkatan,
      kelasMadin: kelasMadin ?? this.kelasMadin,
      kamar: kamar ?? this.kamar,
      statusSantri: statusSantri ?? this.statusSantri,
      nomorKts: nomorKts ?? this.nomorKts,
      catatan: catatan ?? this.catatan,
      fotoPath: fotoPath ?? this.fotoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get ttl {
    if (tempatLahir.isEmpty && tanggalLahir.isEmpty) {
      return '';
    }
    if (tempatLahir.isEmpty) {
      return tanggalLahir;
    }
    if (tanggalLahir.isEmpty) {
      return tempatLahir;
    }
    return '$tempatLahir, $tanggalLahir';
  }

  String get statusLabel => statusSantri.isEmpty ? 'Aktif' : statusSantri;

  bool get hasFoto => fotoPath.trim().isNotEmpty;

  String get ringkasan {
    final parts = <String>[
      if (kelasMadin.isNotEmpty) kelasMadin,
      if (kamar.isNotEmpty) 'Kamar $kamar',
      statusLabel,
      if (hasFoto) 'Foto ada',
    ];
    return parts.join(' • ');
  }

  bool get isDataLengkap {
    final requiredFields = <String>[
      nis,
      namaLengkap,
      tempatLahir,
      tanggalLahir,
      alamat,
      namaAyah,
      noHpWali,
      tahunMasuk,
      angkatan,
      kelasMadin,
      kamar,
    ];

    return requiredFields.every((value) => value.trim().isNotEmpty);
  }

  String get searchableText {
    return [
      nis,
      namaLengkap,
      namaPanggilan,
      nik,
      tempatLahir,
      tanggalLahir,
      alamat,
      namaAyah,
      namaIbu,
      noHpWali,
      tahunMasuk,
      angkatan,
      kelasMadin,
      kamar,
      statusSantri,
      nomorKts,
      catatan,
    ].join(' ').toLowerCase();
  }

  static String _asString(Object? value, {String fallback = ''}) {
    if (value == null) {
      return fallback;
    }
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }
}
