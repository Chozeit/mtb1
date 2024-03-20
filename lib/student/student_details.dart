import 'package:flutter/material.dart';
import 'package:mtb1/flutter_flow/flutter_flow_util.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class StudentDetailsForm extends StatefulWidget {
  @override
  _StudentDetailsFormState createState() => _StudentDetailsFormState();
}

class _StudentDetailsFormState extends State<StudentDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _students = [];

  // Student Detail Controllers
  final _studentNameController = TextEditingController();
  final _studentClassController = TextEditingController();
  final _studentSectionController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _specialInstructionsController = TextEditingController();

  void _addStudent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _students.add({
          'studentName': _studentNameController.text,
          'studentClass': _studentClassController.text,
          'studentSection': _studentSectionController.text,
          'schoolName': _schoolNameController.text,
          'specialInstructions': _specialInstructionsController.text,
        });
        _studentNameController.clear();
        _studentClassController.clear();
        _studentSectionController.clear();
        _schoolNameController.clear();
        _specialInstructionsController.clear();
      });
    }
  }

  void _submitForm() {
    if (_students.isNotEmpty) {
      // TODO: Replace with your submit logic
      // UserService().addStudentToUser(userId, _students);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            context.pop();
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              for (var student in _students)
                ListTile(
                  title: Text(student['studentName']),
                  subtitle: Text('${student['studentClass']} - ${student['studentSection']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _students.remove(student);
                      });
                    },
                  ),
                ),
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
                controller: _studentClassController,
                decoration: InputDecoration(labelText: 'Class'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the class';
                  }
                  return null;
                },
              ),
              // Add more fields here
              FFButtonWidget(
                onPressed: () async {
                  // String mealPlanId =
                  _addStudent();
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
              FFButtonWidget(
                onPressed: () async {
                  // String mealPlanId =
                  _submitForm();
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
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go('/home');
                },
                child: Text('Skip for Now',),


              ),
            ],
          ),
        ),
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
}
