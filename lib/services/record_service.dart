import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';
import '../utils/exceptions.dart';

class RecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 기록 추가 (치료기록/상담평가)
  Future<String> addRecord({
    required String centerId,
    required String childId,
    required String therapistId,
    required String type, // 'therapy', 'consultation'
    required String subject,
    required String content,
    required DateTime date,
  }) async {
    try {
      final record = {
        'centerId': centerId,
        'childId': childId,
        'therapistId': therapistId,
        'type': type,
        'subject': subject,
        'content': content,
        'date': Timestamp.fromDate(date),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      final docRef = await _firestore
          .collection(recordsCollection)
          .add(record);

      return docRef.id;
    } catch (e) {
      throw FirestoreException('기록을 추가할 수 없습니다.');
    }
  }

  /// 원생의 기록 조회 (월)
  Future<List<Map<String, dynamic>>> getRecordsByChild({
    required String childId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final query = await _firestore
          .collection(recordsCollection)
          .where('childId', isEqualTo: childId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: true)
          .get();

      return query.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw FirestoreException('기록을 불러올 수 없습니다.');
    }
  }

  /// 선생님의 기록 조회 (월)
  Future<List<Map<String, dynamic>>> getRecordsByTherapist({
    required String therapistId,
    required DateTime month,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final query = await _firestore
          .collection(recordsCollection)
          .where('therapistId', isEqualTo: therapistId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: true)
          .get();

      return query.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw FirestoreException('기록을 불러올 수 없습니다.');
    }
  }

  /// 기록 상세 조회
  Future<Map<String, dynamic>> getRecord(String recordId) async {
    try {
      final doc = await _firestore
          .collection(recordsCollection)
          .doc(recordId)
          .get();

      if (!doc.exists) {
        throw FirestoreException('존재하지 않는 기록입니다.');
      }

      return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
    } catch (e) {
      throw FirestoreException('기록을 불러올 수 없습니다.');
    }
  }

  /// 기록 수정
  Future<void> updateRecord({
    required String recordId,
    required String subject,
    required String content,
  }) async {
    try {
      await _firestore
          .collection(recordsCollection)
          .doc(recordId)
          .update({
        'subject': subject,
        'content': content,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw FirestoreException('기록을 수정할 수 없습니다.');
    }
  }

  /// 기록 삭제
  Future<void> deleteRecord(String recordId) async {
    try {
      await _firestore
          .collection(recordsCollection)
          .doc(recordId)
          .delete();
    } catch (e) {
      throw FirestoreException('기록을 삭제할 수 없습니다.');
    }
  }

  /// 기록 검색 (내용 기반)
  Future<List<Map<String, dynamic>>> searchRecords({
    required String childId,
    required String query,
  }) async {
    try {
      final allRecords = await _firestore
          .collection(recordsCollection)
          .where('childId', isEqualTo: childId)
          .orderBy('date', descending: true)
          .get();

      return allRecords.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .where((record) {
            final subject = record['subject']?.toString().toLowerCase() ?? '';
            final content = record['content']?.toString().toLowerCase() ?? '';
            final searchQuery = query.toLowerCase();
            return subject.contains(searchQuery) || content.contains(searchQuery);
          })
          .toList();
    } catch (e) {
      throw FirestoreException('기록 검색에 실패했습니다.');
    }
  }

  /// 기록 타입별 조회
  Future<List<Map<String, dynamic>>> getRecordsByType({
    required String childId,
    required String type,
  }) async {
    try {
      final query = await _firestore
          .collection(recordsCollection)
          .where('childId', isEqualTo: childId)
          .where('type', isEqualTo: type)
          .orderBy('date', descending: true)
          .get();

      return query.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw FirestoreException('기록을 불러올 수 없습니다.');
    }
  }

  /// 기록 스트림 (실시간)
  Stream<List<Map<String, dynamic>>> getRecordsStream(String childId) {
    try {
      return _firestore
          .collection(recordsCollection)
          .where('childId', isEqualTo: childId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList());
    } catch (e) {
      throw FirestoreException('기록 스트림을 생성할 수 없습니다.');
    }
  }
}
