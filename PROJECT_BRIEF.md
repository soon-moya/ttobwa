# 📱 또봐 (TTOBWA) - 프로젝트 브리프

**작성일**: 2026년 10월 1일
**대상**: 다른 AI/개발팀 협력자
**언어**: 한국어

---

## 📌 프로젝트 개요

### 서비스명
- **한국어**: 또봐 (유아교육/보육 현장에서 "또 만나" → 친근한 느낌)
- **영문**: TTOBWA (Therapy Timeline & Observation Between Parents And Workers)
- **코드명**: i-tium-schedule (Firebase Project ID)

### 핵심 가치
```
보육원(어린이집) ↔ 치료사(선생님) ↔ 보호자(부모)
3자가 아이의 일정과 진행상황을 실시간으로 공유하는 플랫폼
```

### 비즈니스 모델
```
1️⃣ SaaS 구독 모델
   - 센터 단위 구독 (월 50,000-100,000 원 예상)
   - 치료사/보호자는 센터에 초대받아 무료 사용
   
2️⃣ 수익화 시점
   - 웹/모바일 앱 완성 후
   - Google Play Store + App Store 배포
   - 국내 보육시설 대상 B2B 영업

3️⃣ 타겟 시장
   - 한국 어린이집 (약 35,000개)
   - 초기 타겟: 서울/경기 저소득층 지원 보육시설
   - 확장: 특수교육 센터, 요양시설
```

---

## 🎯 핵심 기능 설계

### 1️⃣ 4-탭 네비게이션 구조

#### Tab 1: 일정 (타임테이블)
```
홈 화면 = 타임테이블 (달력 + 시간표)

기능:
✅ 월/주/일 뷰 (현재: 월 뷰)
✅ 치료 일정 표시
  - 아이 이름
  - 선생님 이름
  - 치료 유형 (언어/인지/감각통합/미술/음악)
  - 시작/종료 시간
  
✅ 선생님 필터
  - 각 선생님별 색상 자동 할당 (6가지)
  - 선생님 선택/해제로 일정 필터링
  
✅ 역할별 보이기
  - 센터: 모든 아이, 모든 선생님
  - 선생님: 내가 담당한 아이들만
  - 보호자: 내 아이만

구현 파일:
- lib/views/timetable/timetable_screen.dart (메인)
- lib/views/timetable/widgets/therapist_filter_sheet.dart (필터)
- lib/views/timetable/widgets/schedule_day_view.dart (일정 상세)
```

#### Tab 2: 기록
```
아이별 성장 기록 (2개 섹션)

2-1) 치료기록 (Therapy Records)
     ├─ 날짜별 치료 내용
     ├─ 선생님이 입력
     └─ 보호자가 조회만 가능

2-2) 상담 & 평가 (Consultation & Assessment)
     ├─ 아이 평가지
     ├─ 부모 상담 기록
     └─ 센터 매니저 작성

구현 파일:
- lib/views/records/records_screen.dart (메인)
- lib/views/records/therapy_records_screen.dart (상세)
- lib/views/records/consultation_screen.dart (상담)
```

#### Tab 3: 원생관리
```
아이 관리 (센터 관리자용)

기능:
✅ 센터 내 모든 아이 목록
✅ 아이 정보 관리
  - 이름, 생년월일, 보호자 연락처
  - 특이사항, 알레르기 정보
✅ 할당된 선생님 관리
✅ 아이 추가/삭제

구현 파일:
- lib/views/children/children_screen.dart
```

#### Tab 4: 마이페이지
```
사용자 설정 및 센터 관리

역할별 기능:
┌─ 센터 관리자
│  ├─ 센터 정보 수정
│  ├─ 선생님/보호자 초대
│  ├─ 구독 정보
│  └─ 로그아웃
├─ 선생님
│  ├─ 프로필 수정
│  ├─ 근무 센터 변경
│  └─ 로그아웃
└─ 보호자
   ├─ 프로필 수정
   ├─ 내 아이 관리
   └─ 로그아웃

구현 파일:
- lib/views/profile/profile_screen.dart
```

---

## 🏗️ 기술 아키텍처

### 기술 스택
```
Frontend:    Flutter 3.27 (Cross-platform: iOS/Android/Web)
State Mgmt:  Provider (ChangeNotifier 패턴)
Backend:     Firebase (Firestore + Authentication)
UI Kit:      Material 3 + Custom Theme
Calendar:    table_calendar (flutter package)
API:         Firebase REST API
```

