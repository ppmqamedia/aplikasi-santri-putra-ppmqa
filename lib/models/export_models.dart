import 'santri.dart';

enum ExportPreset {
  kustom,
  kts,
  khotiminin,
  wisudaMadin,
}

extension ExportPresetX on ExportPreset {
  String get label {
    switch (this) {
      case ExportPreset.kustom:
        return 'Kustom';
      case ExportPreset.kts:
        return 'KTS';
      case ExportPreset.khotiminin:
        return 'Khotiminin';
      case ExportPreset.wisudaMadin:
        return 'Wisuda Madin';
    }
  }

  String get description {
    switch (this) {
      case ExportPreset.kustom:
        return 'Pilih kolom dan filter sesuai kebutuhan administrasi.';
      case ExportPreset.kts:
        return 'Preset kolom umum untuk kebutuhan kartu tanda santri.';
      case ExportPreset.khotiminin:
        return 'Preset kolom umum untuk pendataan khotiminin.';
      case ExportPreset.wisudaMadin:
        return 'Preset kolom umum untuk kebutuhan wisuda madin.';
    }
  }

  String get fileSlug {
    switch (this) {
      case ExportPreset.kustom:
        return 'ambil_data_santri';
      case ExportPreset.kts:
        return 'data_kts';
      case ExportPreset.khotiminin:
        return 'data_khotiminin';
      case ExportPreset.wisudaMadin:
        return 'data_wisuda_madin';
    }
  }

  List<ExportColumn> get defaultColumns {
    switch (this) {
      case ExportPreset.kustom:
        return const [
          ExportColumn.nis,
          ExportColumn.namaLengkap,
          ExportColumn.kelasMadin,
          ExportColumn.kamar,
          ExportColumn.statusSantri,
        ];
      case ExportPreset.kts:
        return const [
          ExportColumn.nomorKts,
          ExportColumn.nis,
          ExportColumn.namaLengkap,
          ExportColumn.kelasMadin,
          ExportColumn.kamar,
        ];
      case ExportPreset.khotiminin:
        return const [
          ExportColumn.nis,
          ExportColumn.namaLengkap,
          ExportColumn.ttl,
          ExportColumn.namaAyah,
          ExportColumn.kelasMadin,
          ExportColumn.angkatan,
        ];
      case ExportPreset.wisudaMadin:
        return const [
          ExportColumn.nis,
          ExportColumn.namaLengkap,
          ExportColumn.ttl,
          ExportColumn.namaAyah,
          ExportColumn.alamat,
          ExportColumn.kelasMadin,
          ExportColumn.angkatan,
        ];
    }
  }

  String get title {
    switch (this) {
      case ExportPreset.kustom:
        return 'Ambil Data Santri';
      case ExportPreset.kts:
        return 'Data KTS';
      case ExportPreset.khotiminin:
        return 'Data Khotiminin';
      case ExportPreset.wisudaMadin:
        return 'Data Wisuda Madin';
    }
  }
}

enum ExportFormat {
  csv,
  xlsx,
  docx,
  pdf,
}

extension ExportFormatX on ExportFormat {
  String get label {
    switch (this) {
      case ExportFormat.csv:
        return 'CSV';
      case ExportFormat.xlsx:
        return 'Excel';
      case ExportFormat.docx:
        return 'DOCX';
      case ExportFormat.pdf:
        return 'PDF';
    }
  }

  String get fileExtension {
    switch (this) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.xlsx:
        return 'xlsx';
      case ExportFormat.docx:
        return 'docx';
      case ExportFormat.pdf:
        return 'pdf';
    }
  }
}

enum ExportColumn {
  nis,
  namaLengkap,
  namaPanggilan,
  nik,
  tempatLahir,
  tanggalLahir,
  ttl,
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
}

extension ExportColumnX on ExportColumn {
  String get label {
    switch (this) {
      case ExportColumn.nis:
        return 'NIS';
      case ExportColumn.namaLengkap:
        return 'Nama Lengkap';
      case ExportColumn.namaPanggilan:
        return 'Nama Panggilan';
      case ExportColumn.nik:
        return 'NIK';
      case ExportColumn.tempatLahir:
        return 'Tempat Lahir';
      case ExportColumn.tanggalLahir:
        return 'Tanggal Lahir';
      case ExportColumn.ttl:
        return 'TTL';
      case ExportColumn.alamat:
        return 'Alamat';
      case ExportColumn.namaAyah:
        return 'Nama Ayah';
      case ExportColumn.namaIbu:
        return 'Nama Ibu';
      case ExportColumn.noHpWali:
        return 'No. HP Wali';
      case ExportColumn.tahunMasuk:
        return 'Tahun Masuk';
      case ExportColumn.angkatan:
        return 'Angkatan';
      case ExportColumn.kelasMadin:
        return 'Kelas Madin';
      case ExportColumn.kamar:
        return 'Kamar';
      case ExportColumn.statusSantri:
        return 'Status Santri';
      case ExportColumn.nomorKts:
        return 'Nomor KTS';
      case ExportColumn.catatan:
        return 'Catatan';
    }
  }

