import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../controllers/santri_controller.dart';
import '../models/santri.dart';

class SantriFormScreen extends StatefulWidget {
  const SantriFormScreen({
    super.key,
    this.initial,
  });

  final Santri? initial;

  @override
  State<SantriFormScreen> createState() => _SantriFormScreenState();
}

class _SantriFormScreenState extends State<SantriFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nisController;
  late final TextEditingController _namaLengkapController;
  late final TextEditingController _namaPanggilanController;
  late final TextEditingController _nikController;
  late final TextEditingController _tempatLahirController;
  late final TextEditingController _tanggalLahirController;
  late final TextEditingController _alamatController;
  late final TextEditingController _namaAyahController;
  late final TextEditingController _namaIbuController;
  late final TextEditingController _noHpWaliController;
  late final TextEditingController _tahunMasukController;
  late final TextEditingController _angkatanController;
  late final TextEditingController _kelasMadinController;
  late final TextEditingController _kamarController;
  late final TextEditingController _nomorKtsController;
  late final TextEditingController _catatanController;

  late String _statusSantri;
  late final String _initialFotoPath;
  late String _fotoPath;
  bool _isSubmitting = false;
  bool _didSubmit = false;

  @override
  void initState() {
    super.initState();
    final santri = widget.initial ?? Santri.empty();

    _nisController = TextEditingController(text: santri.nis);
    _namaLengkapController = TextEditingController(text: santri.namaLengkap);
    _namaPanggilanController = TextEditingController(text: santri.namaPanggilan);
    _nikController = TextEditingController(text: santri.nik);
    _tempatLahirController = TextEditingController(text: santri.tempatLahir);
    _tanggalLahirController = TextEditingController(text: santri.tanggalLahir);
    _alamatController = TextEditingController(text: santri.alamat);
    _namaAyahController = TextEditingController(text: santri.namaAyah);
    _namaIbuController = TextEditingController(text: santri.namaIbu);
    _noHpWaliController = TextEditingController(text: santri.noHpWali);
    _tahunMasukController = TextEditingController(text: santri.tahunMasuk);
    _angkatanController = TextEditingController(text: santri.angkatan);
    _kelasMadinController = TextEditingController(text: santri.kelasMadin);
    _kamarController = TextEditingController(text: santri.kamar);
    _nomorKtsController = TextEditingController(text: santri.nomorKts);
    _catatanController = TextEditingController(text: santri.catatan);
    _statusSantri = santri.statusLabel;
    _initialFotoPath = santri.fotoPath;
    _fotoPath = santri.fotoPath;
  }

  @override
  void dispose() {
    _cleanupUnsavedPhoto();
    _nisController.dispose();
    _namaLengkapController.dispose();
    _namaPanggilanController.dispose();
    _nikController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _noHpWaliController.dispose();
    _tahunMasukController.dispose();
    _angkatanController.dispose();
    _kelasMadinController.dispose();
    _kamarController.dispose();
    _nomorKtsController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Santri' : 'Tambah Santri'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPhotoSection(context),
            const SizedBox(height: 12),
            _buildSectionTitle(context, 'Identitas'),
            _field(
              controller: _nisController,
              label: 'NIS',
              hint: 'Contoh: SP-001',
              required: true,
            ),
            _field(
              controller: _namaLengkapController,
              label: 'Nama Lengkap',
              required: true,
            ),
            _field(
              controller: _namaPanggilanController,
              label: 'Nama Panggilan',
            ),
            _field(
              controller: _nikController,
              label: 'NIK',
            ),
            _field(
              controller: _tempatLahirController,
              label: 'Tempat Lahir',
              required: true,
            ),
            _field(
              controller: _tanggalLahirController,
              label: 'Tanggal Lahir',
              hint: 'Format bebas, contoh 2008-09-17',
              required: true,
            ),
            _field(
              controller: _alamatController,
              label: 'Alamat',
              maxLines: 3,
              required: true,
            ),
            const SizedBox(height: 12),
            _buildSectionTitle(context, 'Orang Tua / Wali'),
            _field(
              controller: _namaAyahController,
              label: 'Nama Ayah',
              required: true,
            ),
            _field(
              controller: _namaIbuController,
              label: 'Nama Ibu',
            ),
            _field(
              controller: _noHpWaliController,
              label: 'No. HP Wali',
              required: true,
            ),
            const SizedBox(height: 12),
            _buildSectionTitle(context, 'Data Pondok'),
            _field(
              controller: _tahunMasukController,
              label: 'Tahun Masuk',
              required: true,
            ),
            _field(
              controller: _angkatanController,
              label: 'Angkatan',
              required: true,
            ),
            _field(
              controller: _kelasMadinController,
              label: 'Kelas Madin',
              required: true,
            ),
            _field(
              controller: _kamarController,
              label: 'Kamar',
              required: true,
            ),
            DropdownButtonFormField<String>(
              value: _statusSantri,
              decoration: const InputDecoration(
                labelText: 'Status Santri',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Aktif',
                  child: Text('Aktif'),
                ),
                DropdownMenuItem(
                  value: 'Alumni',
                  child: Text('Alumni'),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _statusSantri = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildSectionTitle(context, 'Administrasi'),
            _field(
              controller: _nomorKtsController,
              label: 'Nomor KTS',
            ),
            _field(
              controller: _catatanController,
              label: 'Catatan',
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: const Icon(Icons.save_outlined),
              label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    final theme = Theme.of(context);
    final hasPhoto = _fotoPath.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foto Santri',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: _buildPhotoPreview(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasPhoto ? 'Foto sudah dipilih.' : 'Belum ada foto.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unggah foto JPG, JPEG, PNG, atau WEBP. Foto akan disimpan di penyimpanan aplikasi.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _isSubmitting ? null : _pickPhoto,
                            icon: const Icon(Icons.photo_camera_back_outlined),
                            label: Text(hasPhoto ? 'Ganti Foto' : 'Upload Foto'),
                          ),
                          if (hasPhoto)
                            TextButton.icon(
                              onPressed: _isSubmitting ? null : _clearPhoto,
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Hapus Foto'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(BuildContext context) {
    final theme = Theme.of(context);
    final file = _fotoPath.trim().isEmpty ? null : File(_fotoPath);
    final hasFile = file != null && file.existsSync();

    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasFile
          ? Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _photoPlaceholder(context),
            )
          : _photoPlaceholder(context),
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 44,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Preview foto',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label wajib diisi';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    try {
      final newPath = await _copyPickedPhoto(result.files.single);
      final previousTempPath = _fotoPath;

      if (!mounted) {
        return;
      }

      setState(() {
        _fotoPath = newPath;
      });

      if (previousTempPath.isNotEmpty &&
          previousTempPath != _initialFotoPath &&
          previousTempPath != newPath) {
        await _deleteFileIfExists(previousTempPath);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $error'),
        ),
      );
    }
  }

  Future<void> _clearPhoto() async {
    final previousTempPath = _fotoPath;

    setState(() {
      _fotoPath = '';
    });

    if (previousTempPath.isNotEmpty && previousTempPath != _initialFotoPath) {
      await _deleteFileIfExists(previousTempPath);
    }
  }

  Future<String> _copyPickedPhoto(PlatformFile file) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final photoDirectory = Directory(
      p.join(documentsDirectory.path, 'santri_photos'),
    );

    if (!await photoDirectory.exists()) {
      await photoDirectory.create(recursive: true);
    }

    final fileStem = _slugify(
      _nisController.text.isNotEmpty
          ? _nisController.text
          : _namaLengkapController.text,
    );
    final fileExt = _normalizePhotoExtension(file);
    final targetPath = p.join(
      photoDirectory.path,
      '${fileStem.isEmpty ? 'santri' : fileStem}_${DateTime.now().millisecondsSinceEpoch}$fileExt',
    );

    if (file.path != null && file.path!.isNotEmpty) {
      await File(file.path!).copy(targetPath);
      return targetPath;
    }

    final bytes = file.bytes;
    if (bytes == null) {
      throw Exception('Foto tidak dapat dibaca dari perangkat.');
    }

    await File(targetPath).writeAsBytes(bytes, flush: true);
    return targetPath;
  }

  String _normalizePhotoExtension(PlatformFile file) {
    final ext = (file.extension ?? p.extension(file.name)).replaceFirst('.', '').toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return '.$ext';
      default:
        return '.jpg';
    }
  }

  String _slugify(String value) {
    final normalized = value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return normalized;
  }

  void _cleanupUnsavedPhoto() {
    if (_didSubmit) {
      return;
    }
    if (_fotoPath.isEmpty || _fotoPath == _initialFotoPath) {
      return;
    }

    try {
      final file = File(_fotoPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {
      // abaikan kegagalan pembersihan file sementara
    }
  }

  Future<void> _deleteFileIfExists(String path) async {
    if (path.trim().isEmpty) {
      return;
    }

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // abaikan kegagalan menghapus file lama
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final controller = context.read<SantriController>();
      final base = widget.initial ?? Santri.empty();
      final oldPhotoPath = base.fotoPath;

      final santri = base.copyWith(
        nis: _nisController.text,
        namaLengkap: _namaLengkapController.text,
        namaPanggilan: _namaPanggilanController.text,
        nik: _nikController.text,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        alamat: _alamatController.text,
        namaAyah: _namaAyahController.text,
        namaIbu: _namaIbuController.text,
        noHpWali: _noHpWaliController.text,
        tahunMasuk: _tahunMasukController.text,
        angkatan: _angkatanController.text,
        kelasMadin: _kelasMadinController.text,
        kamar: _kamarController.text,
        statusSantri: _statusSantri,
        nomorKts: _nomorKtsController.text,
        catatan: _catatanController.text,
        fotoPath: _fotoPath,
      );

      await controller.saveSantri(santri);

      if (oldPhotoPath.isNotEmpty && oldPhotoPath != santri.fotoPath) {
        await _deleteFileIfExists(oldPhotoPath);
      }

      _didSubmit = true;

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