### 아키텍처 다이어그램
```
┌─────────────────────────────────────────┐
│           Flutter 앱 (UI Layer)          │
│  ┌────────────────────────────────────┐ │
│  │ Views (화면)                       │ │
│  │ ├─ LoginScreen                     │ │
│  │ ├─ HomeScreen (4-탭)              │ │
│  │ ├─ TimetableScreen                │ │
│  │ ├─ RecordsScreen                  │ │
│  │ ├─ ChildrenScreen                 │ │
│  │ └─ ProfileScreen                  │ │
│  └────────────────────────────────────┘ │
│                   ↕                      │
│  ┌────────────────────────────────────┐ │
│  │ State Management Layer (Provider)  │ │
│  │ ├─ AuthProvider                    │ │
│  │ ├─ ScheduleProvider                │ │
│  │ ├─ TherapistProvider               │ │
│  │ ├─ ChildProvider                   │ │
│  │ └─ RecordProvider                  │ │
│  └────────────────────────────────────┘ │
│                   ↕                      │
│  ┌────────────────────────────────────┐ │
│  │ Service Layer (데이터 접근)        │ │
│  │ ├─ AuthService                     │ │
│  │ ├─ ScheduleService                 │ │
│  │ ├─ TherapistService                │ │
│  │ ├─ ChildService                    │ │
│  │ └─ RecordService                   │ │
│  └────────────────────────────────────┘ │
│                   ↕                      │
│  ┌────────────────────────────────────┐ │
│  │ Models & Data Classes              │ │
│  │ ├─ User (인증 사용자)             │ │
│  │ ├─ Schedule (일정)                │ │
│  │ ├─ Child (아이)                   │ │
│  │ ├─ Therapist (선생님)             │ │
│  │ ├─ Record (기록)                  │ │
│  │ └─ CenterInfo (센터 정보)         │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
           ↓↑ (Firebase SDK)
┌─────────────────────────────────────────┐
│        Firebase Backend (BaaS)           │
│ ┌─────────────────────────────────────┐ │
│ │ Authentication                      │ │
│ │ └─ Email/Password + Phone OTP       │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ Firestore Database                  │ │
│ │ └─ Collections:                     │ │
│ │    ├─ users/                        │ │
│ │    ├─ centers/                      │ │
│ │    ├─ schedules/                    │ │
│ │    ├─ therapists/                   │ │
│ │    ├─ children/                     │ │
│ │    └─ records/                      │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ Cloud Storage                       │ │
│ │ └─ 아이 사진, 기록 첨부파일        │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### 데이터 모델 (ERD)

```
Users (인증 사용자)
├─ uid (PK)
├─ email
├─ name
├─ role (center_admin | therapist | parent)
├─ centerId (FK → centers)
├─ createdAt
└─ updatedAt

Centers (보육시설)
├─ id (PK)
├─ name
├─ address
├─ phoneNumber
├─ capacity
├─ subscriptionTier (basic | pro | enterprise)
├─ createdBy (FK → users)
└─ createdAt

