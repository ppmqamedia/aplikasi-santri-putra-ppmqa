import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/santri_controller.dart';
import '../models/santri.dart';
import 'santri_form_screen.dart';

class SantriDetailScreen extends StatelessWidget {
  const SantriDetailScreen({
    super.key,
    required this.santri,
  });

  final Santri santri;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Santri'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () async {
              final updated = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => SantriFormScreen(initial: santri),
                ),
              );

              if (!context.mounted || updated != true) {
                return;
              }

              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PhotoPreview(
                    fotoPath: santri.fotoPath,
                    nama: santri.namaLengkap,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          santri.namaLengkap.isEmpty ? '(Tanpa Nama)' : santri.namaLengkap,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoChip(label: 'NIS ${santri.nis.isEmpty ? '-' : santri.nis}'),
                            _InfoChip(label: santri.statusLabel),
                            if (santri.kelasMadin.isNotEmpty)
                              _InfoChip(label: santri.kelasMadin),
                            if (santri.kamar.isNotEmpty)
                              _InfoChip(label: 'Kamar ${santri.kamar}'),
                            _InfoChip(
                              label: santri.hasFoto ? 'Foto tersedia' : 'Foto belum ada',
                            ),
                            if (!santri.isDataLengkap)
                              const _InfoChip(label: 'Data belum lengkap'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _SectionCard(
            title: 'Identitas',
            rows: [
              _SectionRow('Nama Lengkap', santri.namaLengkap),
              _SectionRow('Nama Panggilan', santri.namaPanggilan),
              _SectionRow('NIK', santri.nik),
              _SectionRow('Tempat Lahir', santri.tempatLahir),
              _SectionRow('Tanggal Lahir', santri.tanggalLahir),
              _SectionRow('TTL', santri.ttl),
              _SectionRow('Alamat', santri.alamat),
            ],
          ),
          _SectionCard(
            title: 'Orang Tua / Wali',
            rows: [
              _SectionRow('Nama Ayah', santri.namaAyah),
              _SectionRow('Nama Ibu', santri.namaIbu),
              _SectionRow('No. HP Wali', santri.noHpWali),
            ],
          ),
          _SectionCard(
            title: 'Data Pondok',
            rows: [
              _SectionRow('Tahun Masuk', santri.tahunMasuk),
              _SectionRow('Angkatan', santri.angkatan),
              _SectionRow('Kelas Madin', santri.kelasMadin),
              _SectionRow('Kamar', santri.kamar),
              _SectionRow('Status', santri.statusLabel),
              _SectionRow('Nomor KTS', santri.nomorKts),
            ],
          ),
          _SectionCard(
            title: 'Foto & Catatan',
            rows: [
              _SectionRow('Status Foto', santri.hasFoto ? 'Sudah diunggah' : 'Belum ada foto'),
              _SectionRow('Catatan', santri.catatan),
              _SectionRow('Dibuat', santri.createdAt),
              _SectionRow('Diubah', santri.updatedAt),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final controller = context.read<SantriController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: Text(
            'Yakin ingin menghapus data ${santri.namaLengkap.isEmpty ? 'santri ini' : santri.namaLengkap}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await controller.deleteSantri(santri);

    if (!context.mounted) {
      return;
    }

    if (santri.fotoPath.trim().isNotEmpty) {
      try {
        final file = File(santri.fotoPath);
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (_) {
        // abaikan kegagalan menghapus file lokal
      }
    }

    Navigator.of(context).pop(true);
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.fotoPath,
    required this.nama,
  });

  final String fotoPath;
  final String nama;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final file = fotoPath.trim().isEmpty ? null : File(fotoPath);
    final hasFile = file != null && file.existsSync();

    return Container(
      width: 108,
      height: 140,
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
              errorBuilder: (_, __, ___) => _fallback(theme),
            )
          : _fallback(theme),
    );
  }

  Widget _fallback(ThemeData theme) {
    final label = nama.trim().isEmpty ? 'Santri' : nama.trim();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person,
          size: 42,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_SectionRow> rows;

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows.where((row) => row.value.trim().isNotEmpty).toList();

    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            if (visibleRows.isEmpty)
              const Text('-')
            else
              ...visibleRows.map((row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          row.label,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(row.value),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _SectionRow {
  const _SectionRow(this.label, this.value);

  final String label;
  final String value;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
