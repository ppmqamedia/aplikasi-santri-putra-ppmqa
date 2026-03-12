import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/santri_controller.dart';
import 'santri_detail_screen.dart';

class DataSantriTab extends StatelessWidget {
  const DataSantriTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SantriController>();
    final theme = Theme.of(context);
    final items = controller.filteredItems;

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            initialValue: controller.searchQuery,
            decoration: const InputDecoration(
              labelText: 'Cari santri',
              hintText: 'Nama, NIS, kamar, kelas, ayah, alamat...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Semua', 'Aktif', 'Alumni'].map((status) {
              return ChoiceChip(
                label: Text(status),
                selected: controller.statusFilter == status,
                onSelected: (_) => controller.setStatusFilter(status),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Jumlah data: ${items.length}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Belum ada data santri yang tampil.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan data baru lewat tombol "Tambah Santri" atau impor file CSV dari spreadsheet lama.',
                    ),
                  ],
                ),
              ),
            )
          else
            ...items.map((santri) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: _SantriPhotoAvatar(
                    fotoPath: santri.fotoPath,
                    nama: santri.namaLengkap,
                  ),
                  title: Text(
                    santri.namaLengkap.isEmpty ? '(Tanpa Nama)' : santri.namaLengkap,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'NIS: ${santri.nis.isEmpty ? '-' : santri.nis}\n${santri.ringkasan}',
                    ),
                  ),
                  trailing: santri.isDataLengkap
                      ? const Icon(Icons.chevron_right)
                      : const Tooltip(
                          message: 'Data belum lengkap',
                          child: Icon(Icons.warning_amber_rounded),
                        ),
                  onTap: () async {
                    await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => SantriDetailScreen(santri: santri),
                      ),
                    );
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _SantriPhotoAvatar extends StatelessWidget {
  const _SantriPhotoAvatar({
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

    if (hasFile) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: ClipOval(
          child: Image.file(
            file,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.person,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      );
    }

    final trimmedName = nama.trim();
    final initial = trimmedName.isEmpty ? 'S' : trimmedName.substring(0, 1).toUpperCase();

    return CircleAvatar(
      radius: 24,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        initial,
        style: TextStyle(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