  String valueOf(Santri santri) {
    switch (this) {
      case ExportColumn.nis:
        return santri.nis;
      case ExportColumn.namaLengkap:
        return santri.namaLengkap;
      case ExportColumn.namaPanggilan:
        return santri.namaPanggilan;
      case ExportColumn.nik:
        return santri.nik;
      case ExportColumn.tempatLahir:
        return santri.tempatLahir;
      case ExportColumn.tanggalLahir:
        return santri.tanggalLahir;
      case ExportColumn.ttl:
        return santri.ttl;
      case ExportColumn.alamat:
        return santri.alamat;
      case ExportColumn.namaAyah:
        return santri.namaAyah;
      case ExportColumn.namaIbu:
        return santri.namaIbu;
      case ExportColumn.noHpWali:
        return santri.noHpWali;
      case ExportColumn.tahunMasuk:
        return santri.tahunMasuk;
      case ExportColumn.angkatan:
        return santri.angkatan;
      case ExportColumn.kelasMadin:
        return santri.kelasMadin;
      case ExportColumn.kamar:
        return santri.kamar;
      case ExportColumn.statusSantri:
        return santri.statusLabel;
      case ExportColumn.nomorKts:
        return santri.nomorKts;
      case ExportColumn.catatan:
        return santri.catatan;
    }
  }
}

class ExportRequest {
  const ExportRequest({
    required this.preset,
    required this.selectedColumns,
    required this.keyword,
    required this.statusFilter,
    required this.angkatan,
    required this.kelas,
    required this.kamar,
  });

  final ExportPreset preset;
  final List<ExportColumn> selectedColumns;
  final String keyword;
  final String statusFilter;
  final String angkatan;
  final String kelas;
  final String kamar;

  String get title => preset.title;

  List<String> get activeFilters {
    final values = <String>[];

    if (statusFilter.trim().isNotEmpty && statusFilter != 'Semua') {
      values.add('Status: $statusFilter');
    }
    if (angkatan.trim().isNotEmpty && angkatan != 'Semua') {
      values.add('Angkatan: $angkatan');
    }
    if (kelas.trim().isNotEmpty && kelas != 'Semua') {
      values.add('Kelas: $kelas');
    }
    if (kamar.trim().isNotEmpty && kamar != 'Semua') {
      values.add('Kamar: $kamar');
    }
    if (keyword.trim().isNotEmpty) {
      values.add('Cari: $keyword');
    }

    return values;
  }

  bool matches(Santri santri) {
    if (statusFilter.trim().isNotEmpty &&
        statusFilter != 'Semua' &&
        santri.statusLabel.toLowerCase() != statusFilter.toLowerCase()) {
      return false;
    }

    if (angkatan.trim().isNotEmpty &&
        angkatan != 'Semua' &&
        santri.angkatan.toLowerCase() != angkatan.toLowerCase()) {
      return false;
    }

    if (kelas.trim().isNotEmpty &&
        kelas != 'Semua' &&
        santri.kelasMadin.toLowerCase() != kelas.toLowerCase()) {
      return false;
    }

    if (kamar.trim().isNotEmpty &&
        kamar != 'Semua' &&
        santri.kamar.toLowerCase() != kamar.toLowerCase()) {
      return false;
    }

    if (keyword.trim().isNotEmpty &&
        !santri.searchableText.contains(keyword.toLowerCase())) {
      return false;
    }

    return true;
  }
}

class DashboardSummary {
  const DashboardSummary({
    required this.total,
    required this.aktif,
    required this.alumni,
    required this.belumLengkap,
  });

  final int total;
  final int aktif;
  final int alumni;
  final int belumLengkap;
}

class ExportResult {
  const ExportResult({
    required this.path,
    required this.rowCount,
  });

  final String path;
  final int rowCount;
}

class ImportResult {
  const ImportResult({
    required this.importedCount,
    required this.skippedCount,
    required this.message,
  });

  final int importedCount;
  final int skippedCount;
  final String message;
}
