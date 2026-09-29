class AppConfig {
  static const String appName = '또봐';
  static const String appVersion = '1.0.0';
  static const bool enableDemoMode = false;
  
  // Firebase Project ID
  static const String firebaseProjectId = 'i-tium-schedule';
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.ttobwa.com';
  
  // App Theme
  static const int primaryColor = 0xFF2563EB; // 파란색
  static const int primaryDarkColor = 0xFF1E40AF;
  static const int accentColor = 0xFF10B981; // 초록색
  
  // Min SDK & Target SDK
  static const int minSdkVersion = 21;
  static const int targetSdkVersion = 35;
}

// Role definitions
enum UserRole {
  centerAdmin('center_admin', '센터 관리자'),
  therapist('therapist', '선생님'),
  parent('parent', '보호자');

  const UserRole(this.id, this.label);
  
  final String id;
  final String label;
}
