import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.deepPurple;
  static const secondary = Colors.teal;
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const error = Colors.red;
  static const success = Colors.green;
  static const warning = Colors.orange;
  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.black54;
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class AppConfig {
  static const appName = 'Habit Forge';
  static const appVersion = '1.0.0';
  static const supportEmail = 'support@habitforge.com';
  
  // Shared Preferences Keys
  static const keyAuthToken = 'auth_token';
  static const keyUserId = 'user_id';
  static const keyUserEmail = 'user_email';
  static const keyHabits = 'habits';
  static const keyTasks = 'tasks';
  static const keySettings = 'settings';
  
  // API Endpoints (if you plan to add backend)
  static const baseUrl = 'https://api.habitforge.com';
  static const loginEndpoint = '/auth/login';
  static const registerEndpoint = '/auth/register';
  static const resetPasswordEndpoint = '/auth/reset-password';
  
  // Feature Flags
  static const enableNotifications = true;
  static const enableAnalytics = true;
  static const enableSocialFeatures = false;
  static const enableCloudSync = false;
  
  // Limits
  static const maxHabits = 10;
  static const maxTasksPerHabit = 20;
  static const maxTags = 5;
  static const maxTagLength = 15;
  static const maxTitleLength = 50;
  static const maxDescriptionLength = 200;
}

class AppText {
  // Auth Screens
  static const loginTitle = 'Welcome Back';
  static const loginSubtitle = 'Sign in to continue building better habits';
  static const registerTitle = 'Create Account';
  static const registerSubtitle = 'Start your journey to better habits';
  
  // Error Messages
  static const errorGeneric = 'Something went wrong. Please try again.';
  static const errorNoInternet = 'No internet connection.';
  static const errorInvalidCredentials = 'Invalid email or password.';
  static const errorWeakPassword = 'Password is too weak.';
  static const errorEmailInUse = 'Email is already in use.';
  
  // Success Messages
  static const successHabitCreated = 'Habit created successfully!';
  static const successTaskCompleted = 'Task completed! Keep it up!';
  static const successProfileUpdated = 'Profile updated successfully!';
  
  // Feature Descriptions
  static const habitDescription = 'Track and build lasting habits';
  static const taskDescription = 'Break down habits into manageable tasks';
  static const rewardsDescription = 'Earn points and unlock achievements';
  static const analyticsDescription = 'Monitor your progress over time';
}
