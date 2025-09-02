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

    console.log(`[${requestId}] Fixing auth users...`);

    // Delete existing problematic users and recreate them
    const users = [
      { email: 'admin@venapictures.com', password: 'admin123', profile_id: 'b27182c1-5487-4d8c-8cdf-526825d50426' },
      { email: 'sarah@venapictures.com', password: 'sarah123', profile_id: 'e9fc3146-f031-4948-bec8-975da2d5cdc0' },
      { email: 'rio@venapictures.com', password: 'rio123', profile_id: 'cd7fbea8-a4a3-4699-a171-b6895e5cacbb' },
      { email: 'maya.freelancer@email.com', password: 'maya123', profile_id: '0ebe766f-c799-4d56-8090-c3a876b18d5d' }
    ];

    const results = [];

    for (const user of users) {
      try {
        // Delete existing user if exists
        const { error: deleteError } = await supabase.auth.admin.deleteUser(user.profile_id);
        if (deleteError && !deleteError.message.includes('User not found')) {
          console.log(`[${requestId}] Delete error for ${user.email}:`, deleteError.message);
        }

        // Create new user with specific ID
        const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
          user_id: user.profile_id,
          email: user.email,
          password: user.password,
          email_confirm: true,
          user_metadata: {
            full_name: user.email.includes('admin') ? 'Andi Vena' : 
                      user.email.includes('sarah') ? 'Sarah Wijaya' :
                      user.email.includes('rio') ? 'Rio Pratama' : 'Maya Sari'
          }
        });

        if (createError) {
          console.error(`[${requestId}] Error creating user ${user.email}:`, createError);
          results.push({
            email: user.email,
            status: 'error',
            message: createError.message
          });
        } else {
          console.log(`[${requestId}] Created auth user: ${user.email}`);
          results.push({
            email: user.email,
            password: user.password,
            status: 'created'
          });
        }
      } catch (error) {
        console.error(`[${requestId}] Error processing ${user.email}:`, error);
        results.push({
          email: user.email,
          status: 'error',
          message: error.message
        });
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Auth users fixed',
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