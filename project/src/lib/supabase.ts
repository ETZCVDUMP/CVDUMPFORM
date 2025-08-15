import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseKey);

export type Application = {
  id: string;
  first_name: string;
  last_name: string;
  email: string;
  linkedin?: string;
  phone: string;
  cv_url: string;
  cv_filename: string;
  created_at: string;
};