import 'package:mtb1/backend/backend.dart';
import 'package:mtb1/backend/schema/util/firestore_util.dart';

class StudentRecord extends FirestoreRecord {
  StudentRecord._(
      DocumentReference reference,
      Map<String, dynamic> data,
      ) : super(reference, data) {
    _initializeFields();
  }

  // Fields for StudentRecord
  String? _studentName;
  String get studentName => _studentName ?? '';
  bool hasStudentName() => _studentName != null;

  String? _studentClass;
  String get studentClass => _studentClass ?? '';
  bool hasStudentClass() => _studentClass != null;

  String? _studentSection;
  String get studentSection => _studentSection ?? '';
  bool hasStudentSection() => _studentSection != null;

  String? _schoolName;
  String get schoolName => _schoolName ?? '';
  bool hasSchoolName() => _schoolName != null;

  String? _specialInstructions;
  String get specialInstructions => _specialInstructions ?? '';
  bool hasSpecialInstructions() => _specialInstructions != null;

  // Initialize fields from snapshot data
  void _initializeFields() {
    _studentName = snapshotData['studentName'] as String?;
    _studentClass = snapshotData['studentClass'] as String?;
    _studentSection = snapshotData['studentSection'] as String?;
    _schoolName = snapshotData['schoolName'] as String?;
    _specialInstructions = snapshotData['specialInstructions'] as String?;
  }

  static Stream<StudentRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => StudentRecord.fromSnapshot(s));

  static Future<StudentRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => StudentRecord.fromSnapshot(s));

  static StudentRecord fromSnapshot(DocumentSnapshot snapshot) => StudentRecord._(
    snapshot.reference,
    mapFromFirestore(snapshot.data() as Map<String, dynamic>),
  );

  @override
  String toString() =>
      'StudentRecord(reference: ${reference.path}, data: $snapshotData)';

// You can add more helper methods and logic if needed
}

Map<String, dynamic> createStudentRecordData({
  String? studentName,
  String? studentClass,
  String? studentSection,
  String? schoolName,
  String? specialInstructions,
}) {
  final firestoreData = mapToFirestore({
    'studentName': studentName,
    'studentClass': studentClass,
    'studentSection': studentSection,
    'schoolName': schoolName,
    'specialInstructions': specialInstructions,
  }.withoutNulls);

  return firestoreData;
}
