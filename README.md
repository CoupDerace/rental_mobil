# INFORMASI PROYEK
Judul Proyek      : Implementasi Sistem Rental Mobil 
                     Berbasis Mobile untuk Manajemen Penyewaan Kendaraan
                     Pada Multi RentCar

Mata Kuliah       : Project III

Dosen Pembimbing Utama     : Dr. Moh. Ramaddan Julianti, M.T

Konsentrasi       : Software Engineering

Prodi             : Teknik Informatika

Fakultas          : Teknologi Informasi dan Komunikasi

Semester          : Genap

Tahun Akademik    : 2025 - 2026

Institut Teknologi dan Bisnis Bina Sarana Global, Tangerang


# ANGGOTA MEMBER
1. Afnan Dani Alaudin (1123150074)
2. Muhammad Turtusi Afrizal Perdana (1123150012)

---

# Rental Mobil - Aplikasi Manajemen Penyewaan Mobil

Aplikasi Rental Mobil adalah sistem manajemen penyewaan mobil berbasis mobile (Android & iOS) yang dirancang untuk mempermudah operasional bisnis rental mobil. Aplikasi ini dibangun menggunakan framework **Flutter** untuk sisi frontend dan **Supabase** sebagai backend (Database PostgreSQL, Authentication, dan Cloud Storage).

Sistem ini dilengkapi dengan **Role-Based Access Control (RBAC)** untuk membatasi hak akses fitur berdasarkan tanggung jawab pengguna, yaitu:
*   **Admin**: Mengelola semua data master (mobil, pelanggan, karyawan, user), transaksi rental, pembayaran, pengembalian, servis mobil, dan laporan.
*   **Owner**: Memantau dashboard finansial, grafik pendapatan, statistik bisnis, serta mengunduh atau mencetak laporan transaksi dan operasional.
*   **Operator**: Fokus pada pemantauan armada, pencatatan servis mobil berkala, serta menerima notifikasi pengingat.

#### Link Apk = [APK MULTI RENTCAR](https://drive.google.com/drive/folders/1eMW_p3jfazVcspgbwsvU2OjKM2fVqIQH?usp=sharing)
---

## 1. Fitur Utama

Aplikasi Rental Mobil ini memiliki berbagai fitur operasional yang lengkap:

*   **Autentikasi & RBAC**: Autentikasi aman melalui Supabase Auth dengan pembagian halaman dashboard dan menu yang disesuaikan secara dinamis berdasarkan role (Admin, Owner, Operator).
*   **Manajemen Mobil**: CRUD (Create, Read, Update, Delete) armada mobil dengan pelacakan status secara real-time (`tersedia`, `disewa`, `servis`).
*   **Manajemen Pelanggan**: CRUD data pelanggan, lengkap dengan integrasi kamera/galeri untuk mengunggah foto kartu identitas (KTP/SIM) ke Supabase Storage.
*   **Manajemen Karyawan**: Mengelola data karyawan internal, riwayat tanggal masuk, jabatan, serta status aktif/non-aktif.
*   **Transaksi Rental**: Pemrosesan sewa mobil yang terintegrasi dengan data pelanggan dan mobil. Sistem secara otomatis menghitung estimasi biaya berdasarkan durasi sewa.
*   **Proses Pengembalian**: Pencatatan pengembalian mobil untuk mencatat kondisi fisik mobil saat kembali serta menghitung biaya denda keterlambatan secara otomatis.
*   **Transaksi Pembayaran**: Manajemen pembayaran rental dengan dukungan metode `Cash` dan `Transfer`, serta pelacakan status (`pending`, `lunas`).
*   **Kelola Servis Mobil**: Pencatatan riwayat perawatan/servis berkala armada mobil untuk menjaga kondisi kendaraan tetap optimal.
*   **Dashboard Statistik**: Grafik pendapatan harian/bulanan, visualisasi status mobil, daftar mobil terpopuler, serta data ringkasan operasional.
*   **Laporan Ekspor**: Generate laporan resmi dalam format **PDF** (siap cetak) dan **Excel (.xlsx)** untuk data pendapatan, rental, pengembalian, dan servis mobil.
*   **Sistem Notifikasi**: Pengingat otomatis berbasis local notification (`flutter_local_notifications`) didukung background service (`workmanager`) untuk memantau status jatuh tempo sewa dan jadwal servis secara berkala.

