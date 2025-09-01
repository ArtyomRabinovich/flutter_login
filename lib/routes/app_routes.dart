import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/two_factor_screen/two_factor_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/ai_chat_screen/ai_chat_screen.dart';
import '../presentation/manual_editor_screen/manual_editor_screen.dart';
import '../presentation/global_library_screen/global_library_screen.dart';
import '../presentation/account_screen/account_screen.dart';
import '../presentation/pricing_screen/pricing_screen.dart';
import '../presentation/checkout_screen/checkout_screen.dart';
import '../presentation/invoices_screen/invoices_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/outputs_screen/outputs_screen.dart';
import '../presentation/help_screen/help_screen.dart';
import '../presentation/learn_more_screen/learn_more_screen.dart';

class AppRoutes {
  // Route constants
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String forgotPassword = '/forgot-password-screen';
  static const String login = '/login-screen';
  static const String welcome = '/welcome-screen';
  static const String signUp = '/signup-screen';
  static const String twoFactor = '/two-factor-screen';
  static const String home = '/home-screen';
  static const String aiChat = '/ai-chat-screen';
  static const String manualEditor = '/manual-editor-screen';
  static const String globalLibrary = '/global-library-screen';
  static const String account = '/account-screen';
  static const String pricing = '/pricing-screen';
  static const String checkout = '/checkout-screen';
  static const String invoices = '/invoices-screen';
  static const String notifications = '/notifications-screen';
  static const String settings = '/settings-screen';
  static const String outputs = '/outputs-screen';
  static const String help = '/help-screen';
  static const String learnMore = '/learn-more-screen';


  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const WelcomeScreen(), // Default to welcome for first-time view
    splash: (context) => const SplashScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    login: (context) => const LoginScreen(),
    welcome: (context) => const WelcomeScreen(),
    signUp: (context) => const SignUpScreen(),
    twoFactor: (context) => const TwoFactorScreen(),
    home: (context) => const HomeScreen(),
    aiChat: (context) => const AiChatScreen(),
    manualEditor: (context) => const ManualEditorScreen(),
    globalLibrary: (context) => const GlobalLibraryScreen(),
    account: (context) => const AccountScreen(),
    pricing: (context) => const PricingScreen(),
    checkout: (context) => const CheckoutScreen(),
    invoices: (context) => const InvoicesScreen(),
    notifications: (context) => const NotificationsScreen(),
    settings: (context) => const SettingsScreen(),
    outputs: (context) => const OutputsScreen(),
    help: (context) => const HelpScreen(),
    learnMore: (context) => const LearnMoreScreen(),
  };
}
