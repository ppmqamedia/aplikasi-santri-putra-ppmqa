import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart' as csvcodec;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/export_service.dart';
import '../data/santri_repository.dart';
import '../models/export_models.dart';
import '../models/santri.dart';

class SantriController extends ChangeNotifier {
  SantriController({
    required this.repository,
    required this.exportService,
  });

  final SantriRepository repository;
  final ExportService exportService;

  bool isLoading = false;
  bool isExporting = false;
  bool isImporting = false;
  String? errorMessage;

  List<Santri> _items = [];
  String _searchQuery = '';
  String _statusFilter = 'Semua';

  List<Santri> get items => List.unmodifiable(_items);
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;

  List<Santri> get filteredItems {
    return _items.where((santri) {
      final matchesStatus = _statusFilter == 'Semua' ||
          santri.statusLabel.toLowerCase() == _statusFilter.toLowerCase();

      final matchesSearch = _searchQuery.trim().isEmpty ||
          santri.searchableText.contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
  }

  DashboardSummary get summary {
    final total = _items.length;
    final aktif =
        _items.where((item) => item.statusLabel.toLowerCase() == 'aktif').length;
    final alumni =
        _items.where((item) => item.statusLabel.toLowerCase() == 'alumni').length;
    final belumLengkap = _items.where((item) => !item.isDataLengkap).length;

    return DashboardSummary(
      total: total,
      aktif: aktif,
      alumni: alumni,
      belumLengkap: belumLengkap,
    );
  }

  List<String> get availableAngkatan => _distinctSorted(
        _items.map((item) => item.angkatan),
      );

  List<String> get availableKelas => _distinctSorted(
        _items.map((item) => item.kelasMadin),
      );

  List<String> get availableKamar => _distinctSorted(
        _items.map((item) => item.kamar),
      );

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _items = await repository.fetchAll();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  void setStatusFilter(String value) {
    _statusFilter = value;
    notifyListeners();
  }

  Future<void> saveSantri(Santri santri) async {
    try {
      await repository.save(santri);
      await load();
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteSantri(Santri santri) async {
    if (santri.id == null) {
      return;
    }

    try {
      await repository.delete(santri.id!);
      await load();
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<Santri> previewForExport(ExportRequest request) {
    return _items.where(request.matches).toList();
  }

  Future<ExportResult> export(
    ExportRequest request,
    ExportFormat format,
  ) async {
    isExporting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final selectedRows = previewForExport(request);
      final result = await exportService.export(
        santriList: selectedRows,
        request: request,
        format: format,
      );
      return result;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    } finally {
      isExporting = false;
      notifyListeners();
    }
  }

  Future<ImportResult?> pickAndImportCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    return importCsvFile(result.files.single);
  }

  Future<ImportResult> importCsvFile(PlatformFile file) async {
    isImporting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final bytes = file.bytes ?? await File(file.path!).readAsBytes();
      final content = utf8.decode(bytes, allowMalformed: true);

      final rows = csvcodec.CsvToListConverter(
        shouldParseNumbers: false,
      ).convert(content);

      if (rows.isEmpty) {
        return const ImportResult(
          importedCount: 0,
          skippedCount: 0,
          message: 'File CSV kosong.',
        );
      }

      final headers = rows.first.map((cell) => cell.toString()).toList();
      final santriRows = <Santri>[];
      var localSkipped = 0;

      for (final row in rows.skip(1)) {
        final values = row.map((cell) => cell.toString()).toList();

        if (values.every((value) => value.trim().isEmpty)) {
          continue;
        }

        final rawMap = <String, String>{};
        for (var i = 0; i < headers.length; i++) {
          rawMap[headers[i]] = i < values.length ? values[i] : '';
        }

        final santri = _buildSantriFromImport(rawMap);
        if (santri == null) {
          localSkipped += 1;
          continue;
        }
        santriRows.add(santri);
      }

      final result = await repository.importMany(santriRows);
      await load();

      final skippedCount = result.skippedCount + localSkipped;
      return ImportResult(
        importedCount: result.importedCount,
        skippedCount: skippedCount,
        message:
            'Impor selesai. Berhasil: ${result.importedCount}, dilewati: $skippedCount.',
      );
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    } finally {
      isImporting = false;
      notifyListeners();
    }
  }

  Santri? _buildSantriFromImport(Map<String, String> rawMap) {
    final normalized = <String, String>{};

    rawMap.forEach((key, value) {
      normalized[_normalizeHeader(key)] = value.trim();
    });

    String read(List<String> aliases) {
      for (final alias in aliases) {
        final value = normalized[_normalizeHeader(alias)];
        if (value != null && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      return '';
    }

    var tempatLahir = read([
      'tempat_lahir',
      'tempat lahir',
      'tmplahir',
    ]);

    var tanggalLahir = read([
      'tanggal_lahir',
      'tanggal lahir',
      'tgl_lahir',
      'tgllahir',
    ]);

    final ttlRaw = read(['ttl']);
    if (ttlRaw.isNotEmpty && (tempatLahir.isEmpty || tanggalLahir.isEmpty)) {
      if (ttlRaw.contains(',')) {
        final parts = ttlRaw.split(',');
        if (tempatLahir.isEmpty && parts.isNotEmpty) {
          tempatLahir = parts.first.trim();
        }
        if (tanggalLahir.isEmpty && parts.length > 1) {
          tanggalLahir = parts.sublist(1).join(',').trim();
        }
      }
    }

    final nis = read([
      'nis',
      'nomor induk',
      'no induk',
      'nomor_induk',
      'no_induk',
    ]);

    final namaLengkap = read([
      'nama_lengkap',
      'nama lengkap',
      'nama',
      'santri',
    ]);

    if (nis.isEmpty && namaLengkap.isEmpty) {
      return null;
    }

    final tanggalPendaftaran = read([
      'tanggal_pendaftaran',
      'tanggal pendaftaran',
      'tangal_pendaftaran',
      'tangal pendaftaran',
      'tgl_pendaftaran',
      'tgl pendaftaran',
      'tanggal daftar',
      'tgl daftar',
    ]);

    final tahunMasuk = read([
      'tahun_masuk',
      'tahun masuk',
    ]);
    final fallbackYear = _extractYear(tanggalPendaftaran);
    final angkatan = read(['angkatan']);

    return Santri.empty().copyWith(
      nis: nis,
      namaLengkap: namaLengkap,
      namaPanggilan: read([
        'nama_panggilan',
        'nama panggilan',
        'panggilan',
      ]),
      nik: read(['nik']),
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      alamat: read(['alamat']),
      namaAyah: read([
        'nama_ayah',
        'nama ayah',
        'ayah',
      ]),
      namaIbu: read([
        'nama_ibu',
        'nama ibu',
        'ibu',
      ]),
      noHpWali: read([
        'no_hp_wali',
        'no hp wali',
        'nomor wali',
        'hp wali',
        'wa wali',
      ]),
      tahunMasuk: tahunMasuk.isNotEmpty ? tahunMasuk : fallbackYear,
      angkatan: angkatan.isNotEmpty ? angkatan : fallbackYear,
      kelasMadin: read([
        'kelas_madin',
        'kelas madin',
        'kelas',
      ]),
      kamar: read(['kamar', 'asrama']),
      statusSantri: _normalizeStatus(
        read([
          'status_santri',
          'status santri',
          'status',
        ]),
      ),
      nomorKts: read([
        'nomor_kts',
        'nomor kts',
        'kts',
      ]),
      catatan: read([
        'catatan',
        'keterangan',
        'note',
      ]),
      fotoPath: read([
        'foto_path',
        'foto path',
        'foto',
        'photo_path',
        'photo path',
        'photo',
      ]),
    );
  }

  String _extractYear(String value) {
    final match = RegExp(r'(19|20)\d{2}').firstMatch(value);
    return match == null ? '' : match.group(0) ?? '';
  }

  String _normalizeHeader(String value) {
    return value
        .replaceAll('\ufeff', '')
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  String _normalizeStatus(String value) {
    final raw = value.trim().toLowerCase();
    if (raw.isEmpty) {
      return 'Aktif';
    }
    if (raw == 'aktif' || raw == 'active') {
      return 'Aktif';
    }
    if (raw == 'alumni' || raw == 'nonaktif' || raw == 'non-aktif') {
      return 'Alumni';
    }
    return value.trim();
  }

  List<String> _distinctSorted(Iterable<String> values) {
    final items = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();

    items.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return items;
  }
}
