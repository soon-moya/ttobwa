import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/home/home_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('페이지 없음')),
            body: const Center(child: Text('페이지를 찾을 수 없습니다.')),
          ),
        );
    }
  }
}

extension MaterialPageRouteExt on Widget {
  MaterialPageRoute call([RouteSettings? settings]) {
    return MaterialPageRoute(
      builder: (_) => this,
      settings: settings,
    );
  }
}