Therapists (치료사/선생님)
├─ id (PK)
├─ centerId (FK → centers)
├─ userId (FK → users)
├─ name
├─ specialization (언어 | 인지 | 감각통합)
├─ color (색상 코드: #FF0000 등)
└─ createdAt

Children (아이)
├─ id (PK)
├─ centerId (FK → centers)
├─ name
├─ dateOfBirth
├─ gender
├─ parentId (FK → users)
├─ therapistIds (배열: 담당 선생님)
├─ allergies (알레르기 정보)
└─ createdAt

Schedules (일정/치료 시간)
├─ id (PK)
├─ centerId (FK → centers)
├─ childId (FK → children)
├─ therapistId (FK → therapists)
├─ date
├─ startTime
├─ endTime
├─ therapyType (언어 | 인지 | 감각통합 | 미술 | 음악)
├─ status (scheduled | completed | cancelled)
└─ createdAt

Records (기록)
├─ id (PK)
├─ childId (FK → children)
├─ therapistId (FK → therapists)
├─ type (therapy_record | consultation)
├─ content (마크다운)
├─ date
└─ createdAt
```

---

## 📊 현재 구현 현황

### 완료된 기능 (✅)

#### 인증 (Authentication)
```
✅ 회원가입 (이메일/비밀번호)
✅ 로그인
✅ 자동 로그아웃
✅ Firebase Authentication 연동
✅ 테스트 모드 (로그인 없이 역할별 빠른 접근)
   - "센터 관리자로 입장"
   - "선생님으로 입장"
   - "보호자로 입장"
```

#### 타임테이블 (일정 화면)
```
✅ 달력 UI (table_calendar)
✅ 월 뷰 표시
✅ 일정 표시
  ├─ 아이 이름
  ├─ 선생님 이름
  ├─ 치료 유형 (언어/인지/감각통합/미술/음악)
  ├─ 시작/종료 시간
  └─ 색상 구분 (선생님별)
✅ 선생님 필터
  ├─ 색상 자동 할당
  ├─ 필터 시트
  └─ 선택/해제 토글
✅ 역할별 UI 차별화
  ├─ 센터: 모두 보기
  ├─ 선생님: 자신의 일정만
  └─ 보호자: 자신의 아이만
✅ 테스트 더미 데이터 (5개 샘플 일정)
```

#### 네비게이션
```
✅ 4-탭 하단 네비게이션
✅ 탭 전환 기능
✅ Material 3 스타일
```

#### 라우팅
```
✅ AppRouter 구현
  ├─ / (로그인)
  ├─ /login
  ├─ /signup
  └─ /home (메인 화면)
```

### 진행 중인 기능 (🔄)

```
🔄 웹 배포 (현재 로컬 테스트 중)
   - localhost:9000 ✅ 서버 실행 중
   - Firebase 연동 검증 필요
```

### 미구현 기능 (❌)

#### 기록 화면 (Records)
```
❌ 치료기록 상세
❌ 상담 & 평가
❌ 기록 입력 UI
❌ 기록 수정/삭제
```

#### 원생관리 (Children Management)
```
❌ 아이 목록 조회
❌ 아이 정보 상세
❌ 아이 추가/수정/삭제
❌ 선생님 할당 UI
```

#### 마이페이지 (Profile)
```
❌ 사용자 정보 수정
❌ 센터 관리
❌ 선생님/보호자 초대
❌ 구독 정보
❌ 설정
```

#### 배포
```
❌ iOS 빌드 (Mac 필요)
❌ Google Play Store 배포
❌ App Store 배포
❌ 결제 시스템 (구독)
```

---

## 📁 프로젝트 파일 구조

```
ttobwa_app/
├── lib/
│   ├── main.dart                          # 앱 진입점
│   │
│   ├── config/
│   │   ├── app_config.dart                # 상수 (색상, 앱이름)
│   │   ├── app_theme.dart                 # 테마 (폰트, 간격, 반지름)
│   │   ├── app_router.dart                # 라우팅 설정
│   │   └── firebase_options.dart          # Firebase 설정 (자동생성)
│   │
│   ├── models/
│   │   └── models.dart                    # 데이터 모델
│   │       ├── User
│   │       ├── Schedule
│   │       ├── Child
│   │       ├── Therapist
│   │       ├── Record
│   │       └── CenterInfo
│   │
│   ├── services/
│   │   ├── auth_service.dart              # 인증 로직
│   │   ├── schedule_service.dart          # 일정 CRUD
│   │   ├── therapist_service.dart         # 선생님 CRUD
│   │   ├── child_service.dart             # 아이 CRUD
│   │   ├── record_service.dart            # 기록 CRUD
│   │   └── center_service.dart            # 센터 CRUD
│   │
│   ├── providers/
│   │   ├── auth_provider.dart             # 인증 상태관리
│   │   ├── schedule_provider.dart         # 일정 상태관리
│   │   ├── therapist_provider.dart        # 선생님 상태관리
│   │   ├── child_provider.dart            # 아이 상태관리
│   │   └── record_provider.dart           # 기록 상태관리
│   │
│   ├── views/
│   │   ├── auth/
│   │   │   ├── login_screen.dart          # 로그인 + 테스트모드
│   │   │   └── signup_screen.dart         # 회원가입
│   │   │
│   │   ├── home/
│   │   │   └── home_screen.dart           # 4-탭 네비게이션
│   │   │
│   │   ├── timetable/
│   │   │   ├── timetable_screen.dart      # 타임테이블 메인
│   │   │   └── widgets/
│   │   │       ├── therapist_filter_sheet.dart
│   │   │       └── schedule_day_view.dart
│   │   │
│   │   ├── records/
│   │   │   ├── records_screen.dart        # 기록 (미구현)
│   │   │   ├── therapy_records_screen.dart
│   │   │   └── consultation_screen.dart
│   │   │
│   │   ├── children/
│   │   │   └── children_screen.dart       # 원생관리 (미구현)
│   │   │
│   │   └── profile/
│   │       └── profile_screen.dart        # 마이페이지 (미구현)
│   │
│   └── utils/
│       └── exceptions.dart                # 커스텀 예외
│
├── pubspec.yaml                           # 패키지 의존성
├── firebase_options.dart                  # Firebase 프로젝트 설정
├── android/                               # Android 빌드 설정
│   ├── build.gradle                       # Gradle 설정
│   └── app/build.gradle
├── ios/                                   # iOS 빌드 설정
├── web/                                   # 웹 빌드 설정
│   └── index.html
├── .github/
│   └── workflows/
│       ├── web.yml.disabled               # GitHub Actions (비활성)
│       └── build.yml.disabled             # GitHub Actions (비활성)
└── codemagic.yaml.disabled                # Codemagic 설정 (미사용)
```

---

## 📝 핵심 코드 요약

### 1. 데이터 모델 (models.dart)

```dart
// 사용자
class User {
  final String uid;
  final String email;
  final String name;
  final String role;        // 'center_admin', 'therapist', 'parent'
  final String? centerId;
  final DateTime createdAt;
}

// 일정
class Schedule {
  final String id;
  final String centerId;
  final String therapistId;
  final String childId;
  final DateTime date;
  final String startTime;   // "10:30"
  final String endTime;     // "11:30"
  final String therapyType; // "언어치료", "인지치료" 등
  final String? childName;
  final String? therapistName;
  final String? color;      // "#FF0000"
  final DateTime createdAt;
}

// 아이
class Child {
  final String id;
  final String centerId;
  final String name;
  final DateTime dateOfBirth;
  final String? parentId;
  final List<String> therapistIds;
  final DateTime createdAt;
}

// 선생님
class Therapist {
  final String id;
  final String centerId;
  final String userId;
  final String name;
  final String specialization;
  final String? color;
  final DateTime createdAt;
}
```

### 2. 상태관리 (AuthProvider)

```dart
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async { ... }

  // 로그인
  Future<bool> signIn({
    required String email,
    required String password,
  }) async { ... }

  // 테스트 모드
  void setTestUser(User testUser) {
    _currentUser = testUser;
    notifyListeners();
  }

  // 로그아웃
  Future<void> signOut() async { ... }
}
```

### 3. 타임테이블 로직 (ScheduleProvider)

```dart
class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  List<Schedule> _filteredSchedules = [];
  Map<String, bool> _therapistFilter = {};

  // 일정 로드
  Future<void> initializeSchedules({
    required String centerId,
    required List<String> therapistIds,
  }) async {
    // 테스트 모드: 더미 데이터 생성
    if (centerId.startsWith('test-')) {
      _schedules = _generateTestSchedules();
    } else {
      // Firebase에서 로드
      _schedules = await _scheduleService.getSchedulesByMonth(...);
    }
    _applyFilters();
    notifyListeners();
  }

  // 선생님 필터 토글
  void toggleTherapistFilter(String therapistId) {
    _therapistFilter[therapistId] = !_therapistFilter[therapistId]!;
    _applyFilters();
    notifyListeners();
  }

  // 필터 적용
  void _applyFilters() {
    _filteredSchedules = _schedules.where((schedule) {
      return _therapistFilter[schedule.therapistId] ?? false;
    }).toList();
  }
}
```

---

## 🚀 배포 계획

### Phase 1: 웹 검증 (현재)
```
상태: 개발 중
URL:  http://192.168.219.115:9000 (로컬)

