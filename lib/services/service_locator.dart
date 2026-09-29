import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/schedule_service.dart';
import '../services/child_service.dart';
import '../services/therapist_service.dart';
import '../services/record_service.dart';

/// 모든 Service를 관리하는 클래스
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late AuthService _authService;
  late ScheduleService _scheduleService;
  late ChildService _childService;
  late TherapistService _therapistService;
  late RecordService _recordService;

  void setupServices() {
    _authService = AuthService();
    _scheduleService = ScheduleService();
    _childService = ChildService();
    _therapistService = TherapistService();
    _recordService = RecordService();
  }

  AuthService get authService => _authService;
  ScheduleService get scheduleService => _scheduleService;
  ChildService get childService => _childService;
  TherapistService get therapistService => _therapistService;
  RecordService get recordService => _recordService;
}

/// Service 접근용 헬퍼
final serviceLocator = ServiceLocator();

/// MultiProvider 셋업
List<ChangeNotifierProvider> setupServiceProviders() {
  return [
    // Services는 이미 main.dart에서 초기화됨
  ];
}
