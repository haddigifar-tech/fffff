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

    console.log(`[${requestId}] Resetting passwords for all users...`);

    const users = [
      { email: 'admin@venapictures.com', password: 'andivena' },
      { email: 'sarah@venapictures.com', password: 'sarahwijaya' },
      { email: 'rio@venapictures.com', password: 'riopratama' },
      { email: 'maya.freelancer@email.com', password: 'mayasari' }
    ];

    const results = [];

    for (const user of users) {
      try {
        // Get user by email
        const { data: userData, error: getUserError } = await supabase.auth.admin.listUsers();
        
        if (getUserError) {
          throw new Error(`Failed to list users: ${getUserError.message}`);
        }

        const foundUser = userData.users.find(u => u.email === user.email);
        
        if (foundUser) {
          // Update password
          const { data: updateData, error: updateError } = await supabase.auth.admin.updateUserById(
            foundUser.id,
            { password: user.password }
          );

          if (updateError) {
            console.error(`[${requestId}] Error updating password for ${user.email}:`, updateError);
            results.push({
              email: user.email,
              status: 'error',
              message: updateError.message
            });
          } else {
            console.log(`[${requestId}] Password updated for: ${user.email}`);
            results.push({
              email: user.email,
              password: user.password,
              status: 'updated'
            });
          }
        } else {
          results.push({
            email: user.email,
            status: 'not_found',
            message: 'User not found'
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
        message: 'Password reset completed',
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