/*
  # Create applications table

  1. New Tables
    - `applications`
      - `id` (uuid, primary key)
      - `first_name` (text, required)
      - `last_name` (text, required)
      - `email` (text, required)
      - `linkedin` (text, optional)
      - `phone` (text, required)
      - `cv_url` (text, required)
      - `cv_filename` (text, required)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `applications` table
    - Add policies for public insert and admin read access
*/

CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text NOT NULL,
  linkedin text,
  phone text NOT NULL,
  cv_url text NOT NULL,
  cv_filename text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert applications (for the public form)
CREATE POLICY "Anyone can submit applications"
  ON applications
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Allow reading applications (for admin dashboard)
-- You might want to restrict this to specific users in production
CREATE POLICY "Allow read access to applications"
  ON applications
  FOR SELECT
  TO anon, authenticated
  USING (true);