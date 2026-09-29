import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/schedule_service.dart';
import '../utils/exceptions.dart';

class ScheduleProvider with ChangeNotifier {
  final ScheduleService _scheduleService = ScheduleService();

  // 상태
  List<Schedule> _schedules = [];
  List<Schedule> _filteredSchedules = [];
  Map<String, bool> _therapistFilter = {}; // 선생님별 필터
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  bool _isLoading = false;
  String? _error;

  // 선생님별 색상 (하드코딩 또는 Firestore에서 가져올 수 있음)
  final List<Color> _therapistColors = [
    const Color(0xFF2563EB),  // 파란색
    const Color(0xFFDC2626),  // 빨간색
    const Color(0xFF16A34A),  // 초록색
    const Color(0xFF7C3AED),  // 보라색
    const Color(0xFFF59E0B),  // 주황색
    const Color(0xFF0891B2),  // 청록색
    const Color(0xFFBE185D),  // 핫핑크
    const Color(0xFF7C2D12),  // 갈색
  ];

  Map<String, Color> _therapistColorMap = {};

  // Getters
  List<Schedule> get schedules => _schedules;
  List<Schedule> get filteredSchedules => _filteredSchedules;
  Map<String, bool> get therapistFilter => _therapistFilter;
  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, Color> get therapistColorMap => _therapistColorMap;

  /// 초기화: 센터 일정 로드
  Future<void> initializeSchedules({
    required String centerId,
    required List<String> therapistIds,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 선생님별 색상 매핑
      _initTherapistColors(therapistIds);

      // 필터 초기화 (모든 선생님 선택)
      _therapistFilter = {};
      for (var id in therapistIds) {
        _therapistFilter[id] = true;
      }

      // 이번 달 일정 로드
      _schedules = await _scheduleService.getSchedulesByMonth(
        centerId: centerId,
        month: _currentMonth,
      );

      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선생님별 색상 매핑
  void _initTherapistColors(List<String> therapistIds) {
    _therapistColorMap.clear();
    for (int i = 0; i < therapistIds.length; i++) {
      _therapistColorMap[therapistIds[i]] =
          _therapistColors[i % _therapistColors.length];
    }
  }

  /// 월 변경
  Future<void> changeMonth(DateTime newMonth, String centerId) async {
    _currentMonth = newMonth;
    _selectedDate = DateTime(newMonth.year, newMonth.month, 1);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _schedules = await _scheduleService.getSchedulesByMonth(
        centerId: centerId,
        month: newMonth,
      );

      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 날짜 선택
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// 선생님 필터 토글
  void toggleTherapistFilter(String therapistId) {
    _therapistFilter[therapistId] = !(_therapistFilter[therapistId] ?? false);
    _applyFilters();
    notifyListeners();
  }

  /// 모든 선생님 선택
  void selectAllTherapists() {
    for (var key in _therapistFilter.keys) {
      _therapistFilter[key] = true;
    }
    _applyFilters();
    notifyListeners();
  }

  /// 모든 선생님 해제
  void deselectAllTherapists() {
    for (var key in _therapistFilter.keys) {
      _therapistFilter[key] = false;
    }
    _applyFilters();
    notifyListeners();
  }

  /// 필터 적용
  void _applyFilters() {
    _filteredSchedules = _schedules.where((schedule) {
      // 선생님 필터 확인
      final isTherapistSelected = _therapistFilter[schedule.therapistId] ?? false;
      return isTherapistSelected;
    }).toList();
  }

  /// 특정 날짜의 일정만 가져오기
  List<Schedule> getSchedulesForDate(DateTime date) {
    return _filteredSchedules
        .where((schedule) =>
            schedule.date.year == date.year &&
            schedule.date.month == date.month &&
            schedule.date.day == date.day)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// 특정 날짜의 일정 개수
  int getScheduleCountForDate(DateTime date) {
    return getSchedulesForDate(date).length;
  }

  /// 일정 추가
  Future<void> addSchedule({
    required String centerId,
    required Schedule schedule,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _scheduleService.addSchedule(schedule);
      
      // 일정 재로드
      await initializeSchedules(
        centerId: centerId,
        therapistIds: _therapistFilter.keys.toList(),
      );
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 일정 수정
  Future<void> updateSchedule({
    required String scheduleId,
    required String centerId,
    required Schedule schedule,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _scheduleService.updateSchedule(
        scheduleId: scheduleId,
        schedule: schedule,
      );
      
      // 일정 재로드
      await initializeSchedules(
        centerId: centerId,
        therapistIds: _therapistFilter.keys.toList(),
      );
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 일정 삭제
  Future<void> deleteSchedule({
    required String scheduleId,
    required String centerId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _scheduleService.deleteSchedule(scheduleId);
      
      // 일정 재로드
      await initializeSchedules(
        centerId: centerId,
        therapistIds: _therapistFilter.keys.toList(),
      );
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
    return '일정 로드 중 오류가 발생했습니다.';
  }
}
