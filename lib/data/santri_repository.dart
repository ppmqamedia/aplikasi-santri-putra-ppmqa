import 'package:sqflite/sqflite.dart';

import '../models/export_models.dart';
import '../models/santri.dart';

class SantriRepository {
  Database? _database;

  Future<void> init() async {
    if (_database != null) {
      return;
    }

    final dbDirectory = await getDatabasesPath();
    final dbPath = '$dbDirectory/admin_santri_putra.db';

    _database = await openDatabase(
      dbPath,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Database get database {
    final db = _database;
    if (db == null) {
      throw StateError('Database belum diinisialisasi.');
    }
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE santri (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nis TEXT NOT NULL UNIQUE,
        nama_lengkap TEXT NOT NULL,
        nama_panggilan TEXT NOT NULL DEFAULT '',
        nik TEXT NOT NULL DEFAULT '',
        tempat_lahir TEXT NOT NULL DEFAULT '',
        tanggal_lahir TEXT NOT NULL DEFAULT '',
        alamat TEXT NOT NULL DEFAULT '',
        nama_ayah TEXT NOT NULL DEFAULT '',
        nama_ibu TEXT NOT NULL DEFAULT '',
        no_hp_wali TEXT NOT NULL DEFAULT '',
        tahun_masuk TEXT NOT NULL DEFAULT '',
        angkatan TEXT NOT NULL DEFAULT '',
        kelas_madin TEXT NOT NULL DEFAULT '',
        kamar TEXT NOT NULL DEFAULT '',
        status_santri TEXT NOT NULL DEFAULT 'Aktif',
        nomor_kts TEXT NOT NULL DEFAULT '',
        catatan TEXT NOT NULL DEFAULT '',
        foto_path TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    """);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE santri ADD COLUMN foto_path TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<List<Santri>> fetchAll() async {
    final rows = await database.query(
      'santri',
      orderBy: 'nama_lengkap COLLATE NOCASE ASC',
    );

    return rows.map(Santri.fromMap).toList();
  }

  Future<Santri> save(Santri santri) async {
    final now = DateTime.now().toIso8601String();

    if (santri.id == null) {
      final item = santri.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await database.insert(
        'santri',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return item.copyWith(id: id);
    }

    final item = santri.copyWith(
      updatedAt: now,
      createdAt: santri.createdAt.isEmpty ? now : santri.createdAt,
    );

    await database.update(
      'santri',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [santri.id],
    );

    return item;
  }

  Future<void> delete(int id) async {
    await database.delete(
      'santri',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ImportResult> importMany(List<Santri> rows) async {
    var imported = 0;
    var skipped = 0;

    await database.transaction((txn) async {
      for (final santri in rows) {
        if (santri.nis.trim().isEmpty || santri.namaLengkap.trim().isEmpty) {
          skipped += 1;
          continue;
        }

        final existing = await txn.query(
          'santri',
          columns: ['id', 'created_at'],
          where: 'nis = ?',
          whereArgs: [santri.nis.trim()],
          limit: 1,
        );

        final now = DateTime.now().toIso8601String();

        if (existing.isEmpty) {
          await txn.insert(
            'santri',
            santri
                .copyWith(
                  createdAt: now,
                  updatedAt: now,
                )
                .toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          imported += 1;
        } else {
          final id = existing.first['id'] as int;
          final createdAt = existing.first['created_at']?.toString() ?? now;

          await txn.update(
            'santri',
            santri
                .copyWith(
                  id: id,
                  createdAt: createdAt,
                  updatedAt: now,
                )
                .toMap(),
            where: 'id = ?',
            whereArgs: [id],
          );

          imported += 1;
        }
      }
    });

    return ImportResult(
      importedCount: imported,
      skippedCount: skipped,
      message: 'Impor selesai. Berhasil: $imported, dilewati: $skipped.',
    );
  }
}
