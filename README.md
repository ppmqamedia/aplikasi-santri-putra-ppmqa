# Aplikasi Administrasi Santri Putra

Aplikasi Flutter sederhana untuk kebutuhan administrasi santri putra dengan menu:

- Dashboard
- Data Santri (tambah, edit, hapus)
- Detail Santri
- Ambil Data (preset KTS, Khotiminin, Wisuda Madin)
- Pilih kolom
- Export CSV, XLSX, DOCX, PDF
- Import data awal dari file CSV
- Upload, ganti, dan hapus foto santri

## Catatan penting

Saya tidak bisa membaca langsung link Google Sheet dari lingkungan ini, jadi saya menyiapkan:

1. source code aplikasi,
2. template database yang sudah disesuaikan dengan briefing,
3. fitur **Impor CSV** supaya data dari Google Sheet bisa dipindahkan ke aplikasi.

### Cara memindahkan data Google Sheet ke aplikasi

1. Buka file Google Sheet Anda.
2. Pilih **File -> Download -> Comma Separated Values (.csv)**.
3. Jalankan aplikasi.
4. Buka menu **Data Santri**.
5. Tekan tombol **Impor CSV** di app bar.
6. Pilih file CSV hasil unduhan.
7. Data akan masuk ke database lokal aplikasi.

## Struktur kolom yang dipakai

Kolom inti yang dipakai aplikasi:

- nis
- nama_lengkap
- nama_panggilan
- nik
- tempat_lahir
- tanggal_lahir
- alamat
- nama_ayah
- nama_ibu
- no_hp_wali
- tahun_masuk
- angkatan
- kelas_madin
- kamar
- status_santri
- nomor_kts
- catatan
- foto_path
- created_at
- updated_at

## Menjalankan project

Project ini disiapkan sebagai **source package Flutter**. Jika Anda membuka folder ini di Android Studio / VS Code yang sudah memiliki Flutter SDK, jalankan:

```bash
flutter pub get
flutter run
```

Jika folder Android belum tergenerate di mesin Anda, jalankan:

```bash
flutter create . --platforms=android
flutter pub get
flutter run
```

## Saran pengembangan berikutnya

- sinkronisasi langsung dengan Google Sheets / backend cloud
- login multi-user
- backup online
- cetak format surat atau biodata otomatis
- role admin dan operator

## Ringkasan UI

- **Dashboard**: total santri, aktif, alumni, data belum lengkap
- **Data Santri**: pencarian, filter status, daftar data, tambah, edit, hapus, import CSV, dan foto avatar
- **Detail Santri**: data lengkap per santri beserta preview foto
- **Ambil Data**: preset KTS/Khotiminin/Wisuda Madin, filter, pilih kolom, lalu export


## Foto santri

- Foto dipilih dari perangkat lalu disalin ke penyimpanan aplikasi.
- Bisa upload, ganti, dan hapus foto dari form tambah/edit santri.
- Foto tampil di daftar santri dan halaman detail.


## Build APK debug yang bisa di-install

### Opsi 1 — GitHub Actions

File workflow sudah disediakan di `.github/workflows/build-debug-apk.yml`.

Langkah cepat:

1. Upload project ini ke repository GitHub.
2. Buka tab **Actions**.
3. Jalankan workflow **Build Debug APK**.
4. Setelah selesai, unduh artifact **app-debug-apk**.
5. File hasilnya adalah `app-debug.apk` dan bisa langsung di-install ke Android.

### Opsi 2 — Build lokal

Jika Flutter sudah terpasang di laptop / PC:

Linux/macOS:

```bash
./tool/build_apk.sh
```

Windows PowerShell:

```powershell
./tool/build_apk.ps1
```

Atau manual:

```bash
flutter create . --platforms=android
flutter pub get
flutter build apk --debug
```

Output APK:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Catatan build

- APK yang dibuild lewat jalur ini adalah **debug APK**, jadi bisa di-install langsung untuk pemakaian internal / uji coba.
- Untuk distribusi jangka panjang dan update versi yang konsisten, sebaiknya siapkan **release signing key**.


## File database yang ikut dibundel

Folder `database/` berisi:

- `Database Santri Putra - Disesuaikan untuk Aplikasi.xlsx`
- `Data Santri App - Siap Impor.csv`

File CSV tersebut bisa langsung dipakai untuk impor ke aplikasi setelah APK berhasil dibangun.
