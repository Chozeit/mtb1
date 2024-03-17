import 'package:flutter/cupertino.dart';

class CheckoutDetails with ChangeNotifier {
  String fullName;
  String classAndSection;
  String school;
  String phoneNumber;
  String specialInstructions;

  CheckoutDetails({
    required this.fullName,
    required this.classAndSection,
    required this.school,
    required this.phoneNumber,
    required this.specialInstructions,
  });

  void updateDetails({
    String? fullName,
    String? classAndSection,
    String? school,
    String? phoneNumber,
    String? specialInstructions,
  }) {
    if (fullName != null) this.fullName = fullName;
    if (classAndSection != null) this.classAndSection = classAndSection;
    if (school != null) this.school = school;
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (specialInstructions != null) this.specialInstructions = specialInstructions;

    notifyListeners();
  }
}
