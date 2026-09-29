import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/exceptions.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 센터의 모든 일정 조회 (월)
  Future<List<Schedule>> getSchedulesByMonth({
    required String centerId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final query = await _firestore
          .collection(schedulesCollection)
          .where('centerId', isEqualTo: centerId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .get();

      return query.docs
          .map((doc) => Schedule.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('일정을 불러올 수 없습니다.');
    }
  }

  /// 특정 날짜의 일정 조회
  Future<List<Schedule>> getSchedulesByDate({
    required String centerId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final query = await _firestore
          .collection(schedulesCollection)
          .where('centerId', isEqualTo: centerId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .get();

      return query.docs
          .map((doc) => Schedule.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('일정을 불러올 수 없습니다.');
    }
  }

  /// 선생님의 일정 조회
  Future<List<Schedule>> getSchedulesByTherapist({
    required String therapistId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final query = await _firestore
          .collection(schedulesCollection)
          .where('therapistId', isEqualTo: therapistId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .get();

      return query.docs
          .map((doc) => Schedule.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('일정을 불러올 수 없습니다.');
    }
  }

  /// 원생의 일정 조회 (보호자용)
  Future<List<Schedule>> getSchedulesByChild({
    required String childId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final query = await _firestore
          .collection(schedulesCollection)
          .where('childId', isEqualTo: childId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .get();

      return query.docs
          .map((doc) => Schedule.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('일정을 불러올 수 없습니다.');
    }
  }

  /// 일정 추가
  Future<String> addSchedule(Schedule schedule) async {
    try {
      final docRef = await _firestore
          .collection(schedulesCollection)
          .add(schedule.toFirestore());

      return docRef.id;
    } catch (e) {
      throw FirestoreException('일정을 추가할 수 없습니다.');
    }
  }

  /// 일정 수정
  Future<void> updateSchedule({
    required String scheduleId,
    required Schedule schedule,
  }) async {
    try {
      await _firestore
          .collection(schedulesCollection)
          .doc(scheduleId)
          .update(schedule.toFirestore());
    } catch (e) {
      throw FirestoreException('일정을 수정할 수 없습니다.');
    }
  }

  /// 일정 삭제
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _firestore
          .collection(schedulesCollection)
          .doc(scheduleId)
          .delete();
    } catch (e) {
      throw FirestoreException('일정을 삭제할 수 없습니다.');
    }
  }

  /// 일정 상태 업데이트 (완료/미완료)
  Future<void> updateScheduleStatus({
    required String scheduleId,
    required String status,
  }) async {
    try {
      await _firestore
          .collection(schedulesCollection)
          .doc(scheduleId)
          .update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw FirestoreException('일정 상태를 업데이트할 수 없습니다.');
    }
  }

  /// 일정 스트림 (실시간 업데이트)
  Stream<List<Schedule>> getSchedulesStream({
    required String centerId,
    required DateTime month,
  }) {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      return _firestore
          .collection(schedulesCollection)
          .where('centerId', isEqualTo: centerId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: false)
          .orderBy('startTime', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Schedule.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw FirestoreException('일정 스트림을 생성할 수 없습니다.');
    }
  }
}
