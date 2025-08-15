/*
  # Setup storage policies for CVs bucket

  1. Storage Policies
    - Allow anonymous users to upload files to the 'cvs' bucket
    - Allow public read access to uploaded files
  
  2. Security
    - Files are publicly readable once uploaded
    - Anonymous users can upload files (needed for job applications)
    - File size and type restrictions should be handled at bucket level
*/

-- Create policy to allow anonymous users to upload files
INSERT INTO storage.policies (id, bucket_id, name, definition, check_expression, command, roles)
VALUES (
  'allow_anon_upload_cvs',
  'cvs',
  'Allow anonymous uploads to cvs bucket',
  'true',
  'true',
  'INSERT',
  '{anon,authenticated}'
) ON CONFLICT (id) DO NOTHING;

-- Create policy to allow public read access
INSERT INTO storage.policies (id, bucket_id, name, definition, check_expression, command, roles)
VALUES (
  'allow_public_read_cvs',
  'cvs', 
  'Allow public read access to cvs bucket',
  'true',
  NULL,
  'SELECT',
  '{anon,authenticated}'
) ON CONFLICT (id) DO NOTHING;