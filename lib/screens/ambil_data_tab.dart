import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/santri_controller.dart';
import '../models/export_models.dart';

class AmbilDataTab extends StatefulWidget {
  const AmbilDataTab({super.key});

  @override
  State<AmbilDataTab> createState() => _AmbilDataTabState();
}

class _AmbilDataTabState extends State<AmbilDataTab> {
  ExportPreset _preset = ExportPreset.kustom;
  late List<ExportColumn> _selectedColumns;
  final _keywordController = TextEditingController();

  String _status = 'Semua';
  String _angkatan = 'Semua';
  String _kelas = 'Semua';
  String _kamar = 'Semua';

  @override
  void initState() {
    super.initState();
    _selectedColumns = List<ExportColumn>.from(_preset.defaultColumns);
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SantriController>();
    final request = _buildRequest();
    final preview = controller.previewForExport(request);
    final theme = Theme.of(context);

    final angkatanItems = ['Semua', ...controller.availableAngkatan];
    final kelasItems = ['Semua', ...controller.availableKelas];
    final kamarItems = ['Semua', ...controller.availableKamar];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preset ambil data',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ExportPreset>(
                  value: _preset,
                  decoration: const InputDecoration(
                    labelText: 'Jenis kebutuhan',
                  ),
                  items: ExportPreset.values.map((preset) {
                    return DropdownMenuItem(
                      value: preset,
                      child: Text(preset.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _preset = value;
                      _selectedColumns = List<ExportColumn>.from(
                        value.defaultColumns,
                      );
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(_preset.description),
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
                  'Filter data',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _keywordController,
                  decoration: const InputDecoration(
                    labelText: 'Pencarian',
                    hintText: 'Nama, NIS, ayah, alamat...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: ['Semua', 'Aktif', 'Alumni'].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _status = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _angkatan,
                  decoration: const InputDecoration(
                    labelText: 'Angkatan',
                  ),
                  items: angkatanItems.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _angkatan = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _kelas,
                  decoration: const InputDecoration(
                    labelText: 'Kelas Madin',
                  ),
                  items: kelasItems.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _kelas = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _kamar,
                  decoration: const InputDecoration(
                    labelText: 'Kamar',
                  ),
                  items: kamarItems.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _kamar = value;
                    });
                  },
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
                  'Pilih kolom',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ExportColumn.values.map((column) {
                    final selected = _selectedColumns.contains(column);
                    return FilterChip(
                      label: Text(column.label),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            if (!_selectedColumns.contains(column)) {
                              _selectedColumns = [
                                ..._selectedColumns,
                                column,
                              ];
                            }
                          } else {
                            _selectedColumns = _selectedColumns
                                .where((item) => item != column)
                                .toList();
                          }
                        });
                      },
                    );
                  }).toList(),
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
                  'Preview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${preview.length} data siap diekspor'),
                if (request.activeFilters.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Filter aktif: ${request.activeFilters.join(' | ')}'),
                ],
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Contoh data:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...preview.take(5).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• ${item.namaLengkap} (${item.nis.isEmpty ? '-' : item.nis})',
                      ),
                    );
                  }),
                ],
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
                  'Export',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _exportButton(context, ExportFormat.csv, Icons.table_rows_outlined),
                    _exportButton(context, ExportFormat.xlsx, Icons.grid_on_outlined),
                    _exportButton(context, ExportFormat.docx, Icons.description_outlined),
                    _exportButton(context, ExportFormat.pdf, Icons.picture_as_pdf_outlined),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'File export disimpan ke folder aplikasi pada direktori dokumen / storage internal.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _exportButton(
    BuildContext context,
    ExportFormat format,
    IconData icon,
  ) {
    final controller = context.watch<SantriController>();
    return FilledButton.icon(
      onPressed: controller.isExporting ? null : () => _handleExport(context, format),
      icon: Icon(icon),
      label: Text(format.label),
    );
  }

  ExportRequest _buildRequest() {
    return ExportRequest(
      preset: _preset,
      selectedColumns: _selectedColumns,
      keyword: _keywordController.text,
      statusFilter: _status,
      angkatan: _angkatan,
      kelas: _kelas,
      kamar: _kamar,
    );
  }

  Future<void> _handleExport(
    BuildContext context,
    ExportFormat format,
  ) async {
    final controller = context.read<SantriController>();
    final request = _buildRequest();
    final preview = controller.previewForExport(request);

    if (request.selectedColumns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu kolom untuk export.'),
        ),
      );
      return;
    }

    if (preview.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data yang sesuai filter.'),
        ),
      );
      return;
    }

    try {
      final result = await controller.export(request, format);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Export ${format.label} berhasil. ${result.rowCount} data tersimpan di ${result.path}',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export gagal: $error'),
        ),
      );
    }
  }
}
