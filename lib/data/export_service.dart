import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart' as csvcodec;
import 'package:docx_creator/docx_creator.dart';
import 'package:excel/excel.dart' as xls;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/export_models.dart';
import '../models/santri.dart';

class ExportService {
  Future<ExportResult> export({
    required List<Santri> santriList,
    required ExportRequest request,
    required ExportFormat format,
  }) async {
    final rows = <List<String>>[
      request.selectedColumns.map((column) => column.label).toList(),
      ...santriList.map(
        (santri) => request.selectedColumns
            .map((column) => column.valueOf(santri))
            .toList(),
      ),
    ];

    final exportDirectory = await _resolveExportDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${request.preset.fileSlug}_$timestamp.${format.fileExtension}';
    final file = File('${exportDirectory.path}/$fileName');

    switch (format) {
      case ExportFormat.csv:
        await _writeCsv(file, rows);
        break;
      case ExportFormat.xlsx:
        await _writeXlsx(file, rows);
        break;
      case ExportFormat.docx:
        await _writeDocx(file, rows, request, santriList.length);
        break;
      case ExportFormat.pdf:
        await _writePdf(file, rows, request, santriList.length);
        break;
    }

    return ExportResult(
      path: file.path,
      rowCount: santriList.length,
    );
  }

  Future<void> _writeCsv(File file, List<List<String>> rows) async {
    final content = csvcodec.ListToCsvConverter().convert(rows);
    final bom = const [0xEF, 0xBB, 0xBF];
    final bytes = Uint8List.fromList([...bom, ...utf8.encode(content)]);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _writeXlsx(File file, List<List<String>> rows) async {
    final workbook = xls.Excel.createExcel();
    final defaultSheet = workbook.getDefaultSheet() ?? 'Sheet1';

    if (defaultSheet != 'Data') {
      workbook.rename(defaultSheet, 'Data');
    }

    final sheet = workbook['Data'];

    for (final row in rows) {
      sheet.appendRow(
        row.map((value) => xls.TextCellValue(value)).toList(),
      );
    }

    final fileBytes = workbook.save();
    if (fileBytes == null) {
      throw Exception('Gagal membuat file Excel.');
    }

    await file.writeAsBytes(fileBytes, flush: true);
  }

  Future<void> _writeDocx(
    File file,
    List<List<String>> rows,
    ExportRequest request,
    int rowCount,
  ) async {
    final doc = _buildDocument(rows, request, rowCount);
    final bytes = await Future.value(DocxExporter().exportToBytes(doc));
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _writePdf(
    File file,
    List<List<String>> rows,
    ExportRequest request,
    int rowCount,
  ) async {
    final doc = _buildDocument(rows, request, rowCount);
    final bytes = await Future.value(PdfExporter().exportToBytes(doc));
    await file.writeAsBytes(bytes, flush: true);
  }

  DocxBuiltDocument _buildDocument(
    List<List<String>> rows,
    ExportRequest request,
    int rowCount,
  ) {
    final filters = request.activeFilters;
    final filterText = filters.isEmpty ? 'Semua data' : filters.join(' | ');

    return docx()
        .h1(request.title)
        .p('Administrasi Santri Putra')
        .p('Jumlah baris: $rowCount')
        .p('Filter: $filterText')
        .table(rows)
        .build();
  }

  Future<Directory> _resolveExportDirectory() async {
    Directory? baseDirectory;

    try {
      baseDirectory = await getExternalStorageDirectory();
    } catch (_) {
      baseDirectory = null;
    }

    baseDirectory ??= await getApplicationDocumentsDirectory();

    final exportDirectory = Directory('${baseDirectory.path}/exports');

    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }

    return exportDirectory;
  }
}
