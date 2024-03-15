import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  String? _fullName;
  String? get fullName => _fullName;
  bool hasFullName() => _fullName != null;

  String? _classAndSection;
  String? get classAndSection => _classAndSection;
  bool hasClassAndSection() => _classAndSection != null;

  String? _school;
  String? get school => _school;
  bool hasSchool() => _school != null;

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  bool hasPhoneNumber() => _phoneNumber != null;

  String? _specialInstructions;
  String? get specialInstructions => _specialInstructions;
  bool hasSpecialInstructions() => _specialInstructions != null;


  // "items" field.
  List<CartItemTypeStruct>? _items;
  List<CartItemTypeStruct> get items => _items ?? const [];
  bool hasItems() => _items != null;

  DocumentReference get parentReference => reference.parent.parent!;


  void _initializeFields() {
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _uid = snapshotData['uid'] as String?;
    _items = getStructList(
      snapshotData['items'],
      CartItemTypeStruct.fromMap,
    );
    _fullName = snapshotData['fullName'] as String?;
    _classAndSection = snapshotData['classAndSection'] as String?;
    _school = snapshotData['school'] as String?;
    _phoneNumber = snapshotData['phoneNumber'] as String?;
    _specialInstructions = snapshotData['specialInstructions'] as String?;

  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('orders')
          : FirebaseFirestore.instance.collectionGroup('orders');

  // static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
  //     parent.collection('orders').doc(id);
  static DocumentReference createDoc([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;
    return firestore.collection('orders').doc();
  }
  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Query<Map<String, dynamic>> queryUserOrders(String uid) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: uid);
  }

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdersRecordData({
  String? uid,
  DateTime? timestamp,
  String? status,
  String? fullName,
  String? classAndSection,
  String? school,
  String? phoneNumber,
  String? specialInstructions,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'timestamp': timestamp,
      'status': status,
      'fullName': fullName,
      'classAndSection': classAndSection,
      'school': school,
      'phoneNumber': phoneNumber,
      'specialInstructions': specialInstructions,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.timestamp == e2?.timestamp &&
        e1?.status == e2?.status &&
        e1?.fullName == e2?.fullName &&
        e1?.classAndSection == e2?.classAndSection &&
        e1?.school == e2?.school &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.specialInstructions == e2?.specialInstructions &&
        listEquality.equals(e1?.items, e2?.items);
  }

  @override
  int hash(OrdersRecord? e) =>
      const ListEquality().hash([e?.timestamp, e?.status,e?.fullName,e?.classAndSection,e?.school,e?.phoneNumber,e?.specialInstructions, e?.items]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;

}
