import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/exceptions.dart';

class TherapistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 센터의 모든 선생님 조회
  Future<List<User>> getTherapistsByCenter(String centerId) async {
    try {
      final query = await _firestore
          .collection(usersCollection)
          .where('centerId', isEqualTo: centerId)
          .where('role', isEqualTo: 'therapist')
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return query.docs
          .map((doc) => User.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('선생님 목록을 불러올 수 없습니다.');
    }
  }

  /// 선생님 상세 정보 조회
  Future<User> getTherapist(String therapistId) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(therapistId)
          .get();

      if (!doc.exists) {
        throw FirestoreException('존재하지 않는 선생님입니다.');
      }

      return User.fromFirestore(doc);
    } catch (e) {
      throw FirestoreException('선생님 정보를 불러올 수 없습니다.');
    }
  }

  /// 선생님 등록 (센터 관리자)
  Future<void> inviteTherapist({
    required String centerId,
    required String email,
    required String name,
  }) async {
    try {
      // 이메일로 기존 사용자 찾기
      final query = await _firestore
          .collection(usersCollection)
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isEmpty) {
        throw FirestoreException(
          '해당 이메일로 가입한 사용자가 없습니다. 먼저 가입해주세요.',
        );
      }

      final therapistDoc = query.docs.first;
      final therapistId = therapistDoc.id;

      // 센터에 지정
      await _firestore
          .collection(usersCollection)
          .doc(therapistId)
          .update({
        'centerId': centerId,
        'role': 'therapist',
        'isActive': true,
      });
    } catch (e) {
      throw FirestoreException('선생님을 등록할 수 없습니다.');
    }
  }

  /// 선생님 정보 수정
  Future<void> updateTherapist({
    required String therapistId,
    required String name,
    required String? photoUrl,
  }) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(therapistId)
          .update({
        'name': name,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw FirestoreException('선생님 정보를 수정할 수 없습니다.');
    }
  }

  /// 선생님 삭제 (비활성화)
  Future<void> deleteTherapist(String therapistId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(therapistId)
          .update({
        'isActive': false,
        'centerId': '',
      });
    } catch (e) {
      throw FirestoreException('선생님을 삭제할 수 없습니다.');
    }
  }

  /// 선생님 권한 업데이트
  Future<void> updateTherapistRole({
    required String therapistId,
    required String role, // 'therapist', 'center_admin'
  }) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(therapistId)
          .update({
        'role': role,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw FirestoreException('권한을 업데이트할 수 없습니다.');
    }
  }

  /// 선생님 목록 스트림 (실시간 업데이트)
  Stream<List<User>> getTherapistsStream(String centerId) {
    try {
      return _firestore
          .collection(usersCollection)
          .where('centerId', isEqualTo: centerId)
          .where('role', isEqualTo: 'therapist')
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => User.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw FirestoreException('선생님 리스트 스트림을 생성할 수 없습니다.');
    }
  }

  /// 선생님 검색
  Future<List<User>> searchTherapists({
    required String centerId,
    required String query,
  }) async {
    try {
      if (query.isEmpty) {
        return getTherapistsByCenter(centerId);
      }

      final allTherapists = await getTherapistsByCenter(centerId);
      
      return allTherapists
          .where((therapist) =>
              therapist.name.toLowerCase().contains(query.toLowerCase()) ||
              therapist.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw FirestoreException('선생님 검색에 실패했습니다.');
    }
  }

  /// 선생님별 색상 지정 (선택사항)
  Future<void> assignTherapistColor({
    required String therapistId,
    required String color,
  }) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(therapistId)
          .update({'color': color});
    } catch (e) {
      throw FirestoreException('색상을 지정할 수 없습니다.');
    }
  }
}
