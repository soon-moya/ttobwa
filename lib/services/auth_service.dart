import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../utils/exceptions.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 사용자 스트림
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      
      try {
        final userDoc = await _firestore
            .collection(usersCollection)
            .doc(firebaseUser.uid)
            .get();
        
        if (userDoc.exists) {
          return User.fromFirestore(userDoc);
        }
        return null;
      } catch (e) {
        throw FirestoreException('사용자 정보를 불러올 수 없습니다.');
      }
    });
  }

  // 현재 사용자 ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  // 현재 사용자 이메일
  String? get currentUserEmail => _firebaseAuth.currentUser?.email;

  /// 회원가입
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // 입력값 검증
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw ValidationException('모든 필드를 입력해주세요.');
      }

      if (password.length < minPasswordLength) {
        throw ValidationException('비밀번호는 최소 $minPasswordLength자 이상이어야 합니다.');
      }

      if (name.length > maxNameLength) {
        throw ValidationException('이름은 $maxNameLength자 이하여야 합니다.');
      }

      // Firebase Auth에 회원가입
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException('회원가입에 실패했습니다.');
      }

      // Firestore에 사용자 정보 저장
      final user = User(
        uid: firebaseUser.uid,
        email: email,
        name: name,
        role: role,
        centerId: role == 'parent' ? null : '',
        createdAt: DateTime.now(),
        isActive: true,
      );

      await _firestore
          .collection(usersCollection)
          .doc(firebaseUser.uid)
          .set(user.toFirestore());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      rethrow;
    }
  }

  /// 로그인
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ValidationException('이메일과 비밀번호를 입력해주세요.');
      }

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('로그아웃에 실패했습니다.');
    }
  }

  /// 비밀번호 변경
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException('로그인한 사용자가 없습니다.');
      }

      if (newPassword.length < minPasswordLength) {
        throw ValidationException('새 비밀번호는 최소 $minPasswordLength자 이상이어야 합니다.');
      }

      // 다시 인증
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // 비밀번호 변경
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      rethrow;
    }
  }

  /// 비밀번호 재설정 (이메일 발송)
  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        throw ValidationException('이메일을 입력해주세요.');
      }

      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleFirebaseAuthError(e));
    } catch (e) {
      rethrow;
    }
  }

  /// Firebase Auth 에러 메시지 처리
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일입니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'user-not-found':
        return '존재하지 않는 사용자입니다.';
      case 'wrong-password':
        return '비밀번호가 틀렸습니다.';
      case 'invalid-credential':
        return '잘못된 자격증명입니다.';
      case 'operation-not-allowed':
        return '이 작업은 허용되지 않습니다.';
      case 'too-many-requests':
        return '너무 많은 시도가 있었습니다. 나중에 다시 시도해주세요.';
      default:
        return '인증 오류: ${e.message}';
    }
  }
}
