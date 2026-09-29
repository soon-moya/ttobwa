/// 앱 전용 Exception 클래스들

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class FirestoreException implements Exception {
  final String message;
  final String? code;

  FirestoreException(this.message, {this.code});

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException(this.message, {this.errors});

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}

/// 에러 처리 헬퍼
class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is FirestoreException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is NetworkException) {
      return error.message;
    } else {
      return '알 수 없는 오류가 발생했습니다.';
    }
  }
}
