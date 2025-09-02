
-- Create ENUM types for status fields to ensure data integrity
CREATE TYPE user_role AS ENUM ('Admin', 'Member');
CREATE TYPE client_status AS ENUM ('Prospek', 'Aktif', 'Tidak Aktif', 'Hilang');
CREATE TYPE client_type AS ENUM ('Langsung', 'Vendor');
CREATE TYPE lead_status AS ENUM ('Sedang Diskusi', 'Menunggu Follow Up', 'Dikonversi', 'Ditolak');
CREATE TYPE contact_channel AS ENUM ('WhatsApp', 'Instagram', 'Website', 'Telepon', 'Referensi', 'Form Saran', 'Lainnya');
CREATE TYPE card_type AS ENUM ('Prabayar', 'Kredit', 'Debit', 'Tunai');
CREATE TYPE asset_status AS ENUM ('Tersedia', 'Digunakan', 'Perbaikan');
CREATE TYPE performance_note_type AS ENUM ('Pujian', 'Perhatian', 'Keterlambatan Deadline', 'Umum');
CREATE TYPE satisfaction_level AS ENUM ('Sangat Puas', 'Puas', 'Biasa Saja', 'Tidak Puas');
CREATE TYPE revision_status AS ENUM ('Menunggu Revisi', 'Sedang Dikerjakan', 'Revisi Selesai');
CREATE TYPE post_type AS ENUM ('Instagram Feed', 'Instagram Story', 'Instagram Reels', 'TikTok Video', 'Artikel Blog');
CREATE TYPE post_status AS ENUM ('Draf', 'Terjadwal', 'Diposting', 'Dibatalkan');
CREATE TYPE booking_status AS ENUM ('Baru', 'Terkonfirmasi', 'Ditolak');
CREATE TYPE payment_status AS ENUM ('Lunas', 'DP Terbayar', 'Belum Bayar');
CREATE TYPE transaction_type AS ENUM ('Pemasukan', 'Pengeluaran');
CREATE TYPE pocket_type AS ENUM ('Nabung & Bayar', 'Terkunci', 'Bersama', 'Anggaran Pengeluaran', 'Tabungan Hadiah Freelancer');
CREATE TYPE discount_type AS ENUM ('percentage', 'fixed');

-- Table for User Profiles (linked to Supabase Auth users)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    role user_role DEFAULT 'Member',
    permissions JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT TRUE,
    company_name TEXT,
    website TEXT,
    address TEXT,
    bank_account TEXT,
    authorized_signer TEXT,
    id_number TEXT,
    bio TEXT,
    income_categories TEXT[],
    expense_categories TEXT[],
    project_types TEXT[],
    event_types TEXT[],
    asset_categories TEXT[],
    sop_categories TEXT[],
    package_categories TEXT[],
    project_status_config JSONB,
    notification_settings JSONB,
    security_settings JSONB,
    briefing_template TEXT,
    terms_and_conditions TEXT,
    contract_template TEXT,
    logo_base64 TEXT,
    brand_color TEXT,
    public_page_config JSONB,
    package_share_template TEXT,
    booking_form_template TEXT,
    chat_templates JSONB,
    last_login TIMESTAMPTZ,
    created_by UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can only see their own profile." ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can insert their own profile." ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update their own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

