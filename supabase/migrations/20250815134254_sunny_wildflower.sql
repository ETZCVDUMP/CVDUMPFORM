/*
  # Create CVs Storage Bucket

  1. Storage Setup
    - Create 'cvs' storage bucket for CV file uploads
    - Configure bucket to be publicly accessible for file uploads
    - Set appropriate file size limits

  2. Security
    - Enable RLS on storage objects
    - Add policy to allow authenticated and anonymous users to upload files
    - Add policy to allow public read access to uploaded files

  3. Configuration
    - Set maximum file size to 5MB
    - Allow PDF file types only
*/

-- Create the CVs storage bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'cvs',
  'cvs',
  true,
  5242880, -- 5MB in bytes
  ARRAY['application/pdf']
)
ON CONFLICT (id) DO NOTHING;

-- Enable RLS on storage objects
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Policy to allow anyone to upload CVs
CREATE POLICY "Anyone can upload CVs"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'cvs');

-- Policy to allow public read access to CVs
CREATE POLICY "Public read access for CVs"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'cvs');