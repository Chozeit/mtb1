import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<CartItemTypeStruct> _cart = [];
  List<CartItemTypeStruct> get cart => _cart;
  set cart(List<CartItemTypeStruct> _value) {
    _cart = _value;
  }

  // void addToCart(PlansRecord selectedPlan) {
  //   var newItem = CartItemTypeStruct(
  //     planRef: selectedPlan.reference,
  //     quantity: 1, // or any quantity logic you have
  //     mealPlanId: selectedPlan.mealPlanId, // Ensure this exists in PlansRecord
  //   );
  //   // Directly add newItem to the _cart list
  //   _cart.add(newItem);
  //   notifyListeners(); // Notify listeners about the state change
  // }
// This method now directly accepts a CartItemTypeStruct object.
  void addToCart(CartItemTypeStruct newItem) {
    _cart.add(newItem);
    notifyListeners(); // Notify listeners about the change.
  }



  void removeFromCart(CartItemTypeStruct _value) {
    _cart.remove(_value);
    notifyListeners();
  }

  void removeAtIndexFromCart(int _index) {
    _cart.removeAt(_index);
    notifyListeners();
  }

  void updateCartAtIndex(
    int _index,
    CartItemTypeStruct Function(CartItemTypeStruct) updateFn,
  ) {
    _cart[_index] = updateFn(_cart[_index]);
  }

  void insertAtIndexInCart(int _index, CartItemTypeStruct _value) {
    _cart.insert(_index, _value);
  }

  double _cartSum = 0.0;
  double get cartSum => _cartSum;
  set cartSum(double _value) {
    _cartSum = _value;
  }
}
