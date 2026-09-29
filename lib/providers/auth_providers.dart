import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/auth_service.dart';

// Auth Service Provider
final authServiceProvider = Provider((ref) => AuthService());

// Auth State Stream Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current User ID Provider
final currentUserIdProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUserId;
});

// Current User Email Provider
final currentUserEmailProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUserEmail;
});

// Sign Up Notifier
class SignUpNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService authService;

  SignUpNotifier(this.authService) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authService.signUp(
      email: email,
      password: password,
      name: name,
      role: role,
    ));
  }
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue<void>>(
  (ref) => SignUpNotifier(ref.watch(authServiceProvider)),
);

// Sign In Notifier
class SignInNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService authService;

  SignInNotifier(this.authService) : super(const AsyncValue.data(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authService.signIn(
      email: email,
      password: password,
    ));
  }
}

final signInProvider = StateNotifierProvider<SignInNotifier, AsyncValue<void>>(
  (ref) => SignInNotifier(ref.watch(authServiceProvider)),
);

// Sign Out Notifier
class SignOutNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService authService;

  SignOutNotifier(this.authService) : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authService.signOut());
  }
}

final signOutProvider = StateNotifierProvider<SignOutNotifier, AsyncValue<void>>(
  (ref) => SignOutNotifier(ref.watch(authServiceProvider)),
);
