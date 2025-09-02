
import React, { useState } from 'react';
import { useSupabaseData } from './hooks/useSupabaseData';

// Components
import Sidebar from './components/Sidebar';
import Header from './components/Header';
import Dashboard from './components/Dashboard';
import Clients from './components/Clients';
import { Projects } from './components/Projects';
import Finance from './components/Finance';
import Team from './components/Team';
import Packages from './components/Packages';
import { Leads } from './components/Leads';
import Booking from './components/Booking';
import { Assets } from './components/Assets';
import SOP from './components/SOP';
import Settings from './components/Settings';
import Contracts from './components/Contracts';
import Freelancers from './components/Freelancers';
import FreelancerProjects from './components/FreelancerProjects';
import FreelancerPortal from './components/FreelancerPortal';
import ClientPortal from './components/ClientPortal';
import PublicBookingForm from './components/PublicBookingForm';
import PublicLeadForm from './components/PublicLeadForm';
import PublicFeedbackForm from './components/PublicFeedbackForm';
import PublicRevisionForm from './components/PublicRevisionForm';
import PublicPackages from './components/PublicPackages';
import PublicSignatureVerifier from './components/PublicSignatureVerifier';
import Login from './components/Login';
import Homepage from './components/Homepage';
import { SocialPlanner } from './components/SocialPlanner';
import { CalendarView } from './components/CalendarView';
import ClientKPI from './components/ClientKPI';
import PromoCodes from './components/PromoCodes';
import GlobalSearch from './components/GlobalSearch';

const App: React.FC = () => {
  const {
    data,
    currentUser,
    loading,
    notifications,
    showNotification,
    createRecord,
    updateRecord,
    deleteRecord,
    signIn,
    signUp,
    signOut
  } = useSupabaseData();

  const [currentView, setCurrentView] = useState('dashboard');
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const [globalSearchOpen, setGlobalSearchOpen] = useState(false);

  // Handle loading state
  if (loading) {
    return (
      <div className="min-h-screen bg-brand-bg flex items-center justify-center">
        <div className="text-brand-text-primary text-xl">Loading...</div>
      </div>
    );
  }

  // Handle authentication
  if (!currentUser) {
    return <Login onSignIn={signIn} onSignUp={signUp} />;
  }

  // Public routes (when accessing via portal links)
  const urlParams = new URLSearchParams(window.location.search);
  const portalId = urlParams.get('portal');
  const formType = urlParams.get('form');
  
  if (portalId) {
    if (formType === 'booking') {
      return <PublicBookingForm portalId={portalId} />;
    }
    if (formType === 'feedback') {
      return <PublicFeedbackForm portalId={portalId} />;
    }
    if (formType === 'revision') {
      return <PublicRevisionForm portalId={portalId} />;
    }
    if (formType === 'packages') {
      return <PublicPackages portalId={portalId} />;
    }
    if (formType === 'signature') {
      return <PublicSignatureVerifier portalId={portalId} />;
    }
    if (formType === 'lead') {
      return <PublicLeadForm portalId={portalId} />;
    }
    
    // Check if it's a freelancer portal
    const freelancer = data.teamMembers.find(f => f.portalAccessId === portalId);
    if (freelancer) {
      return <FreelancerPortal freelancerId={freelancer.id} />;
    }
    
    // Check if it's a client portal
    const client = data.clients.find(c => c.portalAccessId === portalId);
    if (client) {
      return <ClientPortal clientId={client.id} />;
    }
  }

  const renderCurrentView = () => {
    switch (currentView) {
      case 'homepage':
        return <Homepage />;
      case 'dashboard':
        return (
          <Dashboard
            projects={data.projects}
            clients={data.clients}
            transactions={data.transactions}
            teamMembers={data.teamMembers}
            leads={data.leads}
          />
        );
      case 'clients':
        return (
          <Clients
            clients={data.clients}
            projects={data.projects}
            packages={data.packages}
            addOns={data.addOns}
            transactions={data.transactions}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'projects':
        return (
          <Projects
            projects={data.projects}
            clients={data.clients}
            packages={data.packages}
            addOns={data.addOns}
            teamMembers={data.teamMembers}
            promoCodes={data.promoCodes}
            transactions={data.transactions}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'finance':
        return (
          <Finance
            transactions={data.transactions}
            cards={data.cards}
            financialPockets={data.financialPockets}
            projects={data.projects}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'team':
        return (
          <Team
            teamMembers={data.teamMembers}
            projects={data.projects}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'packages':
        return (
          <Packages
            packages={data.packages}
            addOns={data.addOns}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'leads':
        return (
          <Leads
            leads={data.leads}
            clients={data.clients}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'booking':
        return (
          <Booking
            projects={data.projects}
            packages={data.packages}
            updateRecord={updateRecord}
            showNotification={showNotification}
          />
        );
      case 'assets':
        return (
          <Assets
            assets={data.assets}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'sop':
        return (
          <SOP
            sops={data.sops}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'contracts':
        return (
          <Contracts
            contracts={data.contracts}
            projects={data.projects}
            clients={data.clients}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'social':
        return (
          <SocialPlanner
            socialPosts={data.socialPosts}
            projects={data.projects}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'calendar':
        return <CalendarView projects={data.projects} setProjects={updateRecord} teamMembers={data.teamMembers} profile={data.profile} />;
      case 'client-kpi':
        return (
          <ClientKPI
            clients={data.clients}
            leads={data.leads}
            projects={data.projects}
            clientFeedback={data.clientFeedback}
            createRecord={createRecord}
            showNotification={showNotification}
          />
        );
      case 'promo-codes':
        return (
          <PromoCodes
            promoCodes={data.promoCodes}
            createRecord={createRecord}
            updateRecord={updateRecord}
            deleteRecord={deleteRecord}
            showNotification={showNotification}
          />
        );
      case 'settings':
        return (
          <Settings
            profile={data.profile}
            updateRecord={updateRecord}
            showNotification={showNotification}
            onSignOut={signOut}
          />
        );
      default:
        return <Dashboard projects={data.projects} clients={data.clients} transactions={data.transactions} teamMembers={data.teamMembers} leads={data.leads} />;
    }
  };

  return (
    <div className={`min-h-screen ${darkMode ? 'dark' : ''} bg-brand-bg text-brand-text-primary`}>
      {/* Notifications */}
      <div className="fixed top-4 right-4 z-50 space-y-2">
        {notifications.map((notification) => (
          <div
            key={notification.id}
            className={`p-4 rounded-lg shadow-lg ${
              notification.type === 'error' 
                ? 'bg-red-500 text-white' 
                : notification.type === 'info'
                ? 'bg-blue-500 text-white'
                : 'bg-green-500 text-white'
            }`}
          >
            {notification.message}
          </div>
        ))}
      </div>

      <div className="flex">
        <Sidebar
          currentView={currentView}
          setCurrentView={setCurrentView}
          collapsed={sidebarCollapsed}
          onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
        />
        
        <div className={`flex-1 transition-all duration-300 ${sidebarCollapsed ? 'ml-16' : 'ml-64'}`}>
          <Header
            currentUser={currentUser}
            onSignOut={signOut}
            darkMode={darkMode}
            setDarkMode={setDarkMode}
            onOpenGlobalSearch={() => setGlobalSearchOpen(true)}
          />
          
          <main className="p-6">
            {renderCurrentView()}
          </main>
        </div>
      </div>

      {globalSearchOpen && (
        <GlobalSearch
          isOpen={globalSearchOpen}
          onClose={() => setGlobalSearchOpen(false)}
          data={data}
          onNavigate={setCurrentView}
        />
      )}
    </div>
  );
};

export default App;
