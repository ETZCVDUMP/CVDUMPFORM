# Deployment Instructions for Recruitment System

## Option 1: Deploy to Netlify (Recommended)

### 1. Backend Setup (Supabase)

1. **Create a Supabase project:**
   - Go to [https://supabase.com](https://supabase.com)
   - Create a new project
   - Wait for the project to be ready

2. **Set up the database:**
   - Go to your project dashboard
   - Navigate to SQL Editor
   - Run the migration file content from `supabase/migrations/001_create_applications_table.sql`

3. **Set up storage:**
   - Go to Storage in the Supabase dashboard
   - Click "New bucket"
   - Name it exactly `cvs` (lowercase)
   - **IMPORTANT:** Check "Public bucket" option
   - Click "Create bucket"
   - The bucket policies will be automatically configured for public access

4. **Deploy email function (optional):**
   - Sign up for Resend.com for email notifications
   - Set the `RESEND_API_KEY` environment variable in your Supabase project
   - Deploy the edge function using the Supabase CLI (if you have it)

5. **Get your keys:**
   - Project URL and Anon key from Settings > API

### 2. Frontend Setup

1. **Clone and configure:**
   ```bash
   git clone <your-repo>
   cd recruitment-system
   npm install
   ```

2. **Environment variables:**
   - Copy `.env.example` to `.env`
   - Fill in your Supabase URL and key
   - Set notification email address

3. **Build and deploy to Netlify:**
   ```bash
   npm run build
   ```
   - Drag the `dist` folder to Netlify's deploy area
   - Or connect your GitHub repo to Netlify for automatic deployments

## Option 2: Deploy to GitHub Pages

### 1. Backend Setup
   - Follow the same Supabase setup as above

### 2. GitHub Pages Deployment

1. **Configure build for GitHub Pages:**
   - Update `vite.config.ts`:
   ```typescript
   export default defineConfig({
     plugins: [react()],
     base: '/your-repo-name/', // Add this line
     optimizeDeps: {
       exclude: ['lucide-react'],
     },
   });
   ```

2. **Set up environment variables:**
   - Since GitHub Pages doesn't support server-side environment variables, you'll need to:
   - Either hardcode the values in production (not recommended for sensitive data)
   - Or use GitHub Secrets and a build process

3. **Deploy:**
   ```bash
   npm run build
   git add dist -f
   git commit -m "Deploy"
   git subtree push --prefix dist origin gh-pages
   ```

### 3. Environment Variables for GitHub Pages

Create `.env.production` with your values:
```
VITE_SUPABASE_URL=your_actual_supabase_url
VITE_SUPABASE_ANON_KEY=your_actual_anon_key
VITE_NOTIFICATION_EMAIL=hr@yourcompany.com
```

## Security Considerations

1. **Row Level Security:** Already configured in the migration
2. **File upload:** Limited to PDFs, 5MB max
3. **Email notifications:** Optional but recommended
4. **Admin access:** Consider adding authentication for the admin dashboard in production

## Customization

1. **Email recipient:** Change `VITE_NOTIFICATION_EMAIL`
2. **Styling:** Modify the Tailwind classes
3. **Form fields:** Add/remove fields in the form component
4. **File types:** Modify validation for different file types

## Troubleshooting

1. **CORS issues:** Ensure Supabase is configured for your domain
2. **File uploads failing:** Check storage bucket permissions
3. **Email not working:** Verify Resend API key and edge function deployment

The system is now ready for production use with secure file uploads, email notifications, and a responsive admin dashboard.