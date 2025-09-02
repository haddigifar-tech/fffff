# Panduan Import Data Seed ke Supabase

## Langkah 1: Dapatkan User ID Anda

1. Buka Supabase Dashboard → SQL Editor
2. Jalankan query berikut untuk mendapatkan user ID Anda:
   ```sql
   SELECT id, email FROM auth.users;
   ```
3. Salin UUID yang sesuai dengan email Anda

## Langkah 2: Update Migration File

1. Buka file `supabase/migrations/import_seed_data.sql`
2. Cari baris yang berisi:
   ```sql
   sample_user_id UUID := 'b27182c1-5487-4d8c-8cdf-526825d50426';
   ```
3. Ganti UUID tersebut dengan user ID Anda yang didapat dari Langkah 1

## Langkah 3: Jalankan Migration

1. Buka Supabase Dashboard → SQL Editor
2. Copy seluruh isi file `supabase/migrations/import_seed_data.sql`
3. Paste ke SQL Editor dan klik "Run"

## Langkah 4: Verifikasi Data

Setelah berhasil, Anda dapat memverifikasi dengan query:
```sql
-- Cek jumlah data yang berhasil diimport
SELECT 
  (SELECT COUNT(*) FROM profiles) as profiles,
  (SELECT COUNT(*) FROM clients) as clients,
  (SELECT COUNT(*) FROM projects) as projects,
  (SELECT COUNT(*) FROM packages) as packages,
  (SELECT COUNT(*) FROM transactions) as transactions;
```

## Troubleshooting

- **Error "duplicate key"**: Data sudah ada, migration akan skip data yang duplikat
- **Error "foreign key"**: Pastikan user ID sudah benar
- **Error "invalid enum"**: Periksa apakah semua enum types sudah dibuat di schema

## Data yang Akan Diimport

- ✅ 1 Profile lengkap dengan konfigurasi
- ✅ 5 Packages (Silver, Gold, Basic, Premium, Corporate)
- ✅ 6 Add-ons
- ✅ 5 Clients dengan berbagai status
- ✅ 5 Team members (freelancers)
- ✅ 5 Leads dengan berbagai channel
- ✅ 3 Projects dengan status berbeda
- ✅ 4 Cards (BCA, Mandiri, BNI, Cash)
- ✅ 5 Financial pockets
- ✅ 8 Transactions (income & expense)
- ✅ 5 Promo codes
- ✅ 8 Assets (kamera, lensa, dll)
- ✅ 4 SOPs (protokol kerja)
- ✅ 2 Contracts
- ✅ 4 Social media posts
- ✅ 5 Client feedback

Setelah import berhasil, Anda akan memiliki data lengkap untuk testing dan development aplikasi.