// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartItemTypeStruct extends FFFirebaseStruct {
  CartItemTypeStruct({
    DocumentReference? planRef,
    int? quantity,
    String? mealPlanId, // Add mealPlanId
    String? selectedStudentId, // New field for selected student ID
    double? totalPrice,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),

  })  : _planRef = planRef,
        _quantity = quantity,
        _mealPlanId = mealPlanId, // Initialize mealPlanId
        _selectedStudentId = selectedStudentId,
        _totalPrice = totalPrice,
        super(firestoreUtilData);

  // "planRef" field.
  DocumentReference? _planRef;
  DocumentReference? get planRef => _planRef;
  set planRef(DocumentReference? val) => _planRef = val;
  bool hasPlanRef() => _planRef != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;
  void incrementQuantity(int amount) => _quantity = quantity + amount;
  bool hasQuantity() => _quantity != null;
  // "mealPlanId" field
  String? _mealPlanId;
  String? get mealPlanId => _mealPlanId;
  set mealPlanId(String? val) => _mealPlanId = val;

  String? _selectedStudentId;
  String? get selectedStudentId => _selectedStudentId;
  set selectedStudentId(String? val) => _selectedStudentId = val;

  double? _totalPrice; // New field for total price
  double? get totalPrice => _totalPrice;
  set totalPrice(double? val) => _totalPrice = val;


  static CartItemTypeStruct fromMap(Map<String, dynamic> data) =>
      CartItemTypeStruct(
        planRef: data['planRef'] as DocumentReference?,
        quantity: castToType<int>(data['quantity']),
        mealPlanId: data['mealPlanId'] as String?, // Handle mealPlanId
        selectedStudentId: data['selectedStudentId'] as String?,
        totalPrice: data['totalPrice'] as double?,
      );

  static CartItemTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? CartItemTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'planRef': _planRef,
        'quantity': _quantity,
    'mealPlanId': _mealPlanId,
    'selectedStudentId': _selectedStudentId,
    'totalPrice': _totalPrice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'planRef': serializeParam(
          _planRef,
          ParamType.DocumentReference,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
    'mealPlanId': serializeParam( // Serialize mealPlanId
      _mealPlanId,
      ParamType.String,
    ),'selectedStudentId': serializeParam(_selectedStudentId, ParamType.String),
    'totalPrice': serializeParam(_totalPrice, ParamType.double),
      }.withoutNulls;

  static CartItemTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      CartItemTypeStruct(
        planRef: deserializeParam(
          data['planRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['mealplan', 'plans'],
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        mealPlanId: deserializeParam( // Deserialize mealPlanId
          data['mealPlanId'],
          ParamType.String,
          false,
        ),selectedStudentId: deserializeParam(data['selectedStudentId'], ParamType.String, false),
        totalPrice: deserializeParam(data['totalPrice'], ParamType.double, false),
      );

  @override
  String toString() => 'CartItemTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CartItemTypeStruct &&
        planRef == other.planRef &&
        quantity == other.quantity;
  }

  @override
  int get hashCode => const ListEquality().hash([planRef, quantity]);
}

CartItemTypeStruct createCartItemTypeStruct({
  DocumentReference? planRef,
  int? quantity,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CartItemTypeStruct(
      planRef: planRef,
      quantity: quantity,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CartItemTypeStruct? updateCartItemTypeStruct(
  CartItemTypeStruct? cartItemType, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cartItemType
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCartItemTypeStructData(
  Map<String, dynamic> firestoreData,
  CartItemTypeStruct? cartItemType,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cartItemType == null) {
    return;
  }
  if (cartItemType.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && cartItemType.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cartItemTypeData =
      getCartItemTypeFirestoreData(cartItemType, forFieldValue);
  final nestedData =
      cartItemTypeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cartItemType.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCartItemTypeFirestoreData(
  CartItemTypeStruct? cartItemType, [
  bool forFieldValue = false,
]) {
  if (cartItemType == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cartItemType.toMap());

  // Add any Firestore field values
  cartItemType.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCartItemTypeListFirestoreData(
  List<CartItemTypeStruct>? cartItemTypes,
) =>
    cartItemTypes?.map((e) => getCartItemTypeFirestoreData(e, true)).toList() ??
    [];
