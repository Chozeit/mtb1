import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_util.dart'; // Make sure this import is correct for your project structure

class CartIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartItemCount = Provider.of<FFAppState>(context).cart.length; // Access cart items count

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => GoRouter.of(context).go('/cartView'), // Adjust the route as necessary
        ),
        if (cartItemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$cartItemCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
