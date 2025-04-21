import 'package:get/get.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/freelancer/freelancer_dashboard_screen.dart';
import 'screens/freelancer/find_jobs_screen.dart';
import 'screens/freelancer/my_proposals_screen.dart';
import 'screens/freelancer/freelancer_profile_screen.dart';
import 'screens/freelancer/earnings_screen.dart';
import 'screens/freelancer/industry_analysis_screen.dart';
import 'screens/client/client_dashboard_screen.dart';
import 'screens/client/post_job_screen.dart';
import 'screens/client/my_jobs_screen.dart';
import 'screens/client/client_profile_screen.dart';
import 'screens/client/payment_screen.dart';
import 'screens/common/messages_screen.dart';
import 'screens/common/chat_screen.dart';
import 'screens/common/edit_profile_screen.dart';

class Routes {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';
  
  // Freelancer Routes
  static const String freelancerDashboard = '/freelancer/dashboard';
  static const String findJobs = '/freelancer/find-jobs';
  static const String myProposals = '/freelancer/my-proposals';
  static const String freelancerProfile = '/freelancer/profile';
  static const String earnings = '/freelancer/earnings';
  static const String industryAnalysis = '/freelancer/industry-analysis';
  
  // Client Routes
  static const String clientDashboard = '/client/dashboard';
  static const String postJob = '/client/post-job';
  static const String myJobs = '/client/my-jobs';
  static const String clientProfile = '/client/profile';
  static const String payments = '/client/payments';
  
  // Common Routes
  static const String messages = '/messages';
  static const String chat = '/chat';
  static const String editProfile = '/edit-profile';
  
  // GetX Pages
  static final List<GetPage> pages = [
    // Auth Pages
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: roleSelection,
      page: () => RoleSelectionScreen(),
      transition: Transition.fadeIn,
    ),
    
    // Freelancer Pages
    GetPage(
      name: freelancerDashboard,
      page: () => FreelancerDashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: findJobs,
      page: () => FindJobsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: myProposals,
      page: () => MyProposalsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: freelancerProfile,
      page: () => FreelancerProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: earnings,
      page: () => EarningsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: industryAnalysis,
      page: () => IndustryAnalysisScreen(),
      transition: Transition.fadeIn,
    ),
    
    // Client Pages
    GetPage(
      name: clientDashboard,
      page: () => ClientDashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: postJob,
      page: () => PostJobScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: myJobs,
      page: () => MyJobsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: clientProfile,
      page: () => ClientProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: payments,
      page: () => PaymentScreen(),
      transition: Transition.fadeIn,
    ),
    
    // Common Pages
    GetPage(
      name: messages,
      page: () => MessagesScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chat,
      page: () => ChatScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
