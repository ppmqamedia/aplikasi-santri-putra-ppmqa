import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/santri_controller.dart';
import 'ambil_data_tab.dart';
import 'dashboard_tab.dart';
import 'data_santri_tab.dart';
import 'santri_form_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  String get _title {
    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Data Santri';
      case 2:
        return 'Ambil Data';
      default:
        return 'Administrasi Santri Putra';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SantriController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        bottom: controller.isLoading || controller.isImporting || controller.isExporting
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
        actions: _buildActions(context, controller),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardTab(
            onOpenDataSantri: () => setState(() => _currentIndex = 1),
            onOpenAmbilData: () => setState(() => _currentIndex = 2),
          ),
          const DataSantriTab(),
          const AmbilDataTab(),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => const SantriFormScreen(),
                  ),
                );

                if (!mounted || saved != true) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data santri berhasil disimpan.'),
                  ),
                );
              },
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Tambah Santri'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Data Santri',
          ),
          NavigationDestination(
            icon: Icon(Icons.file_download_outlined),
            selectedIcon: Icon(Icons.file_download),
            label: 'Ambil Data',
          ),
        ],
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    SantriController controller,
  ) {
    if (_currentIndex == 1) {
      return [
        IconButton(
          tooltip: 'Impor CSV',
          onPressed: controller.isImporting
              ? null
              : () async {
                  try {
                    final result = await controller.pickAndImportCsv();
                    if (!mounted || result == null) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.message),
                      ),
                    );
                  } catch (error) {
                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Impor gagal: $error'),
                      ),
                    );
                  }
                },
          icon: const Icon(Icons.upload_file_outlined),
        ),
        IconButton(
          tooltip: 'Muat ulang',
          onPressed: controller.load,
          icon: const Icon(Icons.refresh),
        ),
      ];
    }

    return [
      IconButton(
        tooltip: 'Muat ulang',
        onPressed: controller.load,
        icon: const Icon(Icons.refresh),
      ),
    ];
  }
}
