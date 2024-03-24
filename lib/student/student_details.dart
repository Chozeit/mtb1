import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mtb1/flutter_flow/flutter_flow_util.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class StudentDetailsForm extends StatefulWidget {
  final String uid;
  final bool showSkipButton;

  StudentDetailsForm({
    Key? key,
    required this.uid,
    this.showSkipButton = false, // Default value is false
  }) : super(key: key);
  @override
  _StudentDetailsFormState createState() => _StudentDetailsFormState();
}

class _StudentDetailsFormState extends State<StudentDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late List<Map<String, dynamic>> _students = [];

  // Student Detail Controllers
  final _studentNameController = TextEditingController();
  final _studentClassController = TextEditingController();
  final _studentSectionController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _specialInstructionsController = TextEditingController();
  String? editingStudentId;
  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    final userUid = widget.uid;
    final collection = FirebaseFirestore.instance.collection('users').doc(userUid).collection('studentDetails');
    final snapshot = await collection.get();

    // Include document ID in the data
    final students = snapshot.docs.map((doc) => {
      ...doc.data(),
      'id': doc.id, // Include the Firestore document ID
    }).toList();

    setState(() {
      _students = students;
    });
  }
  void _addOrUpdateStudent() {
    if (_formKey.currentState!.validate()) {
      final newStudent = {
        'studentName': _studentNameController.text,
        'studentClass': _studentClassController.text,
        'studentSection': _studentSectionController.text,
        'schoolName': _schoolNameController.text,
        'specialInstructions': _specialInstructionsController.text,
        'id': editingStudentId, // Include the editing ID if present
      };

      if (editingStudentId == null) {
        // Add new student
        setState(() => _students.add(newStudent));
      } else {
        // Update existing student
        final index = _students.indexWhere((student) => student['id'] == editingStudentId);
        if (index != -1) {
          setState(() => _students[index] = newStudent);
        }
      }

      // Clear form and reset editing state
      _resetForm();
    }
  }

  void _resetForm() {
    _studentNameController.clear();
    _studentClassController.clear();
    _studentSectionController.clear();
    _schoolNameController.clear();
    _specialInstructionsController.clear();
    editingStudentId = null; // Reset editing state
  }

  Future<void> _addStudentToFirestore() async {
    try {
      final userUid = widget.uid; // UID of the logged-in user
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('studentDetails');
      print(userUid);
      for (var student in _students) {
        await collection.add(student);
      }
    } catch (e) {
      print(e); // You might want to use a more sophisticated error handling
      // Possibly show an error message to the user
    }
  }
  Future<void> _submitForm() async {
    final userUid = widget.uid;
    final collection = FirebaseFirestore.instance.collection('users').doc(userUid).collection('studentDetails');

    for (var student in _students) {
      if (student.containsKey('id') && student['id'] != null) {
        // Existing student - Update document
        await collection.doc(student['id']).update({
          'studentName': student['studentName'],
          'studentClass': student['studentClass'],
          'studentSection': student['studentSection'],
          'schoolName': student['schoolName'],
          'specialInstructions': student['specialInstructions'],
        });
      } else {
        // New student - Add document
        // Create a new Map from the student and explicitly remove 'id' if it exists
        final Map<String, dynamic> newStudentData = Map<String, dynamic>.from(student)..remove('id');
        await collection.add(newStudentData);
      }
    }

    // After submitting, reset any form state as necessary and navigate away
    _resetFormAndState();
    GoRouter.of(context).go('/home');
  }






  @override
  Widget build(BuildContext context) {
    bool isEditing = editingStudentId != null;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: FlutterFlowTheme.of(context).tertiary,
        automaticallyImplyLeading: false,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Handle the case when you cannot pop
              // For example, navigate to a default route
              GoRouter.of(context).go('/Profile');
            }
          },

          child: Icon(
            Icons.chevron_left_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 32.0,
          ),
        ),
        title: Text(
          'Student Info',
          style: FlutterFlowTheme.of(context).headlineMedium,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var student in _students)
              ListTile(
                title: Text(student['studentName']),
                subtitle: Text('${student['studentClass']} - ${student['studentSection']} \n${student['schoolName']} \n${student['specialInstructions']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          editingStudentId = student['id']; // Assume each student has a unique ID
                          _studentNameController.text = student['studentName'];
                          _studentClassController.text = student['studentClass'];
                          _schoolNameController.text = student['schoolName'];
                          _studentSectionController.text = student['studentSection'];
                          _specialInstructionsController.text =student['specialInstructions'];
                          // Add other fields accordingly
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final bool confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Student'),
                              content: Text('Do you want to delete this student?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        ) ?? false;

                        if (confirmDelete) {
                          // Proceed to delete the student from Firestore and update the state
                          if (student['id'] != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.uid)
                                .collection('studentDetails')
                                .doc(student['id'])
                                .delete();
                          }
                          setState(() {
                            _students.remove(student);
                          });
                        }
                      },
                    ),

                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.all(16), // Adjust the margin as needed
              padding: EdgeInsets.all(16), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the box
                borderRadius: BorderRadius.circular(12), // Border radius of the box
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      controller: _studentNameController,
                      decoration: InputDecoration(labelText: 'Student Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the student\'s name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _schoolNameController,
                      decoration: InputDecoration(labelText: 'School Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the School\'s name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _studentClassController,
                      decoration: InputDecoration(labelText: 'Class'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the class';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _studentSectionController,
                      decoration: InputDecoration(labelText: 'Section'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Section';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _specialInstructionsController,
                      decoration: InputDecoration(labelText: 'Special Instructions'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter NA if there are no instructions';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    // Add more fields here
                    if (!isEditing)
                       FFButtonWidget(
                        onPressed: () async {
                          // String mealPlanId =
                          _addOrUpdateStudent();
                        },
                        text: 'Add Student',
                        options: FFButtonOptions(
                          width: 120.0,
                          height: 30.0,
                          padding:
                          EdgeInsetsDirectional
                              .fromSTEB(24.0, 0.0,
                              24.0, 0.0),
                          iconPadding:
                          EdgeInsetsDirectional
                              .fromSTEB(0.0, 0.0,
                              0.0, 0.0),
                          color: FlutterFlowTheme.of(
                              context)
                              .primary,
                          textStyle: FlutterFlowTheme
                              .of(context)
                              .titleSmall
                              .override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                              16.0),
                        ),
                      ),

                    Builder(
                        builder: (context) {
                          if(!widget.showSkipButton){
                            return Container();
                          }
                          return TextButton(
                            onPressed: () {
                              GoRouter.of(context).go('/home');
                            },
                            child: Text('Skip for Now',),


                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
            if(!isEditing)
              FFButtonWidget(
                onPressed: () async {
                  // Check if any of the text fields are not empty.
                  bool isFormNotEmpty = [
                    _studentNameController.text,
                    _studentClassController.text,
                    _studentSectionController.text,
                    _schoolNameController.text,
                    _specialInstructionsController.text,
                  ].any((element) => element.isNotEmpty);

                  if (isFormNotEmpty && !isEditing) {
                    // If form is not empty and we are not in edit mode, ask the user.
                    bool? addStudent = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Incomplete Form'),
                          content: Text(
                              'You have entered some details. Would you like to add this student?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Clear Form', style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Add Student',
                                  style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        );
                      },
                    );

                    if (addStudent == true) {
                      _addOrUpdateStudent();
                    } else {
                      _resetForm();
                    }
                  } else {
                    // If form is empty or we are in edit mode, submit the form.
                    await _submitForm();
                  }
                },
                text: 'Submit',
                options: FFButtonOptions(
                  width: 120.0,
                  height: 30.0,
                  padding:
                  EdgeInsetsDirectional
                      .fromSTEB(24.0, 0.0,
                      24.0, 0.0),
                  iconPadding:
                  EdgeInsetsDirectional
                      .fromSTEB(0.0, 0.0,
                      0.0, 0.0),
                  color: FlutterFlowTheme.of(
                      context)
                      .primary,
                  textStyle: FlutterFlowTheme
                      .of(context)
                      .titleSmall
                      .override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                      16.0),
                ),
              ),
            if (isEditing)
              FFButtonWidget(
                onPressed: _saveEditedStudent,
                text: 'Save', options: FFButtonOptions(
                width: 120.0,
                height: 30.0,
                padding:
                EdgeInsetsDirectional
                    .fromSTEB(24.0, 0.0,
                    24.0, 0.0),
                iconPadding:
                EdgeInsetsDirectional
                    .fromSTEB(0.0, 0.0,
                    0.0, 0.0),
                color: FlutterFlowTheme.of(
                    context)
                    .primary,
                textStyle: FlutterFlowTheme
                    .of(context)
                    .titleSmall
                    .override(
                  fontFamily: 'Inter',
                  color: Colors.white,
                ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius:
                BorderRadius.circular(
                    16.0),
              ),
                // Button options...
              ),
          ],
        )

      ),
    );
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _studentClassController.dispose();
    _studentSectionController.dispose();
    _schoolNameController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }
  void _saveEditedStudent() async {
    if (_formKey.currentState!.validate()) {
      if (editingStudentId == null) {
        // Handle the case when there is no student ID to update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No student selected to update.'),
          ),
        );
        return;
      }

      final studentToUpdate = {
        'studentName': _studentNameController.text,
        'studentClass': _studentClassController.text,
        'studentSection': _studentSectionController.text,
        'schoolName': _schoolNameController.text,
        'specialInstructions': _specialInstructionsController.text,
        // No need to include 'id' here as it's used for lookup only
      };

      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('studentDetails')
          .doc(editingStudentId)
          .update(studentToUpdate)
          .then((value) {
        // Update the list state
        final index = _students.indexWhere((student) => student['id'] == editingStudentId);
        if (index != -1) {
          setState(() {
            _students[index] = {
              ...studentToUpdate, // Spread in the updated data
              'id': editingStudentId, // Ensure the 'id' field is preserved
            };
          });
        }

        _resetForm(); // This will clear the form and reset editing state
      })
          .catchError((error) {
        print("Failed to update student: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update student.'),
          ),
        );
      });
    }
  }


  void _resetFormAndState() {
    _resetForm(); // Clear form fields.

    // Additionally clear the list if needed, or navigate away.
    if (_students.isEmpty) {
      GoRouter.of(context).go('/home');
    }
  }
}
