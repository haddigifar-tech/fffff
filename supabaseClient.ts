import { createClient } from '@supabase/supabase-js';

// Use hardcoded values for production deployment since env vars aren't loading
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://jpcqynxrttszzpunyhii.supabase.co';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwY3F5bnhydHRzenpwdW55aGlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3ODg2NDMsImV4cCI6MjA3MjM2NDY0M30.B1NMP9aXLdER8qcyiHGfC1pGe2MIq3YDptstGE9aI0Q';

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);