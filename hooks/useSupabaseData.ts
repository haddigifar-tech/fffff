
import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';
import { User } from '@supabase/supabase-js';

export interface AppData {
  clients: any[];
  projects: any[];
  transactions: any[];
  leads: any[];
  packages: any[];
  addOns: any[];
  teamMembers: any[];
  cards: any[];
  financialPockets: any[];
  promoCodes: any[];
  assets: any[];
  sops: any[];
  contracts: any[];
  socialPosts: any[];
  clientFeedback: any[];
  profile: any;
}

const initialData: AppData = {
  clients: [],
  projects: [],
  transactions: [],
  leads: [],
  packages: [],
  addOns: [],
  teamMembers: [],
  cards: [],
  financialPockets: [],
  promoCodes: [],
  assets: [],
  sops: [],
  contracts: [],
  socialPosts: [],
  clientFeedback: [],
  profile: null
};

export const useSupabaseData = () => {
  const [data, setData] = useState<AppData>(initialData);
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [notifications, setNotifications] = useState<Array<{id: string, message: string, type: 'success' | 'error' | 'info'}>>([]);

  const showNotification = (message: string, type: 'success' | 'error' | 'info' = 'success') => {
    const id = Date.now().toString();
    setNotifications(prev => [...prev, { id, message, type }]);
    setTimeout(() => {
      setNotifications(prev => prev.filter(n => n.id !== id));
    }, 5000);
  };

  const fetchAllData = async (userId: string) => {
    try {
      setLoading(true);
      
      const [
        profileRes,
        clientsRes,
        projectsRes,
        transactionsRes,
        leadsRes,
        packagesRes,
        addOnsRes,
        teamMembersRes,
        cardsRes,
        financialPocketsRes,
        promoCodesRes,
        assetsRes,
        sopsRes,
        contractsRes,
        socialPostsRes,
        clientFeedbackRes
      ] = await Promise.all([
        supabase.from('profiles').select('*').eq('id', userId).single(),
        supabase.from('clients').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('projects').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('transactions').select('*').eq('user_id', userId).order('date', { ascending: false }),
        supabase.from('leads').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('packages').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('add_ons').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('team_members').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('cards').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('financial_pockets').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('promo_codes').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('assets').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('sops').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('contracts').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('social_posts').select('*').eq('user_id', userId).order('created_at', { ascending: false }),
        supabase.from('client_feedback').select('*').eq('user_id', userId).order('created_at', { ascending: false })
      ]);

      setData({
        profile: profileRes.data,
        clients: clientsRes.data || [],
        projects: projectsRes.data || [],
        transactions: transactionsRes.data || [],
        leads: leadsRes.data || [],
        packages: packagesRes.data || [],
        addOns: addOnsRes.data || [],
        teamMembers: teamMembersRes.data || [],
        cards: cardsRes.data || [],
        financialPockets: financialPocketsRes.data || [],
        promoCodes: promoCodesRes.data || [],
        assets: assetsRes.data || [],
        sops: sopsRes.data || [],
        contracts: contractsRes.data || [],
        socialPosts: socialPostsRes.data || [],
        clientFeedback: clientFeedbackRes.data || []
      });
    } catch (error: any) {
      console.error('Error fetching data:', error);
      showNotification('Error loading data: ' + error.message, 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // Check initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setCurrentUser(session?.user || null);
      if (session?.user) {
        fetchAllData(session.user.id);
      } else {
        setLoading(false);
      }
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      setCurrentUser(session?.user || null);
      if (session?.user) {
        await fetchAllData(session.user.id);
      } else {
        setData(initialData);
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  // CRUD Operations
  const createRecord = async (table: string, record: any) => {
    try {
      if (!currentUser) throw new Error('User not authenticated');
      
      const recordWithUserId = { ...record, user_id: currentUser.id };
      const { data, error } = await supabase.from(table).insert([recordWithUserId]).select().single();
      
      if (error) throw error;
      
      // Refresh data
      await fetchAllData(currentUser.id);
      showNotification(`${table} created successfully`);
      return data;
    } catch (error: any) {
      showNotification(`Error creating ${table}: ${error.message}`, 'error');
      throw error;
    }
  };

  const updateRecord = async (table: string, id: string, updates: any) => {
    try {
      if (!currentUser) throw new Error('User not authenticated');
      
      const { data, error } = await supabase
        .from(table)
        .update(updates)
        .eq('id', id)
        .eq('user_id', currentUser.id)
        .select()
        .single();
      
      if (error) throw error;
      
      // Refresh data
      await fetchAllData(currentUser.id);
      showNotification(`${table} updated successfully`);
      return data;
    } catch (error: any) {
      showNotification(`Error updating ${table}: ${error.message}`, 'error');
      throw error;
    }
  };

  const deleteRecord = async (table: string, id: string) => {
    try {
      if (!currentUser) throw new Error('User not authenticated');
      
      const { error } = await supabase
        .from(table)
        .delete()
        .eq('id', id)
        .eq('user_id', currentUser.id);
      
      if (error) throw error;
      
      // Refresh data
      await fetchAllData(currentUser.id);
      showNotification(`${table} deleted successfully`);
    } catch (error: any) {
      showNotification(`Error deleting ${table}: ${error.message}`, 'error');
      throw error;
    }
  };

  const signIn = async (email: string, password: string) => {
    try {
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
      showNotification('Signed in successfully');
    } catch (error: any) {
      showNotification('Sign in error: ' + error.message, 'error');
      throw error;
    }
  };

  const signUp = async (email: string, password: string, fullName: string) => {
    try {
      const { data, error } = await supabase.auth.signUp({ 
        email, 
        password,
        options: {
          data: {
            full_name: fullName
          }
        }
      });
      if (error) throw error;
      
      // Create profile
      if (data.user) {
        await supabase.from('profiles').insert([{
          id: data.user.id,
          full_name: fullName,
          email: email
        }]);
      }
      
      showNotification('Account created successfully');
      return data;
    } catch (error: any) {
      showNotification('Sign up error: ' + error.message, 'error');
      throw error;
    }
  };

  const signOut = async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      showNotification('Signed out successfully');
    } catch (error: any) {
      showNotification('Sign out error: ' + error.message, 'error');
    }
  };

  return {
    data,
    currentUser,
    loading,
    notifications,
    showNotification,
    fetchAllData,
    createRecord,
    updateRecord,
    deleteRecord,
    signIn,
    signUp,
    signOut
  };
};
