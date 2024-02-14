import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HomeRecord extends FirestoreRecord {
  HomeRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "item" field.
  String? _item;
  String get item => _item ?? '';
  bool hasItem() => _item != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  void _initializeFields() {
    _item = snapshotData['item'] as String?;
    _image = snapshotData['image'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Home');

  static Stream<HomeRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HomeRecord.fromSnapshot(s));

  static Future<HomeRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HomeRecord.fromSnapshot(s));

  static HomeRecord fromSnapshot(DocumentSnapshot snapshot) => HomeRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HomeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HomeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HomeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HomeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHomeRecordData({
  String? item,
  String? image,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'item': item,
      'image': image,
    }.withoutNulls,
  );

  return firestoreData;
}

class HomeRecordDocumentEquality implements Equality<HomeRecord> {
  const HomeRecordDocumentEquality();

  @override
  bool equals(HomeRecord? e1, HomeRecord? e2) {
    return e1?.item == e2?.item && e1?.image == e2?.image;
  }

  @override
  int hash(HomeRecord? e) => const ListEquality().hash([e?.item, e?.image]);

  @override
  bool isValidKey(Object? o) => o is HomeRecord;
}
