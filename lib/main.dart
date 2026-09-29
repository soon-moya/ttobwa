import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'config/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/therapist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const TtobwaApp());
}

class TtobwaApp extends StatelessWidget {
  const TtobwaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => TherapistProvider()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(AppConfig.primaryColor),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(AppConfig.primaryColor),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConfig.primaryColor),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
                vertical: AppTheme.spacing12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
            ),
          ),
        ),
        home: const _AuthWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// 인증 상태에 따라 화면을 결정하는 Wrapper
class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // 로딩 중
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 로그인 상태
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        }

        // 미로그인 상태 (로그인 화면)
        return const _AuthScreen();
      },
    );
  }
}

/// 인증 화면 (로그인/회원가입)
class _AuthScreen extends StatefulWidget {
  const _AuthScreen({Key? key}) : super(key: key);

  @override
  State<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<_AuthScreen> {
  @override
  void initState() {
    super.initState();
    // 라우터 이벤트 리스너 (선택사항)
  }

  @override
  Widget build(BuildContext context) {
    // 현재 경로 확인 (기본값: 로그인)
    final isSignUp = ModalRoute.of(context)?.settings.name == '/signup';

    return isSignUp ? const SignUpScreenWidget() : const LoginScreenWidget();
  }
}

import 'views/home/home_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';

class LoginScreenWidget extends StatelessWidget {
  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

class SignUpScreenWidget extends StatelessWidget {
  const SignUpScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignUpScreen();
  }
}
