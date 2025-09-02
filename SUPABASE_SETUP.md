
# Supabase Migration Setup Guide

## Prerequisites
1. Create a Supabase account at [supabase.com](https://supabase.com)
2. Create a new project in Supabase

## Step 1: Database Setup

1. Go to your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy and paste the contents of `database/schema.sql`
4. Run the SQL to create all tables, types, and policies

## Step 2: Environment Variables

1. Copy `.env.example` to `.env`
2. Get your project URL and anon key from Supabase dashboard:
   - Go to Settings > API
   - Copy the Project URL and anon public key
3. Update your `.env` file:
   ```
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your_anon_key_here
   ```

## Step 3: Authentication Setup

1. Go to Authentication > Settings in your Supabase dashboard
2. Configure email settings if needed
3. Set up your authentication providers

## Step 4: Initial Data Setup

1. Register a new account in your application
2. Get your user ID by running this SQL in Supabase SQL Editor:
   ```sql
   SELECT id FROM auth.users;
   ```
3. Copy your user ID
4. Open `database/seed.sql`
5. Replace all instances of `'your-user-id-here'` with your actual user ID
6. Run the seed SQL in Supabase SQL Editor

## Step 5: Row Level Security (RLS)

The schema already includes RLS policies, but make sure they're enabled:

1. Go to Authentication > Policies in Supabase dashboard
2. Verify that all tables have the correct policies
3. All policies should ensure users can only access their own data

## Step 6: Testing

1. Start your application: `npm run dev`
2. Login with your registered account
3. Verify that data loads correctly
4. Test creating, updating, and deleting records

## Migration Checklist

- [ ] Supabase project created
- [ ] Database schema deployed
- [ ] Environment variables configured
- [ ] User account registered
- [ ] Seed data inserted with correct user ID
- [ ] RLS policies verified
- [ ] Application tested with Supabase integration

## Key Changes Made

1. **Removed localStorage**: All data now stored in Supabase
2. **Added authentication**: Real user authentication with Supabase Auth
3. **Database operations**: All CRUD operations now use Supabase client
4. **Real-time data**: Data is fetched fresh from database on each login
5. **User isolation**: Each user only sees their own data (RLS)

## Important Notes

- All data is now persistent across devices and browsers
- Users must register and login to access the application
- Data is automatically synced with the database
- Row Level Security ensures data privacy between users
- The application will work offline with cached data, but changes require internet connection

## Troubleshooting

1. **Connection issues**: Check your environment variables
2. **Auth issues**: Verify email confirmation if required
3. **Permission errors**: Check RLS policies in Supabase
4. **Data not loading**: Verify user ID in seed data matches your auth user ID