-- Table for Clients
CREATE TABLE clients (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    whatsapp TEXT,
    since TIMESTAMPTZ DEFAULT NOW(),
    instagram TEXT,
    status client_status DEFAULT 'Prospek',
    client_type client_type DEFAULT 'Langsung',
    last_contact TIMESTAMPTZ,
    portal_access_id TEXT UNIQUE,
    total_proyek_value NUMERIC DEFAULT 0,
    balance_due NUMERIC DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own clients." ON clients FOR ALL USING (auth.uid() = user_id);

-- Table for Leads
CREATE TABLE leads (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT,
    contact_channel contact_channel DEFAULT 'WhatsApp',
    location TEXT,
    status lead_status DEFAULT 'Sedang Diskusi',
    date TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT,
    whatsapp TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own leads." ON leads FOR ALL USING (auth.uid() = user_id);

-- Table for Packages
CREATE TABLE packages (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    price NUMERIC DEFAULT 0,
    category TEXT,
    physical_items JSONB DEFAULT '[]',
    digital_items TEXT[] DEFAULT '{}',
    processing_time TEXT,
    default_printing_cost NUMERIC DEFAULT 0,
    default_transport_cost NUMERIC DEFAULT 0,
    photographers TEXT DEFAULT '',
    videographers TEXT DEFAULT '',
    cover_image TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE packages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own packages." ON packages FOR ALL USING (auth.uid() = user_id);

-- Table for AddOns
CREATE TABLE add_ons (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    price NUMERIC DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own add_ons." ON add_ons FOR ALL USING (auth.uid() = user_id);

-- Table for Team Members (Freelancers)
CREATE TABLE team_members (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    role TEXT,
    email TEXT,
    phone TEXT,
    standard_fee NUMERIC DEFAULT 0,
    no_rek TEXT,
    reward_balance NUMERIC DEFAULT 0,
    rating REAL DEFAULT 0,
    performance_notes JSONB DEFAULT '[]',
    portal_access_id TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own team_members." ON team_members FOR ALL USING (auth.uid() = user_id);

-- Table for Projects
CREATE TABLE projects (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    project_name TEXT NOT NULL,
    client_name TEXT,
    client_id TEXT REFERENCES clients(id) ON DELETE SET NULL,
    project_type TEXT,
    package_name TEXT,
    package_id TEXT REFERENCES packages(id) ON DELETE SET NULL,
    add_ons JSONB DEFAULT '[]',
    date TIMESTAMPTZ DEFAULT NOW(),
    deadline_date TIMESTAMPTZ,
    location TEXT,
    progress INT DEFAULT 0,
    status TEXT DEFAULT 'Baru',
    active_sub_statuses TEXT[] DEFAULT '{}',
    total_cost NUMERIC DEFAULT 0,
    amount_paid NUMERIC DEFAULT 0,
    payment_status payment_status DEFAULT 'Belum Bayar',
    team JSONB DEFAULT '[]',
    notes TEXT,
    accommodation TEXT,
    drive_link TEXT,
    client_drive_link TEXT,
    final_drive_link TEXT,
    start_time TEXT,
    end_time TEXT,
    image TEXT,
    revisions JSONB DEFAULT '[]',
    promo_code_id TEXT,
    discount_amount NUMERIC DEFAULT 0,
    shipping_details TEXT,
    dp_proof_url TEXT,
    printing_details JSONB DEFAULT '{}',
    printing_cost NUMERIC DEFAULT 0,
    transport_cost NUMERIC DEFAULT 0,
    is_editing_confirmed_by_client BOOLEAN DEFAULT FALSE,
    is_printing_confirmed_by_client BOOLEAN DEFAULT FALSE,
    is_delivery_confirmed_by_client BOOLEAN DEFAULT FALSE,
    confirmed_sub_statuses TEXT[] DEFAULT '{}',
    client_sub_status_notes JSONB DEFAULT '{}',
    sub_status_confirmation_sent_at JSONB DEFAULT '{}',
    completed_digital_items TEXT[] DEFAULT '{}',
    invoice_signature TEXT,
    custom_sub_statuses JSONB DEFAULT '{}',
    booking_status booking_status DEFAULT 'Baru',
    rejection_reason TEXT,
    chat_history JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own projects." ON projects FOR ALL USING (auth.uid() = user_id);

-- Table for Transactions
CREATE TABLE transactions (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    date TIMESTAMPTZ DEFAULT NOW(),
    description TEXT NOT NULL,
    amount NUMERIC DEFAULT 0,
    type transaction_type DEFAULT 'Pemasukan',
    project_id TEXT REFERENCES projects(id) ON DELETE SET NULL,
    category TEXT,
    method TEXT,
    pocket_id TEXT,
    card_id TEXT,
    printing_item_id TEXT,
    vendor_signature TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own transactions." ON transactions FOR ALL USING (auth.uid() = user_id);

-- Table for Cards
CREATE TABLE cards (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    card_holder_name TEXT NOT NULL,
    bank_name TEXT,
    card_type card_type DEFAULT 'Debit',
    last_four_digits TEXT,
    expiry_date TEXT,
    balance NUMERIC DEFAULT 0,
    color_gradient TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE cards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own cards." ON cards FOR ALL USING (auth.uid() = user_id);

-- Table for Financial Pockets
CREATE TABLE financial_pockets (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    icon TEXT,
    type pocket_type DEFAULT 'Nabung & Bayar',
    amount NUMERIC DEFAULT 0,
    goal_amount NUMERIC DEFAULT 0,
    lock_end_date TIMESTAMPTZ,
    members JSONB DEFAULT '[]',
    source_card_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE financial_pockets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own financial_pockets." ON financial_pockets FOR ALL USING (auth.uid() = user_id);

-- Table for Promo Codes
CREATE TABLE promo_codes (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    discount_type discount_type DEFAULT 'percentage',
    discount_value NUMERIC DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    usage_count INT DEFAULT 0,
    max_usage INT DEFAULT 1,
    expiry_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE promo_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own promo_codes." ON promo_codes FOR ALL USING (auth.uid() = user_id);

-- Table for Assets
CREATE TABLE assets (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    category TEXT,
    status asset_status DEFAULT 'Tersedia',
    last_maintenance TIMESTAMPTZ,
    purchase_date TIMESTAMPTZ,
    purchase_price NUMERIC DEFAULT 0,
    current_value NUMERIC DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own assets." ON assets FOR ALL USING (auth.uid() = user_id);

-- Table for SOPs
CREATE TABLE sops (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    category TEXT,
    content TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE sops ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own sops." ON sops FOR ALL USING (auth.uid() = user_id);

-- Table for Contracts
CREATE TABLE contracts (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    project_id TEXT REFERENCES projects(id) ON DELETE CASCADE,
    client_name TEXT NOT NULL,
    template_content TEXT NOT NULL,
    signed_content TEXT,
    client_signature TEXT,
    vendor_signature TEXT,
    is_signed BOOLEAN DEFAULT FALSE,
    signed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own contracts." ON contracts FOR ALL USING (auth.uid() = user_id);

-- Table for Social Media Posts
CREATE TABLE social_posts (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    type post_type DEFAULT 'Instagram Feed',
    status post_status DEFAULT 'Draf',
    scheduled_date TIMESTAMPTZ,
    posted_date TIMESTAMPTZ,
    image_urls TEXT[] DEFAULT '{}',
    hashtags TEXT[] DEFAULT '{}',
    project_id TEXT REFERENCES projects(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE social_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own social_posts." ON social_posts FOR ALL USING (auth.uid() = user_id);

-- Table for Client Feedback
CREATE TABLE client_feedback (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    client_name TEXT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    feedback TEXT,
    project_id TEXT REFERENCES projects(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE client_feedback ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own client_feedback." ON client_feedback FOR ALL USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_clients_user_id ON clients(user_id);
CREATE INDEX idx_projects_user_id ON projects(user_id);
CREATE INDEX idx_projects_client_id ON projects(client_id);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_project_id ON transactions(project_id);
CREATE INDEX idx_leads_user_id ON leads(user_id);
CREATE INDEX idx_packages_user_id ON packages(user_id);
CREATE INDEX idx_team_members_user_id ON team_members(user_id);

-- Create function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON leads FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_packages_updated_at BEFORE UPDATE ON packages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_add_ons_updated_at BEFORE UPDATE ON add_ons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_team_members_updated_at BEFORE UPDATE ON team_members FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cards_updated_at BEFORE UPDATE ON cards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_financial_pockets_updated_at BEFORE UPDATE ON financial_pockets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_promo_codes_updated_at BEFORE UPDATE ON promo_codes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_assets_updated_at BEFORE UPDATE ON assets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sops_updated_at BEFORE UPDATE ON sops FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contracts_updated_at BEFORE UPDATE ON contracts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_social_posts_updated_at BEFORE UPDATE ON social_posts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_client_feedback_updated_at BEFORE UPDATE ON client_feedback FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
