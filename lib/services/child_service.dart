import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/exceptions.dart';

class ChildService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 센터의 모든 원생 조회
  Future<List<Child>> getChildrenByCenter(String centerId) async {
    try {
      final query = await _firestore
          .collection(childrenCollection)
          .where('centerId', isEqualTo: centerId)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return query.docs
          .map((doc) => Child.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('원생 목록을 불러올 수 없습니다.');
    }
  }

  /// 선생님의 담당 원생 조회
  Future<List<Child>> getChildrenByTherapist(String therapistId) async {
    try {
      final query = await _firestore
          .collection(childrenCollection)
          .where('therapistId', isEqualTo: therapistId)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return query.docs
          .map((doc) => Child.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('담당 원생 목록을 불러올 수 없습니다.');
    }
  }

  /// 보호자의 자녀 조회
  Future<List<Child>> getChildrenByParent(String parentId) async {
    try {
      final query = await _firestore
          .collection(childrenCollection)
          .where('parentId', isEqualTo: parentId)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return query.docs
          .map((doc) => Child.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw FirestoreException('자녀 정보를 불러올 수 없습니다.');
    }
  }

  /// 원생 상세 정보 조회
  Future<Child> getChild(String childId) async {
    try {
      final doc = await _firestore
          .collection(childrenCollection)
          .doc(childId)
          .get();

      if (!doc.exists) {
        throw FirestoreException('존재하지 않는 원생입니다.');
      }

      return Child.fromFirestore(doc);
    } catch (e) {
      throw FirestoreException('원생 정보를 불러올 수 없습니다.');
    }
  }

  /// 원생 추가
  Future<String> addChild(Child child) async {
    try {
      final docRef = await _firestore
          .collection(childrenCollection)
          .add(child.toFirestore());

      return docRef.id;
    } catch (e) {
      throw FirestoreException('원생을 추가할 수 없습니다.');
    }
  }

  /// 원생 정보 수정
  Future<void> updateChild({
    required String childId,
    required Child child,
  }) async {
    try {
      await _firestore
          .collection(childrenCollection)
          .doc(childId)
          .update(child.toFirestore());
    } catch (e) {
      throw FirestoreException('원생 정보를 수정할 수 없습니다.');
    }
  }

  /// 원생 담당 선생님 지정
  Future<void> assignTherapist({
    required String childId,
    required String therapistId,
  }) async {
    try {
      await _firestore
          .collection(childrenCollection)
          .doc(childId)
          .update({'therapistId': therapistId});
    } catch (e) {
      throw FirestoreException('담당 선생님을 지정할 수 없습니다.');
    }
  }

  /// 원생 삭제 (비활성화)
  Future<void> deleteChild(String childId) async {
    try {
      await _firestore
          .collection(childrenCollection)
          .doc(childId)
          .update({'isActive': false});
    } catch (e) {
      throw FirestoreException('원생을 삭제할 수 없습니다.');
    }
  }

  /// 원생 리스트 스트림 (실시간 업데이트)
  Stream<List<Child>> getChildrenStream(String centerId) {
    try {
      return _firestore
          .collection(childrenCollection)
          .where('centerId', isEqualTo: centerId)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Child.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw FirestoreException('원생 리스트 스트림을 생성할 수 없습니다.');
    }
  }

  /// 원생 검색
  Future<List<Child>> searchChildren({
    required String centerId,
    required String query,
  }) async {
    try {
      if (query.isEmpty) {
        return getChildrenByCenter(centerId);
      }

      final allChildren = await getChildrenByCenter(centerId);
      
      return allChildren
          .where((child) =>
              child.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw FirestoreException('원생 검색에 실패했습니다.');
    }
  }
}
