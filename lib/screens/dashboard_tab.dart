import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/santri_controller.dart';
import '../widgets/stat_card.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    super.key,
    required this.onOpenDataSantri,
    required this.onOpenAmbilData,
  });

  final VoidCallback onOpenDataSantri;
  final VoidCallback onOpenAmbilData;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SantriController>();
    final summary = controller.summary;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ringkasan administrasi santri putra',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Halaman awal untuk melihat jumlah santri dan akses cepat ke menu utama.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          StatCard(
            icon: Icons.groups_2_outlined,
            label: 'Total Santri',
            value: '${summary.total}',
          ),
          StatCard(
            icon: Icons.check_circle_outline,
            label: 'Santri Aktif',
            value: '${summary.aktif}',
          ),
          StatCard(
            icon: Icons.school_outlined,
            label: 'Alumni',
            value: '${summary.alumni}',
          ),
          StatCard(
            icon: Icons.rule_folder_outlined,
            label: 'Data Belum Lengkap',
            value: '${summary.belumLengkap}',
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu cepat',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: onOpenDataSantri,
                        icon: const Icon(Icons.people),
                        label: const Text('Data Santri'),
                      ),
                      FilledButton.icon(
                        onPressed: onOpenAmbilData,
                        icon: const Icon(Icons.file_download),
                        label: const Text('Ambil Data'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Data belum lengkap dihitung dari data inti seperti NIS, nama, TTL, alamat, nama ayah, no. HP wali, tahun masuk, angkatan, kelas, dan kamar.',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Untuk memindahkan data lama dari spreadsheet, gunakan tombol Impor CSV pada menu Data Santri.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