---

## 2. Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan tumpukan teknologi modern berikut:

*   **Framework Utama**: Flutter (Dart SDK v3.7.0 ke atas)
*   **Database & Backend**: Supabase (PostgreSQL Cloud Database, Supabase Auth, dan Supabase Storage)
*   **State Management**: Provider & Flutter Riverpod
*   **Routing**: Custom generate routing (MaterialPageRoute) & GoRouter
*   **Library & Package Utama**:
    *   `supabase_flutter` - SDK resmi untuk menghubungkan Flutter ke Supabase.
    *   `shared_preferences` - Untuk penyimpanan konfigurasi lokal (seperti tema aplikasi).
    *   `flutter_local_notifications` & `workmanager` - Menangani notifikasi lokal dan tugas terjadwal di latar belakang.
    *   `pdf` & `printing` - Membuat dokumen PDF secara dinamis dan mengirimkannya ke printer sistem.
    *   `excel` - Membuat dan membaca file spreadsheet Excel secara terprogram.
    *   `image_picker` - Mengambil foto menggunakan kamera atau memilih dari galeri untuk identitas pelanggan.
    *   `cached_network_image` - Memuat gambar dari Supabase Storage dengan optimasi cache.
    *   `iconsax_flutter` & `lottie` - Desain antarmuka premium dengan ikon modern dan animasi interaktif.
    *   `get_it` - Dependency Injection untuk manajemen lifecycle service.
    *   `intl` - Format lokalisasi tanggal dan mata uang Rupiah (IDR).

---

## 3. Struktur Project

Project ini menerapkan konsep **Clean Architecture** dengan pendekatan **Feature-First** (fitur sebagai folder utama) agar pengembangan kode tetap rapi dan terisolasi:

```text
rental_mobil/
├── android/                  # Konfigurasi platform Android
├── ios/                      # Konfigurasi platform iOS
├── assets/                   # Aset statis aplikasi
│   ├── fonts/                # Custom Font (Poppins)
│   ├── icons/                # Ikon grafis
│   ├── images/               # Gambar statis
│   ├── logos/                # Logo aplikasi (logo_rent.jpg)
│   └── lottie/               # Animasi Lottie (JSON)
├── lib/                      # Source code utama aplikasi
│   ├── app/                  # Konfigurasi global aplikasi
│   │   ├── config/           # Konfigurasi Supabase (supabase_config.dart)
│   │   ├── routes/           # Routing app (routes.dart, router.dart, injector.dart)
│   │   └── theme/            # Tema terang & gelap (app_theme.dart)
│   ├── core/                 # Komponen inti yang dipakai bersama
│   │   ├── components/       # Custom reusable UI widgets (buttons, cards, dialogs)
│   │   ├── constants/        # Konstanta warna, gaya teks, ukuran
│   │   ├── network/          # Koneksi jaringan (supabase_service.dart)
│   │   ├── services/         # Layanan lokal (notifications, storage, background task)
│   │   └── utils/            # Helper format mata uang, tanggal, parser data
│   ├── features/             # Fitur modular aplikasi (RBAC)
│   │   ├── auth/             # Login, logout, status sesi pengguna
│   │   ├── cars/             # Manajemen armada mobil
│   │   ├── dashboard/        # Halaman dashboard (Admin, Owner, Operator)
│   │   ├── karyawan/         # CRUD data karyawan
│   │   ├── notifications/    # Log notifikasi sistem
│   │   ├── payment/          # Manajemen pembayaran sewa
│   │   ├── pelanggan/        # Manajemen data pelanggan & upload foto KTP
│   │   ├── pengembalian/     # Proses input pengembalian & hitung denda
│   │   ├── profile/          # Profil pengguna saat ini
│   │   ├── rental/           # Pembuatan transaksi rental baru
│   │   ├── reports/          # Laporan harian/bulanan/tahunan (PDF & Excel)
│   │   ├── services/         # Pencatatan service/perawatan mobil
│   │   ├── settings/         # Pengaturan tema dan profil
│   │   └── splash/           # Splash screen awal saat aplikasi dibuka
│   ├── shared/               # Global state providers (auth_provider, theme_provider)
│   └── main.dart             # Entry point utama aplikasi Flutter
└── pubspec.yaml              # Daftar dependency dan konfigurasi aset
```

