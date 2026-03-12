import 'package:flutter/material.dart';

import 'app.dart';
import 'data/santri_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = SantriRepository();
  await repository.init();
  runApp(MyApp(repository: repository));
}