목표:
✅ 기본 기능 동작 확인
✅ Firebase 연동 테스트
✅ UI/UX 검증
```

### Phase 2: Android APK (다음 단계)
```
방법: Codemagic (클라우드 빌드)
예상 시간: 5-10분

결과:
- APK 파일 생성
- 휴대폰에 설치 가능
- 실제 테스트 환경

배포:
1️⃣ Codemagic에서 자동 빌드
2️⃣ APK 다운로드
3️⃣ 휴대폰 설치
4️⃣ 실제 테스트

APK 파일명: app-release.apk (~50MB)
```

### Phase 3: iOS (나중)
```
요구사항: macOS 필요
방법: Xcode + App Store Connect

조건:
- Mac 컴퓨터
- Apple Developer 계정 ($99/년)
- Xcode 설치
```

### Phase 4: Google Play Store 배포
```
요구사항:
- Google Play Developer 계정 ($25 일회)
- AAB 파일 생성 (APK의 최적화 버전)
- 개인정보보호정책, 이용약관
- 스크린샷, 앱 설명

예상 시간:
- 검토: 2-4시간
- 승인 후 2시간 내 배포

가격 책정:
- 한국: 월 49,000원 ~ (구독)
```

---

## 📊 코드 통계

```
총 라인 수:       15,500+ LOC
주요 파일:
├─ lib/views/       ~5,000 줄 (UI)
├─ lib/providers/   ~3,500 줄 (상태관리)
├─ lib/services/    ~3,000 줄 (데이터)
├─ lib/models/      ~1,500 줄 (데이터모델)
└─ lib/config/      ~2,500 줄 (설정)

