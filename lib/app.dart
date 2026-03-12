import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/santri_controller.dart';
import 'core/app_theme.dart';
import 'data/export_service.dart';
import 'data/santri_repository.dart';
import 'screens/shell_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.repository,
  });

  final SantriRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SantriController>(
          create: (_) => SantriController(
            repository: repository,
            exportService: ExportService(),
          )..load(),
        ),
      ],
      child: MaterialApp(
        title: 'Administrasi Santri Putra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const ShellScreen(),
      ),
    );
  }
}
