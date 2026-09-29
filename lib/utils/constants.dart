/// 앱 전역 상수들

// Firestore Collection Names
const String usersCollection = 'users';
const String schedulesCollection = 'schedules';
const String childrenCollection = 'children';
const String centersCollection = 'centers';
const String therapistsCollection = 'therapists';
const String recordsCollection = 'records';

// Error Messages
const String errorUnknown = '알 수 없는 오류가 발생했습니다.';
const String errorNetwork = '네트워크 연결을 확인해주세요.';
const String errorAuth = '인증에 실패했습니다.';
const String errorFirestore = 'Firestore 오류가 발생했습니다.';
const String errorValidation = '입력값을 확인해주세요.';

// Validation
const int minPasswordLength = 6;
const int maxNameLength = 50;
const int maxMemoLength = 500;

// Durations
const Duration delayShort = Duration(milliseconds: 300);
const Duration delayMedium = Duration(milliseconds: 500);
const Duration delayLong = Duration(seconds: 1);
