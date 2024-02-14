import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MenuitemsRecord extends FirestoreRecord {
  MenuitemsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "item" field.
  String? _item;
  String get item => _item ?? '';
  bool hasItem() => _item != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _image = snapshotData['image'] as String?;
    _item = snapshotData['item'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('menuitems')
          : FirebaseFirestore.instance.collectionGroup('menuitems');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('menuitems').doc(id);

  static Stream<MenuitemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MenuitemsRecord.fromSnapshot(s));

  static Future<MenuitemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MenuitemsRecord.fromSnapshot(s));

  static MenuitemsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MenuitemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MenuitemsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MenuitemsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MenuitemsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MenuitemsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMenuitemsRecordData({
  String? image,
  String? item,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image': image,
      'item': item,
    }.withoutNulls,
  );

  return firestoreData;
}

class MenuitemsRecordDocumentEquality implements Equality<MenuitemsRecord> {
  const MenuitemsRecordDocumentEquality();

  @override
  bool equals(MenuitemsRecord? e1, MenuitemsRecord? e2) {
    return e1?.image == e2?.image && e1?.item == e2?.item;
  }

  @override
  int hash(MenuitemsRecord? e) =>
      const ListEquality().hash([e?.image, e?.item]);

  @override
  bool isValidKey(Object? o) => o is MenuitemsRecord;
}
