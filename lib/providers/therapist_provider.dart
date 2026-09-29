import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/therapist_service.dart';
import '../utils/exceptions.dart';

class TherapistProvider with ChangeNotifier {
  final TherapistService _therapistService = TherapistService();

  List<User> _therapists = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<User> get therapists => _therapists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 센터의 선생님 목록 로드
  Future<void> loadTherapists(String centerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _therapists = await _therapistService.getTherapistsByCenter(centerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선생님 추가
  Future<void> inviteTherapist({
    required String centerId,
    required String email,
    required String name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _therapistService.inviteTherapist(
        centerId: centerId,
        email: email,
        name: name,
      );
      
      // 목록 재로드
      await loadTherapists(centerId);
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선생님 삭제
  Future<void> removeTherapist({
    required String therapistId,
    required String centerId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _therapistService.deleteTherapist(therapistId);
      
      // 목록 재로드
      await loadTherapists(centerId);
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirestoreException) {
      return error.message;
    }
    return '선생님 로드 중 오류가 발생했습니다.';
  }
}