---

## 4. Prasyarat Instalasi

Sebelum dapat menjalankan project ini di komputer lokal Anda, pastikan telah menginstal software berikut:

*   **Flutter SDK**: Versi direkomendasikan `3.22.x` atau `3.24.x` (SDK `>=3.7.0 <4.0.0`)
*   **Dart SDK**: Terbawa otomatis di dalam Flutter SDK
*   **Java Development Kit (JDK)**: JDK 17 (direkomendasikan untuk kompatibilitas Gradle Android)
*   **Android Studio** atau **VS Code** dengan ekstensi berikut terpasang:
    *   Flutter Extension
    *   Dart Extension
*   **Git**: Untuk clone repository
*   **Akun Supabase**: Akun gratis di [supabase.com](https://supabase.com) untuk hosting database.

---

## 5. Konfigurasi Database (Supabase)

Aplikasi ini menggunakan **Supabase PostgreSQL** sebagai DBMS utama. Ikuti langkah di bawah ini untuk melakukan setup database:

### A. Membuat Project Supabase
1. Masuk ke dashboard Supabase Anda lalu klik **New Project**.
2. Masukkan nama project (misal: `Rental Mobil`), tentukan password database, dan pilih region terdekat (misal: `Singapore`).
3. Tunggu hingga proses setup database selesai.

### B. Membuat Struktur Tabel & View (SQL Editor)
Salin seluruh query SQL di bawah ini, masuk ke menu **SQL Editor** di dashboard Supabase Anda, buat tab baru, tempelkan query ini, lalu klik **Run**:

```sql
-- =========================================================================
-- 1. TABEL UTAMA (MASTER DATA & TRANSAKSI)
-- =========================================================================

-- Tabel Users (Profil Pengguna & Hak Akses)
CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID UNIQUE, -- Terhubung dengan ID di auth.users Supabase
    nama TEXT NOT NULL,
    email TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin', 'owner', 'operator')),
    no_hp TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Mobil
CREATE TABLE public.mobil (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_mobil TEXT NOT NULL,
    tipe TEXT NOT NULL,
    tahun INTEGER NOT NULL DEFAULT 2023,
    plat_nomor TEXT NOT NULL UNIQUE,
    harga_sewa_perhari NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    status_mobil TEXT NOT NULL DEFAULT 'tersedia' CHECK (status_mobil IN ('tersedia', 'disewa', 'servis')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Pelanggan
CREATE TABLE public.pelanggan (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama TEXT NOT NULL,
    no_hp TEXT NOT NULL,
    alamat TEXT,
    jenis_identitas TEXT NOT NULL DEFAULT 'KTP' CHECK (jenis_identitas IN ('KTP', 'SIM', 'Paspor')),
    no_identitas TEXT NOT NULL,
    foto_identitas TEXT, -- Berisi URL/Path foto yang diunggah ke storage bucket
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Rental
CREATE TABLE public.rental (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pelanggan_id UUID NOT NULL REFERENCES public.pelanggan(id) ON DELETE CASCADE,
    mobil_id UUID NOT NULL REFERENCES public.mobil(id) ON DELETE RESTRICT,
    tanggal_sewa DATE NOT NULL,
    tanggal_kembali DATE NOT NULL,
    total_biaya NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    status_rental TEXT NOT NULL DEFAULT 'aktif' CHECK (status_rental IN ('aktif', 'selesai', 'dibatalkan')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Pengembalian
CREATE TABLE public.pengembalian (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rental_id UUID NOT NULL UNIQUE REFERENCES public.rental(id) ON DELETE CASCADE,
    tanggal_kembali DATE NOT NULL,
    denda NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    kondisi_mobil TEXT NOT NULL DEFAULT 'Baik',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Pembayaran
CREATE TABLE public.pembayaran (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rental_id UUID NOT NULL REFERENCES public.rental(id) ON DELETE CASCADE,
    tanggal_bayar DATE NOT NULL,
    jumlah_bayar NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    metode_pembayaran TEXT NOT NULL DEFAULT 'Cash' CHECK (metode_pembayaran IN ('Cash', 'Transfer')),
    status_pembayaran TEXT NOT NULL DEFAULT 'pending' CHECK (status_pembayaran IN ('pending', 'lunas')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Servis
CREATE TABLE public.servis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mobil_id UUID NOT NULL REFERENCES public.mobil(id) ON DELETE CASCADE,
    tanggal_servis DATE NOT NULL,
    jenis_servis TEXT NOT NULL DEFAULT 'Servis Berkala',
    biaya_servis NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    keterangan TEXT,
    status_servis TEXT NOT NULL DEFAULT 'proses' CHECK (status_servis IN ('proses', 'selesai')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Karyawan
CREATE TABLE public.karyawan (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama_karyawan TEXT NOT NULL,
    alamat TEXT NOT NULL,
    no_hp TEXT NOT NULL,
    jabatan TEXT NOT NULL,
    tanggal_masuk DATE NOT NULL,
    status_karyawan TEXT NOT NULL DEFAULT 'aktif' CHECK (status_karyawan IN ('aktif', 'non-aktif')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tabel Notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,
    reference_id TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    action_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- =========================================================================
-- 2. VIEW UNTUK KEBUTUHAN LAPORAN & DASHBOARD
-- =========================================================================

-- View Laporan Servis
CREATE OR REPLACE VIEW public.laporan_servis AS
SELECT
  m.nama_mobil,
  m.plat_nomor,
  s.tanggal_servis,
  s.jenis_servis,
  s.biaya_servis,
  s.status_servis,
  s.keterangan
FROM public.servis s
JOIN public.mobil m ON s.mobil_id = m.id;

-- View Laporan Pengembalian
CREATE OR REPLACE VIEW public.laporan_pengembalian AS
SELECT
  p.id,
  p.rental_id,
  p.tanggal_kembali AS tanggal_pengembalian,
  p.denda,
  p.kondisi_mobil,
  p.created_at,
  pe.nama AS nama_pelanggan,
  m.nama_mobil,
  m.plat_nomor,
  r.tanggal_sewa AS tanggal_sewa,
  r.tanggal_kembali AS tanggal_estimasi,
  r.total_biaya,
  r.status_rental,
  (
    SELECT COALESCE(SUM(pb.jumlah_bayar), 0)
    FROM public.pembayaran pb
    WHERE pb.rental_id = r.id AND pb.status_pembayaran = 'lunas'
  )::numeric AS total_bayar
FROM public.pengembalian p
JOIN public.rental r ON p.rental_id = r.id
JOIN public.pelanggan pe ON r.pelanggan_id = pe.id
JOIN public.mobil m ON r.mobil_id = m.id;

-- View Dashboard Summary
CREATE OR REPLACE VIEW public.dashboard_summary AS
SELECT
  (SELECT COUNT(*) FROM public.pelanggan)::integer AS total_pelanggan,
  (SELECT COUNT(*) FROM public.rental)::integer AS total_rental,
  (SELECT COUNT(*) FROM public.mobil)::integer AS total_mobil,
  (SELECT COUNT(*) FROM public.mobil WHERE status_mobil = 'tersedia')::integer AS mobil_tersedia,
  (SELECT COUNT(*) FROM public.mobil WHERE status_mobil = 'disewa')::integer AS mobil_disewa,
  COALESCE((SELECT SUM(jumlah_bayar) FROM public.pembayaran WHERE status_pembayaran = 'lunas'), 0)::numeric AS total_pendapatan;

-- View Laporan Pendapatan
CREATE OR REPLACE VIEW public.laporan_pendapatan AS
SELECT 
  p.tanggal_bayar,
  p.id AS id_pembayaran,
  m.nama_mobil,
  pe.nama AS nama_pelanggan,
  p.metode_pembayaran,
  p.jumlah_bayar
FROM public.pembayaran p
JOIN public.rental r ON p.rental_id = r.id
JOIN public.pelanggan pe ON r.pelanggan_id = pe.id
JOIN public.mobil m ON r.mobil_id = m.id;

-- View Laporan Transaksi Rental
CREATE OR REPLACE VIEW public.laporan_transaksi_rental AS
SELECT
  r.id AS id_rental,
  pe.nama AS nama_pelanggan,
  m.nama_mobil,
  m.plat_nomor,
  r.tanggal_sewa,
  r.tanggal_kembali,
  r.status_rental,
  r.total_biaya,
  r.created_at
FROM public.rental r
JOIN public.pelanggan pe ON r.pelanggan_id = pe.id
JOIN public.mobil m ON r.mobil_id = m.id;

-- View Laporan Mobil Populer
CREATE OR REPLACE VIEW public.laporan_mobil_populer AS
SELECT
  m.nama_mobil,
  m.plat_nomor,
  COUNT(r.id)::integer AS total_disewa,
  COALESCE(SUM(p.jumlah_bayar), 0)::numeric AS total_pendapatan
FROM public.mobil m
LEFT JOIN public.rental r ON r.mobil_id = m.id
LEFT JOIN public.pembayaran p ON p.rental_id = r.id AND p.status_pembayaran = 'lunas'
GROUP BY m.id, m.nama_mobil, m.plat_nomor;

-- View Grafik Pendapatan Harian
CREATE OR REPLACE VIEW public.view_pendapatan AS
SELECT
  tanggal_bayar::text AS tanggal,
  SUM(jumlah_bayar)::numeric AS total
FROM public.pembayaran
WHERE status_pembayaran = 'lunas'
GROUP BY tanggal_bayar;
```

### C. Membuat Storage Bucket
Aplikasi membutuhkan media penyimpanan awan untuk menampung gambar identitas pelanggan:
1. Di dashboard Supabase, buka menu **Storage** -> **Buckets**.
2. Klik **New Bucket**.
3. Beri nama bucket exact: `identitas`.
4. Atur bucket menjadi **Public** agar foto dapat diakses langsung oleh aplikasi melalui link URL.
5. Konfigurasikan **Policies** pada bucket `identitas` agar pengguna terautentikasi dapat melakukan `INSERT`, `SELECT`, `UPDATE`, dan `DELETE`.

---

## 6. Cara Menjalankan Project

Ikuti langkah-langkah berikut untuk mengunduh dan menjalankan project di mesin lokal Anda:

### Langkah 1: Clone Repository
Buka terminal/command prompt, arahkan ke folder workspace Anda, dan jalankan perintah:
```bash
git clone https://github.com/username/rental_mobil.git
cd rental_mobil
```

### Langkah 2: Menginstal Dependency
Unduh semua pustaka (packages) Flutter yang didefinisikan di file `pubspec.yaml`:
```bash
flutter pub get
```

### Langkah 3: Konfigurasi Environment & Supabase
Anda dapat mengonfigurasi koneksi Supabase menggunakan salah satu dari dua cara berikut:

#### Cara A: Menggunakan CLI Flag `--dart-define` (Sangat Direkomendasikan)
Jalankan aplikasi dengan menyisipkan variabel environment langsung pada perintah terminal. Ini menghindarkan Anda dari menyimpan credential sensitif dalam kode:
```bash
flutter run --dart-define=SUPABASE_URL="https://your-project.supabase.co" --dart-define=SUPABASE_ANON_KEY="your-anon-key-string"
```

#### Cara B: Mengubah Nilai Default di Kode Sumber
Jika Anda tidak ingin mengetikkan flag setiap kali menjalankan aplikasi, Anda dapat membuka file [supabase_config.dart](file:///d:/KULIAH/Semester%206/Projek%203/coding/rental_mobil/lib/app/config/supabase_config.dart) dan mengganti parameter `defaultValue` dengan nilai dari Supabase Anda:
```dart
static const String url = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://jssqlrmoqobdtwxkteby.supabase.co/', // Ganti dengan URL Supabase Anda
);

static const String anonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpX...RywfUSRG0c', // Ganti dengan Anon Key Anda
);
```

### Langkah 4: Menjalankan Aplikasi
Pastikan emulator Android/iOS Anda aktif atau perangkat fisik sudah terhubung dengan USB Debugging menyala. Ketikkan perintah:
```bash
flutter run
```

---

## 7. Pembuatan Akun Default (Uji Coba)

Karena aplikasi tidak memiliki halaman registrasi pendaftaran mandiri (demi alasan keamanan operasional), semua akun harus didaftarkan secara manual oleh tim IT/Admin melalui Supabase Console.

### Cara Membuat Akun Pengguna Uji Coba:
1. Buka dashboard Supabase Anda -> **Authentication** -> **Users**.
2. Klik **Add User** -> **Create User**.
3. Isi kolom **Email** dan **Password** (misal: `admin@rental.com` dan `admin123`). Hapus centang pada *Auto-confirm User* jika Anda ingin memverifikasi email secara manual, atau biarkan tercentang agar akun langsung aktif. Klik **Save**.
4. Salin string **User ID** (UUID) dari akun yang baru Anda buat (contoh UUID: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`).
5. Buka **SQL Editor** di Supabase, jalankan query SQL untuk mendaftarkan detail user ke tabel public.users sesuai role masing-masing:

#### A. Membuat Akun Admin
```sql
INSERT INTO public.users (auth_user_id, nama, email, role, no_hp)
VALUES ('[UUID_USER_SUPABASE_ANDA]', 'Fulan Admin', 'admin@rental.com', 'admin', '081234567890');
```

#### B. Membuat Akun Owner
```sql
INSERT INTO public.users (auth_user_id, nama, email, role, no_hp)
VALUES ('[UUID_USER_SUPABASE_ANDA]', 'Haji Ahmad (Owner)', 'owner@rental.com', 'owner', '081299998888');
```

#### C. Membuat Akun Operator
```sql
INSERT INTO public.users (auth_user_id, nama, email, role, no_hp)
VALUES ('[UUID_USER_SUPABASE_ANDA]', 'Budi Operator', 'operator@rental.com', 'operator', '081255556666');
```

---

## 8. Tata Cara Implementasi Aplikasi (Langkah-demi-Langkah)

Berikut adalah panduan lengkap dari persiapan awal hingga aplikasi siap diserahkan kepada pengguna:

### Tahap 1: Setup Backend & Environment
1. Daftar atau login di [Supabase](https://supabase.com).
2. Buat project baru dan jalankan seluruh script SQL yang tersedia di bagian [Konfigurasi Database](#5-konfigurasi-database-supabase).
3. Buat bucket Storage publik bernama `identitas` untuk menampung gambar dokumen identitas pelanggan.

### Tahap 2: Registrasi Akun Staf Pertama
1. Buat minimal satu akun pengguna di menu **Authentication** di Supabase.
2. Catat UUID-nya, kemudian daftarkan UUID tersebut ke tabel `public.users` dengan role `admin` melalui query SQL (lihat bagian [Pembuatan Akun Default](#7-pembuatan-akun-default-uji-coba)).

### Tahap 3: Konfigurasi Kode Sumber Flutter
1. Tarik/clone source code aplikasi ke komputer lokal Anda.
2. Hubungkan URL Project Supabase dan Anon Key Anda ke aplikasi menggunakan konfigurasi `--dart-define` atau dengan mengubah default value di [supabase_config.dart](file:///d:/KULIAH/Semester%206/Projek%203/coding/rental_mobil/lib/app/config/supabase_config.dart).
3. Jalankan `flutter pub get` di terminal untuk memuat pustaka.

### Tahap 4: Build dan Rilis Aplikasi
1. Lakukan uji coba dalam mode debug (`flutter run`) untuk memastikan koneksi internet dan API terhubung dengan lancar.
2. Untuk merilis aplikasi dalam format file instalasi APK (Android), jalankan perintah:
   ```bash
   flutter build apk --release --dart-define=SUPABASE_URL="YOUR_SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="YOUR_SUPABASE_ANON_KEY"
   ```
3. Distribusikan file APK yang dihasilkan (`build/app/outputs/flutter-apk/app-release.apk`) ke perangkat Android milik Admin, Owner, dan Operator.

---

## 9. Alur Penggunaan Aplikasi

Berikut adalah ilustrasi alur kerja harian dalam menggunakan aplikasi Rental Mobil:

### Skenario A: Alur Operasional Penyewaan (Oleh Admin)
1. **Login**: Admin masuk menggunakan email dan password terdaftar.
2. **Input Armada Baru**: Admin masuk ke menu **Mobil**, klik ikon tambah, dan masukkan data mobil baru (plat nomor, harga harian, tipe, dll). Status mobil otomatis `tersedia`.
3. **Input Data Pelanggan**: Admin masuk ke menu **Pelanggan**, merekam identitas pelanggan baru, dan memotret KTP/SIM pelanggan. Foto otomatis diunggah ke Supabase Storage.
4. **Membuat Rental (Sewa)**: Admin membuka menu **Rental/Transaksi**, membuat transaksi penyewaan dengan memilih data pelanggan dan mobil yang diinginkan, serta menentukan tanggal sewa dan estimasi kembali. Durasi sewa dan total biaya akan dihitung otomatis. Status mobil berubah menjadi `disewa`.
5. **Pencatatan Pembayaran**: Admin memilih transaksi rental tadi, lalu melakukan input pembayaran (pilih metode Cash/Transfer dan isi nominal bayar). Jika pembayaran lunas, status pembayaran berubah menjadi `lunas`.
6. **Proses Pengembalian**: Saat pelanggan memulangkan mobil, Admin masuk ke menu **Pengembalian**, memilih transaksi rental aktif, memasukkan tanggal kembali riil, dan mencatat kondisi mobil. Jika pengembalian terlambat dari tanggal estimasi, sistem otomatis memunculkan nominal denda. Setelah disimpan, status mobil kembali `tersedia` dan status rental berubah menjadi `selesai`.

### Skenario B: Alur Pemantauan Bisnis (Oleh Owner)
1. **Login**: Owner masuk menggunakan akun ber-role `owner`.
2. **Dashboard Finansial**: Owner diarahkan ke halaman dashboard khusus yang menampilkan total omzet, jumlah mobil aktif disewa, grafik pendapatan harian, dan daftar mobil paling sering disewa.
3. **Membaca Laporan**: Owner masuk ke menu **Laporan**, menyaring data berdasarkan rentang waktu tertentu, lalu menekan tombol **Ekspor PDF** atau **Ekspor Excel** untuk menyimpan dokumen laporan keuangan.

### Skenario C: Alur Pemeliharaan & Perawatan (Oleh Operator)
1. **Login**: Operator masuk menggunakan akun ber-role `operator`.
2. **Cek Peringatan Notifikasi**: Operator melihat daftar notifikasi mengenai mobil yang harus diservis atau jadwal jatuh tempo pengembalian.
3. **Input Riwayat Servis**: Operator membawa mobil yang berstatus `servis` ke bengkel. Setelah selesai, operator mencatat jenis servis, biaya, keterangan perbaikan, dan mengubah status servis ke `selesai`. Status mobil di database otomatis diubah kembali menjadi `tersedia`.
