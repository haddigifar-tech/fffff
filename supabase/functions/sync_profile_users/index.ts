import { createClient } from 'npm:@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
};

Deno.serve(async (req) => {
  const requestId = crypto.randomUUID();
  console.log(`[${requestId}] Request: ${req.method} ${req.url}`);

  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    });

    console.log(`[${requestId}] Syncing profile users to auth...`);

    // Get all profiles that need auth users
    const { data: profiles, error: profilesError } = await supabase
      .from('profiles')
      .select('id, full_name, email, role');

    if (profilesError) {
      throw new Error(`Failed to fetch profiles: ${profilesError.message}`);
    }

    const results = [];

    for (const profile of profiles) {
      if (!profile.email) continue;

      // Check if auth user exists
      const { data: existingUser } = await supabase.auth.admin.getUserById(profile.id);
      
      if (!existingUser.user) {
        // Create auth user with a default password based on their name
        const defaultPassword = profile.full_name.toLowerCase().replace(/\s+/g, '');
        
        const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
          user_id: profile.id,
          email: profile.email,
          password: defaultPassword,
          email_confirm: true,
          user_metadata: {
            full_name: profile.full_name
          }
        });

        if (createError) {
          console.error(`[${requestId}] Error creating user ${profile.email}:`, createError);
          results.push({
            email: profile.email,
            status: 'error',
            message: createError.message
          });
        } else {
          console.log(`[${requestId}] Created auth user: ${profile.email}`);
          results.push({
            email: profile.email,
            password: defaultPassword,
            status: 'created',
            role: profile.role
          });
        }
      } else {
        results.push({
          email: profile.email,
          status: 'exists',
          role: profile.role
        });
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Profile users synced successfully',
        results: results
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    );

  } catch (error) {
    console.error(`[${requestId}] Error:`, error);
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error',
        message: error.message 
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    );
  }
});