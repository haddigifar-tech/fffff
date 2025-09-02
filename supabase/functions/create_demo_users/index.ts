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

    console.log(`[${requestId}] Creating demo users...`);

    // Create admin demo user
    const { data: adminUser, error: adminError } = await supabase.auth.admin.createUser({
      email: 'admin@vena.pictures',
      password: 'admin',
      email_confirm: true,
      user_metadata: {
        full_name: 'Admin Vena'
      }
    });

    if (adminError && !adminError.message.includes('already registered')) {
      console.error(`[${requestId}] Admin user creation error:`, adminError);
    } else {
      console.log(`[${requestId}] Admin user created/exists:`, adminUser?.user?.email);
    }

    // Create member demo user
    const { data: memberUser, error: memberError } = await supabase.auth.admin.createUser({
      email: 'member@vena.pictures',
      password: 'member',
      email_confirm: true,
      user_metadata: {
        full_name: 'Member Vena'
      }
    });

    if (memberError && !memberError.message.includes('already registered')) {
      console.error(`[${requestId}] Member user creation error:`, memberError);
    } else {
      console.log(`[${requestId}] Member user created/exists:`, memberUser?.user?.email);
    }

    // Create profiles for the demo users if they don't exist
    if (adminUser?.user) {
      const { error: profileError } = await supabase
        .from('profiles')
        .upsert({
          id: adminUser.user.id,
          full_name: 'Admin Vena',
          role: 'admin'
        }, { onConflict: 'id' });
      
      if (profileError) {
        console.error(`[${requestId}] Admin profile creation error:`, profileError);
      }
    }

    if (memberUser?.user) {
      const { error: profileError } = await supabase
        .from('profiles')
        .upsert({
          id: memberUser.user.id,
          full_name: 'Member Vena',
          role: 'member'
        }, { onConflict: 'id' });
      
      if (profileError) {
        console.error(`[${requestId}] Member profile creation error:`, profileError);
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Demo users created successfully',
        users: [
          { email: 'admin@vena.pictures', password: 'admin' },
          { email: 'member@vena.pictures', password: 'member' }
        ]
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