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

  void addToCart(CartItemTypeStruct _value, BuildContext context) {
    if (_cart.isNotEmpty) {
      // Assuming each plan has a unique type or identifier that distinguishes it from other items
      // Adjust the condition based on your data model
      if (_cart.any((item) => item == 'plan')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You can only have one plan in the cart."),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
    }
    _cart.add(_value);
    notifyListeners();
  }


  void removeFromCart(CartItemTypeStruct _value) {
    _cart.remove(_value);
  }

  void removeAtIndexFromCart(int _index) {
    _cart.removeAt(_index);
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
