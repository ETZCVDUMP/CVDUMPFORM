/*
  # Allow anonymous uploads to CVs storage bucket

  1. Storage Policies
    - Add policy to allow anonymous users to upload files to 'cvs' bucket
    - Add policy to allow public read access to uploaded files

  This fixes the "new row violates row-level security policy" error
  by explicitly granting INSERT permissions for anonymous users.
*/

-- Allow anonymous users to upload files to the cvs bucket
CREATE POLICY "Allow anonymous uploads to cvs bucket"
ON storage.objects FOR INSERT TO anon
WITH CHECK (bucket_id = 'cvs');

-- Allow public read access to files in the cvs bucket
CREATE POLICY "Allow public read access to cvs bucket"
ON storage.objects FOR SELECT TO anon, authenticated
USING (bucket_id = 'cvs');