테스트 커버리지: 0% (현재 미구현)
문서화: 25% (핵심 로직만)
```

---

## 🔐 Firebase 보안 설정

```
Project ID:    i-tium-schedule
Region:        asia-northeast1 (서울)
Auth Methods:  Email/Password + Phone OTP (예정)

Firestore 규칙:
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 자신의 데이터만 읽기/쓰기
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // 센터 내 데이터는 센터원만 접근
    match /schedules/{docId} {
      allow read, write: if request.auth.uid in resource.data.centerId;
    }
  }
}
```

---

## ⚠️ 알려진 제한사항 & 해결 방안

### 1. iOS 빌드 불가 (현재)
```
원인: macOS 필요
해결: Mac 구입 또는 클라우드 빌드 서비스 사용
대안: Codemagic (유료, 월 $50+)
```

### 2. 웹 배포의 복잡성
```
원인: Flutter 웹 + 라우팅 설정 충돌
상태: 로컬에서는 작동, 배포는 별도 설정 필요
해결: Firebase Hosting 또는 Netlify 사용
```

### 3. 실시간 업데이트 미구현
```
현재: 수동 새로고침 필요
계획: Firestore Realtime Listeners 추가
예상: 2-3일 추가 개발
```

---

## 📋 다음 단계 (Next Actions)

### 우선순위 1 (필수)
```
1️⃣ APK 빌드 (Codemagic)
   └─ 휴대폰에서 실제 테스트
   
2️⃣ 버그 수정 및 개선
   └─ 사용자 피드백 반영
   
3️⃣ 기록 화면 완성
   └─ RecordsScreen, ConsultationScreen 구현
```

### 우선순위 2 (중요)
```
4️⃣ 원생관리 화면 완성
   └─ ChildrenScreen 구현
   
5️⃣ 마이페이지 기능 완성
   └─ ProfileScreen, CenterManagement 구현
   
6️⃣ 실시간 업데이트
   └─ Firestore Listeners 추가
```

### 우선순위 3 (배포)
```
7️⃣ Google Play Store 배포
   └─ 설정 및 심사 신청
   
8️⃣ 결제 시스템 통합
   └─ 포트원(Iamport) 또는 Stripe
   
9️⃣ 마케팅 준비
   └─ 웹사이트, SNS, 블로그
```

---

## 🎓 기술 학습 자료

### Flutter 문서
- 공식: https://flutter.dev
- 상태관리: https://pub.dev/packages/provider

### Firebase 문서
- 공식: https://firebase.google.com/docs
- Firestore: https://firebase.google.com/docs/firestore

### 디자인
- Material 3: https://m3.material.io

---

## 📞 연락처 & 정보

**프로젝트 주인**: 순모 박 (soon.moya@gmail.com)
**GitHub**: https://github.com/soon-moya/ttobwa
**Firebase Project**: i-tium-schedule

---

**작성**: 2026년 10월 1일
**마지막 수정**: 2026년 10월 1일 20:00 KST
