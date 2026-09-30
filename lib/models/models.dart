import 'package:cloud_firestore/cloud_firestore.dart';

// User Model
class User {
  final String uid;
  final String email;
  final String name;
  final String role; // 'center_admin', 'therapist', 'parent'
  final String? centerId;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.centerId,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      centerId: data['centerId'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'centerId': centerId,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
      'isActive': isActive,
    };
  }
}

// Schedule (일정) Model
class Schedule {
  final String id;
  final String centerId;
  final String therapistId;
  final String childId;
  final String? parentId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String type; // 'therapy', 'class', 'other'
  final String subject;
  final String? memo;
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String? color; // 선생님별 색상
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String therapyType; // 치료 유형
  final String childName; // 아이 이름
  final String therapistName; // 선생님 이름

  Schedule({
    required this.id,
    required this.centerId,
    required this.therapistId,
    required this.childId,
    this.parentId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.subject,
    this.memo,
    required this.status,
    this.color,
    required this.createdAt,
    this.updatedAt,
    required this.therapyType,
    required this.childName,
    required this.therapistName,
  });

  factory Schedule.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Schedule(
      id: doc.id,
      centerId: data['centerId'] ?? '',
      therapistId: data['therapistId'] ?? '',
      childId: data['childId'] ?? '',
      parentId: data['parentId'],
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      type: data['type'] ?? 'therapy',
      subject: data['subject'] ?? '',
      memo: data['memo'],
      status: data['status'] ?? 'scheduled',
      color: data['color'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      therapyType: data['therapyType'] ?? '',
      childName: data['childName'] ?? '',
      therapistName: data['therapistName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'centerId': centerId,
      'therapistId': therapistId,
      'childId': childId,
      'parentId': parentId,
      'date': Timestamp.fromDate(date),
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
      'subject': subject,
      'memo': memo,
      'status': status,
      'color': color,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }
}

// Child (원생) Model
class Child {
  final String id;
  final String centerId;
  final String name;
  final String? birthDate;
  final String? parentId;
  final String? therapistId;
  final String? memo;
  final DateTime createdAt;
  final bool isActive;

  Child({
    required this.id,
    required this.centerId,
    required this.name,
    this.birthDate,
    this.parentId,
    this.therapistId,
    this.memo,
    required this.createdAt,
    this.isActive = true,
  });

  factory Child.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Child(
      id: doc.id,
      centerId: data['centerId'] ?? '',
      name: data['name'] ?? '',
      birthDate: data['birthDate'],
      parentId: data['parentId'],
      therapistId: data['therapistId'],
      memo: data['memo'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'centerId': centerId,
      'name': name,
      'birthDate': birthDate,
      'parentId': parentId,
      'therapistId': therapistId,
      'memo': memo,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
}
