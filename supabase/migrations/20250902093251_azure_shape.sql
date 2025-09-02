/*
  # Import seed data for Vena Pictures application

  1. Data Import
    - Sample profiles with proper configuration
    - Sample clients, projects, and transactions
    - Sample packages, add-ons, and team members
    - Sample leads, assets, and other entities
  
  2. Data Adjustments
    - Updated to match current database schema
    - Proper enum values and data types
    - Consistent foreign key relationships
    - Default values for required fields

  3. Important Notes
    - Replace the sample_user_id with your actual auth user ID
    - Run this after creating your account in the application
    - This will populate your database with realistic sample data
*/

-- First, get the current user ID (you'll need to replace this with your actual user ID)
-- To get your user ID, run: SELECT id FROM auth.users;
DO $$
DECLARE
    sample_user_id UUID := 'ac29a74e-1efc-4953-a599-fc08e842e0c7'; -- Replace with your actual user ID
BEGIN

-- Insert sample profile with admin role and complete configuration
INSERT INTO profiles (
    id, 
    full_name, 
    email, 
    phone,
    role,
    permissions,
    is_active,
    company_name, 
    website,
    address,
    bank_account,
    authorized_signer,
    id_number,
    bio,
    income_categories,
    expense_categories,
    project_types,
    event_types,
    asset_categories,
    sop_categories,
    package_categories,
    project_status_config,
    notification_settings,
    security_settings,
    briefing_template,
    terms_and_conditions,
    contract_template,
    brand_color,
    public_page_config,
    package_share_template,
    booking_form_template,
    chat_templates,
    last_login
) VALUES (
    sample_user_id,
    'Andi Vena',
    'admin@venapictures.com',
    '081234567890',
    'Admin',
    '{"manage_users": true, "manage_projects": true, "manage_finance": true, "manage_settings": true, "view_reports": true, "manage_team": true}',
    true,
    'Vena Pictures',
    'https://venapictures.com',
    'Jl. Sudirman No. 123, Jakarta Selatan',
    'BCA 1234567890 a.n. Vena Pictures',
    'Andi Vena',
    '1234567890123456',
    'Professional photography and videography services for weddings, pre-wedding, and events.',
    ARRAY['Proyek Foto', 'Proyek Video', 'Layanan Tambahan', 'Penjualan Produk'],
    ARRAY['Operasional', 'Peralatan', 'Transport', 'Akomodasi', 'Marketing', 'Freelancer'],
    ARRAY['Pernikahan', 'Prewedding', 'Engagement', 'Siraman', 'Akad', 'Resepsi'],
    ARRAY['Meeting Klien', 'Survey Lokasi', 'Libur', 'Workshop', 'Lainnya'],
    ARRAY['Kamera', 'Lensa', 'Lighting', 'Audio', 'Aksesoris', 'Komputer'],
    ARRAY['Pernikahan', 'Prewedding', 'Event', 'Editing', 'Equipment'],
    ARRAY['Pernikahan', 'Prewedding', 'Event', 'Corporate'],
    '[
        {"id": "1", "name": "Baru", "color": "#3b82f6", "subStatuses": [], "note": "Proyek baru masuk"},
        {"id": "2", "name": "Dikonfirmasi", "color": "#10b981", "subStatuses": [], "note": "Booking dikonfirmasi"},
        {"id": "3", "name": "Persiapan", "color": "#8b5cf6", "subStatuses": [{"name": "Survey Lokasi", "note": "Kunjungi lokasi acara"}, {"name": "Briefing Klien", "note": "Meeting dengan klien"}], "note": "Tahap persiapan"},
        {"id": "4", "name": "Pelaksanaan", "color": "#f97316", "subStatuses": [{"name": "Setup Equipment", "note": "Persiapan alat"}, {"name": "Dokumentasi", "note": "Proses pengambilan gambar"}], "note": "Hari H pelaksanaan"},
        {"id": "5", "name": "Editing", "color": "#06b6d4", "subStatuses": [{"name": "Seleksi Foto", "note": "Pilih foto terbaik"}, {"name": "Color Grading", "note": "Proses editing warna"}, {"name": "Final Touch", "note": "Finishing touches"}], "note": "Proses editing"},
        {"id": "6", "name": "Review Klien", "color": "#eab308", "subStatuses": [{"name": "Preview Dikirim", "note": "Kirim preview ke klien"}, {"name": "Menunggu Feedback", "note": "Tunggu konfirmasi klien"}], "note": "Menunggu approval klien"},
        {"id": "7", "name": "Produksi", "color": "#6366f1", "subStatuses": [{"name": "Cetak Album", "note": "Proses cetak album"}, {"name": "Packaging", "note": "Kemasan produk"}], "note": "Produksi fisik"},
        {"id": "8", "name": "Selesai", "color": "#16a34a", "subStatuses": [], "note": "Proyek selesai"},
        {"id": "9", "name": "Dibatalkan", "color": "#ef4444", "subStatuses": [], "note": "Proyek dibatalkan"}
    ]',
    '{"newProject": true, "paymentConfirmation": true, "deadlineReminder": true}',
    '{"twoFactorEnabled": false}',
    'Template briefing untuk klien: 1. Konsep acara, 2. Timeline, 3. Shot list, 4. Requirement khusus',
    '📜 SYARAT DAN KETENTUAN UMUM VENA PICTURES

📅 JADWAL DAN WAKTU
- Reschedule maksimal 1 kali tanpa biaya tambahan
- Reschedule kedua dikenakan biaya 20% dari total paket
- Pembatalan H-7 sebelum acara, DP tidak dapat dikembalikan
- Force majeure (bencana alam, pandemi) ditanggung bersama

💰 PEMBAYARAN
- DP minimal 30% dari total biaya saat booking
- Pelunasan maksimal H-3 sebelum hari pelaksanaan
- Keterlambatan pembayaran dikenakan denda 2% per hari
- Pembayaran melalui transfer bank ke rekening resmi

📦 DELIVERABLES
- Preview foto dikirim maksimal H+7 setelah acara
- Final edit sesuai timeline yang disepakati
- Revisi unlimited dalam 7 hari setelah delivery
- File RAW disimpan 1 tahun, setelah itu akan dihapus

⏱ TIMELINE PENGERJAAN
- Wedding: 30 hari kerja
- Prewedding: 14 hari kerja
- Event/Corporate: 7 hari kerja
- Timeline dapat berubah sesuai kompleksitas dan antrian

➕ KETENTUAN TAMBAHAN
- Vendor berhak menggunakan hasil foto untuk portfolio
- Klien mendapat hak cipta penuh atas hasil akhir
- Akomodasi dan transport di luar kota ditanggung klien
- Equipment backup selalu tersedia untuk menghindari risiko',
    'SURAT PERJANJIAN KERJA SAMA JASA FOTOGRAFI & VIDEOGRAFI

Pada hari ini, {signingDate}, bertempat di {signingLocation}, telah dibuat dan disepakati perjanjian kerja sama antara:

PIHAK PERTAMA
{vendorCompanyName}, yang diwakili oleh {vendorSignerName}
Alamat: {vendorAddress}
Telepon: {vendorPhone}
ID: {vendorIdNumber}

PIHAK KEDUA  
{clientName1} (Telepon: {clientPhone1})
Alamat: {clientAddress1}
{clientName2} (Telepon: {clientPhone2})
Alamat: {clientAddress2}

PASAL 1: RUANG LINGKUP PEKERJAAN
PIHAK PERTAMA akan memberikan jasa {projectType} untuk acara {projectName} pada tanggal {projectDate} di {projectLocation}. 

Rincian layanan:
- Durasi: {shootingDuration}
- Foto: {guaranteedPhotos}  
- Album: {albumDetails}
- Format Digital: {digitalFilesFormat}
- Lainnya: {otherItems}
- Personel: {personnelCount}
- Waktu Pengerjaan: {deliveryTimeframe}

PASAL 2: BIAYA DAN PEMBAYARAN
Total biaya: {totalCost}
DP: {dpAmount} (tanggal: {dpDate})
Pelunasan: tanggal {finalPaymentDate}

PASAL 3: PEMBATALAN
{cancellationPolicy}

PASAL 4: PENYELESAIAN SENGKETA
Sengketa diselesaikan di wilayah hukum {jurisdiction}.

Demikian perjanjian ini dibuat dengan penuh kesadaran.',
    '#3B82F6',
    '{"template": "modern", "title": "Paket Fotografi & Videografi Premium", "introduction": "Abadikan momen spesial Anda dengan layanan fotografi dan videografi profesional dari Vena Pictures.", "galleryImages": []}',
    'Halo {leadName}! 👋

Terima kasih sudah menghubungi {companyName}. Kami senang bisa membantu mengabadikan momen spesial Anda!

Silakan lihat koleksi paket kami di: {packageLink}

Jika ada pertanyaan, jangan ragu untuk chat kami ya! 😊',
    'Halo {leadName}! 🎉

Terima kasih sudah tertarik dengan layanan {companyName}. 

Untuk melanjutkan proses booking, silakan isi formulir berikut: {bookingFormLink}

Tim kami akan segera memproses dan menghubungi Anda untuk konfirmasi. 

Terima kasih! 😊',
    '[
        {"id": "greeting", "title": "Salam Pembuka", "template": "Halo {clientName}! Terima kasih sudah mempercayakan {companyName} untuk proyek {projectName}. Kami akan memberikan yang terbaik! 😊"},
        {"id": "reminder", "title": "Pengingat Jadwal", "template": "Hi {clientName}, ini pengingat untuk proyek {projectName}. Jangan lupa persiapan untuk besok ya! 📅"},
        {"id": "update", "title": "Update Progress", "template": "Update untuk {clientName}: Progress {projectName} sudah mencapai tahap baru. Cek portal klien untuk detail lengkap! ✨"},
        {"id": "delivery", "title": "Pemberitahuan Selesai", "template": "Good news {clientName}! Proyek {projectName} sudah selesai dan siap untuk dilihat. Silakan cek portal klien Anda! 🎉"}
    ]',
    NOW()
) ON CONFLICT (id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    company_name = EXCLUDED.company_name,
    updated_at = NOW();

-- Insert sample packages
INSERT INTO packages (id, user_id, name, price, category, physical_items, digital_items, processing_time, photographers, videographers, cover_image) VALUES
('PKG001', sample_user_id, 'Paket Pernikahan Silver', 12000000, 'Pernikahan', 
 '[{"name": "Album 10R 20 halaman", "price": 500000}, {"name": "Frame 8R", "price": 150000}]',
 ARRAY['50 foto edit terbaik', 'Video highlight 3-5 menit'],
 '14 hari kerja', 'Fotografer utama', 'Videografer utama', ''),
('PKG002', sample_user_id, 'Paket Pernikahan Gold', 18000000, 'Pernikahan',
 '[{"name": "Album 10R 30 halaman", "price": 750000}, {"name": "Frame 8R", "price": 200000}, {"name": "USB Flashdisk", "price": 100000}]',
 ARRAY['100 foto edit terbaik', 'Video highlight 5-8 menit', 'Same day edit'],
 '21 hari kerja', 'Fotografer utama + asisten', 'Videografer utama + asisten', ''),
('PKG003', sample_user_id, 'Paket Prewedding Basic', 3500000, 'Prewedding',
 '[{"name": "USB Flashdisk", "price": 50000}]',
 ARRAY['20 foto edit berkualitas tinggi', 'Semua file RAW'],
 '7 hari kerja', 'Fotografer utama', '', ''),
('PKG004', sample_user_id, 'Paket Prewedding Premium', 5500000, 'Prewedding',
 '[{"name": "Album 10R 15 halaman", "price": 400000}, {"name": "Frame 8R", "price": 100000}, {"name": "USB Flashdisk", "price": 50000}]',
 ARRAY['35 foto edit berkualitas tinggi', 'Video cinematic 2-3 menit', 'Semua file RAW'],
 '10 hari kerja', 'Fotografer utama', 'Videografer', ''),
('PKG005', sample_user_id, 'Paket Corporate Event', 8000000, 'Corporate',
 '[{"name": "USB Flashdisk", "price": 50000}]',
 ARRAY['100 foto dokumentasi', 'Video dokumentasi 10 menit', 'Slide presentation'],
 '5 hari kerja', 'Fotografer + asisten', 'Videografer', '')
ON CONFLICT (id) DO NOTHING;

-- Insert sample add-ons
INSERT INTO add_ons (id, user_id, name, price) VALUES
('ADO001', sample_user_id, 'Photographer Tambahan', 1500000),
('ADO002', sample_user_id, 'Video Cinematic', 2500000),
('ADO003', sample_user_id, 'Album Tambahan 10R', 500000),
('ADO004', sample_user_id, 'Same Day Edit', 1000000),
('ADO005', sample_user_id, 'Drone Shot', 800000),
('ADO006', sample_user_id, 'Live Streaming', 2000000)
ON CONFLICT (id) DO NOTHING;

-- Insert sample clients
INSERT INTO clients (id, user_id, name, email, phone, whatsapp, status, client_type, portal_access_id, total_proyek_value, balance_due) VALUES
('CLI001', sample_user_id, 'Budi & Sinta', 'budi.sinta@email.com', '081234567891', '6281234567891', 'Aktif', 'Langsung', 'portal-budi-sinta-1a2b', 12000000, 6000000),
('CLI002', sample_user_id, 'Ravi & Dewi', 'ravi.dewi@email.com', '081234567892', '6281234567892', 'Aktif', 'Langsung', 'portal-ravi-dewi-3c4d', 5000000, 0),
('CLI003', sample_user_id, 'Ahmad & Sari', 'ahmad.sari@email.com', '081234567893', '6281234567893', 'Prospek', 'Langsung', 'portal-ahmad-sari-5e6f', 0, 0),
('CLI004', sample_user_id, 'PT Maju Bersama', 'info@majubersama.co.id', '021123456789', '62811122334455', 'Aktif', 'Vendor', 'portal-pt-maju-7g8h', 15000000, 0),
('CLI005', sample_user_id, 'Jessica & Rio', 'jessica.rio@email.com', '081234567894', '6281234567894', 'Tidak Aktif', 'Langsung', 'portal-jessica-rio-9i0j', 8000000, 0)
ON CONFLICT (id) DO NOTHING;

-- Insert sample team members
INSERT INTO team_members (id, user_id, name, role, email, phone, standard_fee, no_rek, reward_balance, rating, portal_access_id, performance_notes) VALUES
('TM001', sample_user_id, 'Rizki Pratama', 'Fotografer', 'rizki@email.com', '081234567894', 800000, 'BCA 1234567890', 250000, 4.8, 'portal-rizki-1g2h', '[]'),
('TM002', sample_user_id, 'Maya Sari', 'Videografer', 'maya@email.com', '081234567895', 1000000, 'Mandiri 0987654321', 180000, 4.9, 'portal-maya-3i4j', '[]'),
('TM003', sample_user_id, 'Doni Kurniawan', 'Editor', 'doni@email.com', '081234567896', 500000, 'BNI 1122334455', 120000, 4.7, 'portal-doni-5k6l', '[]'),
('TM004', sample_user_id, 'Sari Indah', 'Fotografer', 'sari@email.com', '081234567897', 750000, 'BCA 9988776655', 200000, 4.6, 'portal-sari-7m8n', '[]'),
('TM005', sample_user_id, 'Benny Wijaya', 'Videografer', 'benny@email.com', '081234567898', 950000, 'CIMB 5544332211', 300000, 4.8, 'portal-benny-9o0p', '[]')
ON CONFLICT (id) DO NOTHING;

-- Insert sample leads
INSERT INTO leads (id, user_id, name, contact_channel, location, status, notes, whatsapp) VALUES
('LEAD001', sample_user_id, 'Jessica', 'Instagram', 'Jakarta', 'Sedang Diskusi', 'Tertarik paket Gold untuk pernikahan Oktober', '6281234567897'),
('LEAD002', sample_user_id, 'Andi', 'WhatsApp', 'Bandung', 'Menunggu Follow Up', 'Minta penawaran prewedding outdoor', '6281234567898'),
('LEAD003', sample_user_id, 'PT Sukses Mandiri', 'Website', 'Surabaya', 'Sedang Diskusi', 'Butuh dokumentasi annual meeting 200 orang', '62811223344'),
('LEAD004', sample_user_id, 'Rina & Dimas', 'Referensi', 'Yogyakarta', 'Menunggu Follow Up', 'Referensi dari Budi & Sinta, budget 15 juta', '6281567890123'),
('LEAD005', sample_user_id, 'Toko Berlian Permata', 'Telepon', 'Jakarta', 'Ditolak', 'Budget tidak sesuai dengan requirement', '6281987654321')
ON CONFLICT (id) DO NOTHING;

-- Insert sample projects
INSERT INTO projects (
    id, user_id, project_name, client_name, client_id, project_type, 
    package_name, package_id, date, deadline_date, location, 
    progress, status, total_cost, amount_paid, payment_status,
    team, notes, accommodation, drive_link, client_drive_link,
    add_ons, active_sub_statuses, booking_status
) VALUES
('PRJ001', sample_user_id, 'Pernikahan Budi & Sinta', 'Budi & Sinta', 'CLI001', 'Pernikahan',
 'Paket Pernikahan Silver', 'PKG001', '2024-03-15', '2024-03-29', 'Gedung Graha Jakarta',
 75, 'Editing', 12000000, 6000000, 'DP Terbayar',
 '[{"memberId": "TM001", "name": "Rizki Pratama", "role": "Fotografer", "fee": 800000}, {"memberId": "TM002", "name": "Maya Sari", "role": "Videografer", "fee": 1000000}]',
 'Klien request tambahan dokumentasi backstage', 'Hotel disediakan venue',
 'https://drive.google.com/drive/folders/1example', 'https://drive.google.com/drive/folders/2example',
 '[]', ARRAY['Seleksi Foto', 'Color Grading'], 'Terkonfirmasi'),
('PRJ002', sample_user_id, 'Prewedding Ravi & Dewi', 'Ravi & Dewi', 'CLI002', 'Prewedding',
 'Paket Prewedding Premium', 'PKG004', '2024-02-20', '2024-03-05', 'Taman Mini Indonesia',
 100, 'Selesai', 5000000, 5000000, 'Lunas',
 '[{"memberId": "TM001", "name": "Rizki Pratama", "role": "Fotografer", "fee": 750000}, {"memberId": "TM002", "name": "Maya Sari", "role": "Videografer", "fee": 950000}]',
 'Shoot pagi hari untuk golden hour', '', 
 'https://drive.google.com/drive/folders/3example', 'https://drive.google.com/drive/folders/4example',
 '[]', '{}', 'Terkonfirmasi'),
('PRJ003', sample_user_id, 'Corporate Event PT Maju', 'PT Maju Bersama', 'CLI004', 'Corporate',
 'Paket Corporate Event', 'PKG005', '2024-04-10', '2024-04-17', 'Hotel Shangri-La Jakarta',
 25, 'Persiapan', 8000000, 4000000, 'DP Terbayar',
 '[{"memberId": "TM001", "name": "Rizki Pratama", "role": "Fotografer", "fee": 800000}, {"memberId": "TM004", "name": "Sari Indah", "role": "Fotografer", "fee": 750000}, {"memberId": "TM002", "name": "Maya Sari", "role": "Videografer", "fee": 1000000}]',
 'Event 2 hari, dokumentasi lengkap semua sesi', 'Akomodasi disediakan klien',
 '', '', '[]', ARRAY['Survey Lokasi'], 'Terkonfirmasi')
ON CONFLICT (id) DO NOTHING;

-- Insert sample cards
INSERT INTO cards (id, user_id, card_holder_name, bank_name, card_type, last_four_digits, balance, color_gradient) VALUES
('CARD001', sample_user_id, 'Andi Vena', 'BCA', 'Debit', '3090', 25000000, 'from-blue-500 to-blue-600'),
('CARD002', sample_user_id, 'Vena Pictures', 'Mandiri', 'Debit', '7654', 15000000, 'from-yellow-500 to-orange-500'),
('CARD003', sample_user_id, 'Andi Vena', 'BNI', 'Kredit', '1234', 5000000, 'from-green-500 to-green-600'),
('CARD_CASH', sample_user_id, 'Cash', 'Tunai', 'Tunai', 'CASH', 2000000, 'from-gray-500 to-gray-600')
ON CONFLICT (id) DO NOTHING;

-- Insert sample financial pockets
INSERT INTO financial_pockets (id, user_id, name, description, icon, type, amount, goal_amount, source_card_id) VALUES
('FP001', sample_user_id, 'Kantong Operasional', 'Dana untuk operasional harian', '💼', 'Nabung & Bayar', 15000000, 20000000, 'CARD001'),
('FP002', sample_user_id, 'Dana Darurat', 'Tabungan untuk kondisi darurat', '🚨', 'Terkunci', 25000000, 50000000, 'CARD001'),
('FP003', sample_user_id, 'Upgrade Peralatan', 'Tabungan untuk beli kamera baru', '📷', 'Nabung & Bayar', 8000000, 30000000, 'CARD002'),
('FP004', sample_user_id, 'Marketing Budget', 'Dana untuk promosi dan iklan', '📢', 'Anggaran Pengeluaran', 3000000, 5000000, 'CARD002'),
('FP005', sample_user_id, 'Team Reward Pool', 'Pool hadiah untuk freelancer', '⭐', 'Tabungan Hadiah Freelancer', 2000000, 10000000, 'CARD001')
ON CONFLICT (id) DO NOTHING;

-- Insert sample transactions
INSERT INTO transactions (
    id, user_id, date, description, amount, type, 
    project_id, category, method, card_id
) VALUES
('TXN001', sample_user_id, '2024-02-15', 'DP Pernikahan Budi & Sinta', 6000000, 'Pemasukan', 'PRJ001', 'Proyek Foto', 'Transfer Bank', 'CARD001'),
('TXN002', sample_user_id, '2024-02-20', 'Pelunasan Prewedding Ravi & Dewi', 5000000, 'Pemasukan', 'PRJ002', 'Proyek Foto', 'Transfer Bank', 'CARD001'),
('TXN003', sample_user_id, '2024-02-18', 'Pembelian Lensa Canon 85mm', 8000000, 'Pengeluaran', NULL, 'Peralatan', 'Transfer Bank', 'CARD002'),
('TXN004', sample_user_id, '2024-02-22', 'Fee Fotografer - Rizki (PRJ002)', 750000, 'Pengeluaran', 'PRJ002', 'Freelancer', 'Transfer Bank', 'CARD001'),
('TXN005', sample_user_id, '2024-02-22', 'Fee Videografer - Maya (PRJ002)', 950000, 'Pengeluaran', 'PRJ002', 'Freelancer', 'Transfer Bank', 'CARD001'),
('TXN006', sample_user_id, '2024-03-01', 'Biaya Transport Shoot Taman Mini', 200000, 'Pengeluaran', 'PRJ002', 'Transport', 'Tunai', 'CARD_CASH'),
('TXN007', sample_user_id, '2024-03-05', 'DP Corporate Event PT Maju', 4000000, 'Pemasukan', 'PRJ003', 'Proyek Foto', 'Transfer Bank', 'CARD001'),
('TXN008', sample_user_id, '2024-01-15', 'Service Kamera Sony FX3', 500000, 'Pengeluaran', NULL, 'Peralatan', 'Transfer Bank', 'CARD002')
ON CONFLICT (id) DO NOTHING;

-- Insert sample promo codes
INSERT INTO promo_codes (id, user_id, code, discount_type, discount_value, is_active, max_usage, expiry_date) VALUES
('PROMO001', sample_user_id, 'WEDDING2024', 'percentage', 10, true, 50, '2024-12-31'),
('PROMO002', sample_user_id, 'EARLYBIRD', 'fixed', 1000000, true, 20, '2024-06-30'),
('PROMO003', sample_user_id, 'NEWCLIENT', 'percentage', 15, true, 100, '2024-08-31'),
('PROMO004', sample_user_id, 'REFERRAL50', 'fixed', 500000, true, 30, '2024-07-31'),
('PROMO005', sample_user_id, 'BIRTHDAY2024', 'percentage', 20, false, 10, '2024-05-31')
ON CONFLICT (id) DO NOTHING;

-- Insert sample assets
INSERT INTO assets (id, user_id, name, category, status, purchase_date, purchase_price, current_value, notes) VALUES
('AST001', sample_user_id, 'Canon EOS R5', 'Kamera', 'Tersedia', '2023-01-15', 55000000, 45000000, 'Kamera utama untuk wedding'),
('AST002', sample_user_id, 'Sony FX3', 'Kamera', 'Digunakan', '2023-03-20', 42000000, 38000000, 'Kamera video cinematic'),
('AST003', sample_user_id, 'DJI Mini 3 Pro', 'Aksesoris', 'Tersedia', '2023-05-10', 12000000, 10000000, 'Drone untuk aerial shot'),
('AST004', sample_user_id, 'MacBook Pro M2', 'Komputer', 'Digunakan', '2023-02-01', 28000000, 25000000, 'Laptop untuk editing'),
('AST005', sample_user_id, 'Godox AD600', 'Lighting', 'Perbaikan', '2022-12-05', 8000000, 6000000, 'Flash studio, perlu service'),
('AST006', sample_user_id, 'Canon 85mm f/1.4', 'Lensa', 'Tersedia', '2024-02-18', 8000000, 8000000, 'Lensa portrait premium'),
('AST007', sample_user_id, 'Rode Wireless Go II', 'Audio', 'Tersedia', '2023-08-10', 3500000, 3000000, 'Mic wireless untuk video'),
('AST008', sample_user_id, 'Manfrotto Tripod Carbon', 'Aksesoris', 'Tersedia', '2023-04-15', 4500000, 4000000, 'Tripod carbon fiber')
ON CONFLICT (id) DO NOTHING;

-- Insert sample SOPs
INSERT INTO sops (id, user_id, title, category, content) VALUES
('SOP001', sample_user_id, 'Protokol Pernikahan Lengkap', 'Pernikahan', 
'# Protokol Pernikahan Lengkap

## Persiapan H-7
1. Briefing dengan klien via WhatsApp/meeting
2. Konfirmasi timeline acara dan shot list
3. Survey lokasi akad dan resepsi
4. Koordinasi dengan vendor lain (WO, catering, dekor)

## Persiapan H-1
1. Charge semua baterai dan format memory card
2. Cek kelengkapan equipment checklist
3. Siapkan backup equipment
4. Konfirmasi ulang dengan klien dan tim

## Hari H - Setup
1. Datang 2 jam sebelum akad
2. Setup equipment dan test lighting
3. Brief ulang dengan tim fotografer/videografer
4. Koordinasi dengan WO untuk timeline

## Dokumentasi
1. Akad nikah: Fokus moment sakral
2. Sesi foto keluarga: Systematic group shots
3. Resepsi: Candid dan momen penting
4. Backup foto setiap 2 jam

## Post Production
1. Backup semua file dalam 24 jam
2. Quick preview untuk klien H+3
3. Full editing selesai sesuai kontrak
4. Delivery via drive link dan portal klien'),

('SOP002', sample_user_id, 'Checklist Peralatan Prewedding', 'Prewedding',
'# Checklist Peralatan Prewedding

## KAMERA & LENSA
- [ ] Kamera utama + backup
- [ ] Lensa 24-70mm f/2.8
- [ ] Lensa 85mm f/1.4 untuk portrait
- [ ] Lensa 16-35mm f/2.8 untuk wide angle
- [ ] Lens cleaning kit

## AKSESORIS FOTOGRAFI
- [ ] Baterai cadangan (minimum 4 pieces)
- [ ] Memory card (minimum 3 pieces)
- [ ] Card reader
- [ ] Tripod + monopod
- [ ] Reflektor 5 in 1
- [ ] Flash + diffuser
- [ ] Remote trigger

## EQUIPMENT TAMBAHAN
- [ ] Drone (jika location memungkinkan)
- [ ] Audio recorder untuk video
- [ ] Extra lighting equipment
- [ ] Extension cable

## POST PRODUCTION
- [ ] Laptop + charger
- [ ] Hard disk eksternal
- [ ] Preset Lightroom sesuai mood
- [ ] Backup storage'),

('SOP003', sample_user_id, 'Protokol Komunikasi Klien', 'Event',
'# Protokol Komunikasi Klien

## Response Time
- WhatsApp: maksimal 2 jam kerja
- Email: maksimal 4 jam kerja  
- Portal klien: update real-time

## Update Progress
- Upload preview ke portal klien
- Notification otomatis via WhatsApp
- Weekly progress report untuk project >2 minggu

## Handling Revisi
- Konfirmasi revisi dalam 24 jam
- Clarify scope revisi sebelum dikerjakan
- Update timeline jika ada major revision

## Delivery Protocol
- Preview hasil H+3 setelah acara
- Final delivery sesuai kontrak
- Follow up satisfaction survey
- Archive project files setelah 1 tahun'),

('SOP004', sample_user_id, 'Equipment Maintenance', 'Equipment',
'# Equipment Maintenance Schedule

## Daily Check
- [ ] Lens cleaning
- [ ] Battery level check
- [ ] Memory card formatting
- [ ] Equipment storage

## Weekly Maintenance
- [ ] Deep cleaning camera body
- [ ] Check all settings dan modes
- [ ] Test all lenses
- [ ] Backup equipment check

## Monthly Service
- [ ] Professional sensor cleaning
- [ ] Firmware updates
- [ ] Equipment calibration
- [ ] Insurance documentation update

## Annual Service
- [ ] Professional servicing all cameras
- [ ] Equipment value assessment
- [ ] Insurance renewal
- [ ] Equipment upgrade planning')
ON CONFLICT (id) DO NOTHING;

-- Insert sample contracts
INSERT INTO contracts (id, user_id, project_id, client_name, template_content, is_signed, signed_at) VALUES
('CTR001', sample_user_id, 'PRJ001', 'Budi & Sinta', 
'KONTRAK DOKUMENTASI PERNIKAHAN

PIHAK PERTAMA: Vena Pictures
PIHAK KEDUA: Budi & Sinta

PAKET: Paket Pernikahan Silver
NILAI KONTRAK: Rp 12.000.000

LINGKUP PEKERJAAN:
- Dokumentasi akad nikah dan resepsi
- 50 foto edit terbaik
- Video highlight 3-5 menit
- Album 10R 20 halaman
- 2 Frame 8R

TIMELINE:
- Acara: 15 Maret 2024
- Delivery: 29 Maret 2024

PEMBAYARAN:
- DP 50%: Rp 6.000.000 (LUNAS)
- Pelunasan: Rp 6.000.000 (saat delivery)

KETENTUAN:
- Reschedule max 1x tanpa biaya
- Force majeure ditanggung bersama
- Revisi unlimited dalam 7 hari', false, NULL),

('CTR002', sample_user_id, 'PRJ002', 'Ravi & Dewi',
'KONTRAK DOKUMENTASI PREWEDDING

PIHAK PERTAMA: Vena Pictures  
PIHAK KEDUA: Ravi & Dewi

PAKET: Paket Prewedding Premium
NILAI KONTRAK: Rp 5.000.000

LINGKUP PEKERJAAN:
- Sesi foto 4 jam
- 35 foto edit berkualitas tinggi
- Video cinematic 2-3 menit
- Album 10R 15 halaman
- Semua file RAW

LOKASI: Taman Mini Indonesia Indah
TANGGAL: 20 Februari 2024
DELIVERY: 5 Maret 2024

PEMBAYARAN: LUNAS Rp 5.000.000

STATUS: SELESAI', true, '2024-02-15T10:00:00Z')
ON CONFLICT (id) DO NOTHING;

-- Insert sample social posts
INSERT INTO social_posts (id, user_id, content, type, status, scheduled_date, project_id, hashtags) VALUES
('SP001', sample_user_id, 
'Behind the scenes dari prewedding Ravi & Dewi di Taman Mini! 📸✨ 
Lokasi yang memukau dengan chemistry yang natural dari pasangan ini. 

Swipe untuk lihat beberapa candid moment dari session kemarin!', 
'Instagram Feed', 'Diposting', '2024-02-25T10:00:00Z', 'PRJ002',
ARRAY['VenaPictures', 'PreweddingShoot', 'TamanMini', 'WeddingPhotographer', 'Jakarta', 'PreweddingJakarta']),

('SP002', sample_user_id,
'Coming soon: Pernikahan Budi & Sinta! 💕
Persiapan sudah 75% dan kami excited banget untuk mengabadikan momen spesial mereka.

Stay tuned for the magical moments! ✨', 
'Instagram Story', 'Terjadwal', '2024-03-10T09:00:00Z', 'PRJ001',
ARRAY['VenaPictures', 'WeddingDay', 'ComingSoon', 'WeddingPhotography']),

('SP003', sample_user_id,
'Tips memilih fotografer pernikahan yang tepat:

1️⃣ Lihat portfolio konsisten
2️⃣ Meeting langsung dengan tim
3️⃣ Diskusikan timeline detail  
4️⃣ Pastikan backup peralatan
5️⃣ Baca testimoni klien sebelumnya

Ada pertanyaan? DM kami! 📩', 
'Instagram Feed', 'Draf', NULL, NULL,
ARRAY['WeddingTips', 'VenaPictures', 'WeddingPlanning', 'WeddingPhotographer', 'BrideAndGroom']),

('SP004', sample_user_id,
'Corporate photography untuk PT Maju Bersama coming soon! 🏢
Professional documentation untuk annual meeting dengan 200+ participants.

#CorporatePhotography #VenaPictures #ProfessionalEvent', 
'Instagram Feed', 'Terjadwal', '2024-04-08T08:00:00Z', 'PRJ003',
ARRAY['CorporatePhotography', 'VenaPictures', 'ProfessionalEvent', 'Jakarta', 'EventDocumentation'])
ON CONFLICT (id) DO NOTHING;

-- Insert sample client feedback
INSERT INTO client_feedback (id, user_id, client_name, rating, feedback, project_id) VALUES
('CF001', sample_user_id, 'Ravi & Dewi', 5, 
'Tim Vena Pictures sangat profesional! Hasil foto prewedding kami melebihi ekspektasi. Komunikasi lancar, timeline tepat waktu, dan hasilnya memang kualitas premium. Highly recommended untuk teman-teman yang mau prewedding atau wedding!', 'PRJ002'),

('CF002', sample_user_id, 'PT Sejahtera Abadi', 4,
'Dokumentasi acara annual gathering sangat memuaskan. Tim responsif dan hasil foto/video berkualitas tinggi. Hanya sedikit delay di timeline delivery karena revisi tambahan, tapi overall sangat puas dengan hasilnya. Akan recommend ke cabang lain.', NULL),

('CF003', sample_user_id, 'Ahmad & Sari', 5,
'Terima kasih Vena Pictures untuk prewedding yang luar biasa! Dari konsultasi awal sampai hasil akhir, semuanya perfect. Tim yang ramah dan sabar mengarahkan pose. Pasti akan booking lagi untuk wedding nanti!', NULL),

('CF004', sample_user_id, 'Jessica & Rio', 4,
'Overall satisfied dengan hasil wedding photography. Kualitas foto bagus dan moment-moment penting ter-capture dengan baik. Ada sedikit miscommunication di timeline saat resepsi, tapi tim cepat handle. Recommended!', NULL),

('CF005', sample_user_id, 'Budi & Sinta', 5,
'Exceptional service dari awal sampai akhir! Tim sangat professional, equipment lengkap, dan hasil editing memukau. Album dan video highlight nya juga bagus banget. Worth every penny!', 'PRJ001')
ON CONFLICT (id) DO NOTHING;

END $$;