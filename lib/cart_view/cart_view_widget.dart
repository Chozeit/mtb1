import 'package:firebase_auth/firebase_auth.dart';

import '../auth/firebase_auth/auth_util.dart';
import '../checkout/checkout_widget.dart';
import '../payments/payments_widget.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cart_view_model.dart';
export 'cart_view_model.dart';

class CartViewWidget extends StatefulWidget {
  const CartViewWidget({super.key});

  @override
  State<CartViewWidget> createState() => _CartViewWidgetState();
}

class _CartViewWidgetState extends State<CartViewWidget> {
  // Add a map to track the selected student for each plan in the cart.

// Change the type of selectedStudentsPerPlan
  Map<String, Map<String, bool>> selectedStudentsPerPlan = {};


  late CartViewModel _model;
  // bool get isCheckoutEnabled => FFAppState().cart.length == 1;
  // String? get errorMessage => isCheckoutEnabled ? null : 'Please add exactly one plan to the cart before checkout.';
  // bool get isCheckoutEnabled {
  //   // Ensure there are items in the cart.
  //   if (FFAppState().cart.isEmpty) {
  //     return false;
  //   }
  //   // Ensure at most one item per meal plan is added.
  //   final Map<String, int> mealPlanCounts = {};
  //   for (final cartItem in FFAppState().cart) {
  //     final mealPlanId = cartItem.mealPlanId ?? 'unknown';
  //     mealPlanCounts[mealPlanId] = (mealPlanCounts[mealPlanId] ?? 0) + 1;
  //     if (mealPlanCounts[mealPlanId]! > 1) {
  //       return false; // More than one plan of the same type is not allowed.
  //     }
  //     // Check if a valid student is selected for each cart item.
  //     final selectedStudentId = selectedStudentsPerPlan[mealPlanId];
  //     if (selectedStudentId == null || selectedStudentId.isEmpty) {
  //       return false; // No valid student selected, disable checkout.
  //     }
  //   }
  //   // All checks passed, enable checkout.
  //   return true;
  // }



  // Check if any meal plan has more than one item.

  String? get errorMessage {
    if (FFAppState().cart.isEmpty) {
      return 'Your cart is empty.';
    } else if (hasMultiplePlansPerMealPlan) {
      return "Please delete items until one from each meal plan is selected or just one plan.";
    } else if (!allPlansHaveStudentsAssigned) {
      return "Please select students for all plans.";
    }
    return null; // No error.
  }


  final scaffoldKey = GlobalKey<ScaffoldState>();
  void navigateToCheckout(BuildContext context) {
    // Check if the cart has more than one item or no items at all.
    if (!isCheckoutEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please add exactly one plan to the cart before checkout."),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Assuming every item in the cart is a plan, this checks if there's exactly one.
    // Adjust this if there are other types of items that might be added to the cart.
    final isOnlyPlansInCart = FFAppState().cart.every((item) => item.planRef != null);

    if (!isOnlyPlansInCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Only plans can be checked out."),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Navigate to checkout if the conditions are met.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentsWidget()),

    );
  }
  bool get hasMultiplePlansPerMealPlan {
    final mealPlanCounts = <String, int>{};
    for (final item in FFAppState().cart) {
      final mealPlanId = item.mealPlanId ?? 'unknown';
      mealPlanCounts[mealPlanId] = (mealPlanCounts[mealPlanId] ?? 0) + 1;
    }
    return mealPlanCounts.values.any((count) => count > 1);
  }

  bool get allPlansHaveStudentsAssigned {
    for (final cartItem in FFAppState().cart) {
      final selectedStudent = selectedStudentsPerPlan[cartItem.mealPlanId];
      if (selectedStudent == null || selectedStudent.isEmpty) {
        return false;
      }
    }
    return true;
  }
  bool get isCheckoutEnabled => !hasMultiplePlansPerMealPlan && allPlansHaveStudentsAssigned;

  List<Map<String, dynamic>> students = [];

  Future<void> _fetchStudents() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    final studentDetailsRef = FirebaseFirestore.instance.collection('users').doc(userUid).collection('studentDetails');
    final snapshot = await studentDetailsRef.get();
    final fetchedStudents = snapshot.docs.map((doc) => {
      'name': doc.data()['studentName'] ?? 'Unnamed Student',
      'id': doc.id
    }).toList();

    setState(() {
      students = fetchedStudents;
    });
  }
  Future<void> _showSelectStudentsDialog(String mealPlanId) async {
    final tempSelectedStudents = Map<String, bool>.from(selectedStudentsPerPlan[mealPlanId] ?? {});

    final result = await showDialog<Map<String, bool>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Students'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: students.map((student) {
                    return CheckboxListTile(
                      value: tempSelectedStudents[student['id']] ?? false,
                      title: Text(student['name']),
                      onChanged: (bool? value) {
                        setState(() {
                          tempSelectedStudents[student['id']] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(tempSelectedStudents);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedStudentsPerPlan[mealPlanId] = result;
        recalculateTotalCartPrice();
      });
    }
  }




  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartViewModel());
    _fetchStudents();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      FFAppState().cart.forEach((cartItem) {
        selectedStudentsPerPlan[cartItem.mealPlanId ?? 'unknown'];
      });
    }));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<FFAppState>(context);
    final isMultiplePlansPerMealPlan = hasMultiplePlansPerMealPlan;
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }


    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).tertiary,
          automaticallyImplyLeading: false,

          title: Text(
            'My Cart',
            style: FlutterFlowTheme.of(context).displaySmall,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Below are the items in your cart.',
                        style: FlutterFlowTheme.of(context).labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Builder(
                        builder: (context) {
                          final cartItem = FFAppState().cart.toList();
                          if (hasMultiplePlansPerMealPlan)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Please delete items until one from each meal plan is selected or just one plan.",
                                style: TextStyle(color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            );
                          return  ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: cartItem.length,
                              itemBuilder: (context, cartItemIndex) {
                                final cartItemItem = cartItem[cartItemIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 20.0, 0.0),
                                  child: StreamBuilder<PlansRecord>(
                                    stream: PlansRecord.getDocument(
                                        cartItemItem.planRef!),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 70.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final containerPlansRecord = snapshot.data!;
                                      return Container(
                                        width: 450,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x320E151B),
                                              offset: Offset(0.0, 1.0),
                                            )
                                          ],
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              12.0, 8.0, 8.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Hero(
                                                tag: containerPlansRecord.image,
                                                transitionOnUserGestures: true,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(12.0),
                                                  child: Image.network(
                                                    containerPlansRecord.image,
                                                    width: 80.0,
                                                    height: 80.0,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      12.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0,
                                                            0.0,
                                                            0.0,
                                                            8.0),
                                                        child: Text(
                                                          containerPlansRecord
                                                              .item,
                                                          style:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .titleLarge,
                                                        ),
                                                      ),
                                                      Text(
                                                        formatNumber(
                                                          containerPlansRecord
                                                              .price,
                                                          formatType:
                                                          FormatType.custom,
                                                          currency: '₹',
                                                          format: '',
                                                          locale: '',
                                                        ),
                                                        style:
                                                        FlutterFlowTheme.of(
                                                            context)
                                                            .labelMedium,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0,
                                                            8.0,
                                                            0.0,
                                                            0.0),
                                                        child: Text(
                                                          'Quantity:${cartItemItem.quantity.toString()}',
                                                          style:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .labelSmall,
                                                        ),
                                                      ),
                                                      if (!hasMultiplePlansPerMealPlan)
                                                      //   DropdownButton<String>(
                                                      //   value: selectedStudentsPerPlan[cartItemItem.mealPlanId] ?? '',
                                                      //   items: [
                                                      //     DropdownMenuItem(
                                                      //       child: Text('Select a student'),
                                                      //       value: '',
                                                      //     ),
                                                      //     DropdownMenuItem(
                                                      //       child: Text('All'),
                                                      //       value: 'all',
                                                      //     ),
                                                      //     ...students.map((student) {
                                                      //       return DropdownMenuItem<String>(
                                                      //         child: Text(student['name']),
                                                      //         value: student['id'],
                                                      //       );
                                                      //     }).toList(),
                                                      //
                                                      //   ],
                                                      //   onChanged:  hasMultiplePlansPerMealPlan ? null : (String? newValue){
                                                      //     setState(() {
                                                      //       selectedStudentsPerPlan[cartItemItem.mealPlanId!] = newValue ?? '';
                                                      //       cartItemItem.selectedStudentId = newValue;
                                                      //       if (newValue == '') {
                                                      //         cartItemItem.totalPrice = 0;
                                                      //       } else {
                                                      //         double pricePerUnit = containerPlansRecord.price;
                                                      //         int studentMultiplier = newValue == 'all' ? students.length : (newValue != '' ? 1 : 0);
                                                      //         cartItemItem.totalPrice = pricePerUnit * cartItemItem.quantity! * studentMultiplier;
                                                      //       }
                                                      //
                                                      //       recalculateTotalCartPrice(); // Recalculate after changing the selection
                                                      //     });
                                                      //   },
                                                      //   onTap: hasMultiplePlansPerMealPlan ? () {
                                                      //     ScaffoldMessenger.of(context).showSnackBar(
                                                      //       SnackBar(
                                                      //         content: Text("Please delete items until one from each meal plan is selected or just one plan."),
                                                      //       ),
                                                      //     );
                                                      //   } : null,
                                                      // ),
                                                        Column(
                                                          children: [
                                                            TextButton(
                                                              onPressed: () => _showSelectStudentsDialog(cartItemItem.mealPlanId!),
                                                              child: Text('Select Students'),

                                                            ),
                                                            _buildSelectedStudentsList(cartItemItem.mealPlanId!),
                                                          ],
                                                        )


                                                    ],
                                                  ),
                                                ),
                                              ),

                                              FlutterFlowIconButton(
                                                borderColor: Colors.transparent,
                                                borderRadius: 30.0,
                                                borderWidth: 1.0,
                                                buttonSize: 40.0,
                                                icon: Icon(
                                                  Icons.delete_outline_rounded,
                                                  color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                                  size: 20.0,
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    FFAppState().removeAtIndexFromCart(cartItemIndex);
                                                    recalculateTotalCartPrice(); // Recalculate after removing an item
                                                  });
                                                },
                                              ),

                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                        },
                      ),
                    ),
                    // In your body, where you want to show the breakdown:

                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 16.0, 24.0, 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 4.0, 24.0, 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Total',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                    ),
                                    FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30.0,
                                      borderWidth: 1.0,
                                      buttonSize: 36.0,
                                      icon: Icon(
                                        Icons.info_outlined,
                                        color: Color(0xFF57636C),
                                        size: 18.0,
                                      ),
                                      onPressed: () {
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  formatNumber(
                                    FFAppState().cartSum,
                                    formatType: FormatType.custom,
                                    currency: '₹',
                                    format: '',
                                    locale: '',
                                  ),
                                  style:
                                  FlutterFlowTheme.of(context).displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<Widget>(
                      future: _buildPriceBreakdown(),
                      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Here you can show a loading spinner or some sort of progress indicator
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // If we run into an error, we can display it here
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          // When data is received, return the actual widget
                          return snapshot.data!;
                        } else {
                          // In case we have null data, display an empty Container or some placeholder
                          return Container();
                        }
                      },
                    ),

                  ],

                ),
              ),
            ),
            if (errorMessage != null) // Conditionally display an error message
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: isCheckoutEnabled ? () => navigateToCheckout(context) : null,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: /*FlutterFlowTheme.of(context).primary,*/
                  !isCheckoutEnabled || hasMultiplePlansPerMealPlan ? Colors.grey : FlutterFlowTheme.of(context).primary,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x320E151B),
                      offset: Offset(0.0, -2.0),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  onTap: isCheckoutEnabled
                      ? () => navigateToCheckout(context)
                      : null, // Prevents the button action when the cart is empty
                  child: Center(
                    child: Text(
                      'Checkout(${formatNumber(
                        FFAppState().cartSum,
                        formatType: FormatType.custom,
                        currency: '₹',
                        format: '',
                        locale: '',
                      )})',
                      style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                        color: isCheckoutEnabled ? Colors.white : Colors.black, // Change text color based on isCheckoutEnabled
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> recalculateTotalCartPrice() async {
    double newTotal = 0.0;
    for (var cartItem in FFAppState().cart) {
      final mealPlanId = cartItem.mealPlanId;

      if (mealPlanId == null) continue;

      final studentSelections = selectedStudentsPerPlan[mealPlanId];
      if (studentSelections == null) continue;

      int selectedCount = studentSelections.values.where((selected) => selected).length;

      // Fetch the price per unit from the PlansRecord linked to this cart item.
      double pricePerUnit = await fetchPriceForMealPlan(cartItem.planRef);

      double totalPriceForItem = pricePerUnit * (cartItem.quantity ?? 1) * selectedCount;
      newTotal += totalPriceForItem;
    }

    setState(() {
      FFAppState().cartSum = newTotal;
    });
  }


// Mock implementation, replace with actual logic to retrieve unit price
  Future<double> fetchPriceForMealPlan(DocumentReference? planRef) async {
    if (planRef == null) return 0.0;
    final docSnapshot = await planRef.get();
    final planData = docSnapshot.data() as Map<String, dynamic>?;

    return planData?['price'] ?? 0.0;
  }





  // Before your return statement in the build method, create a breakdown widget list
  List<Widget> priceBreakdownWidgets = FFAppState().cart.map((cartItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${cartItem.mealPlanId ?? 'Unknown Plan'} x ${cartItem.quantity} ='),
          Text('₹${cartItem.totalPrice?.toStringAsFixed(2) ?? '0.00'}'),
        ],
      ),
    );
  }).toList();

  Future<Widget> _buildPriceBreakdown() async {
    List<Widget> breakdownItems = [];

    for (var cartItem in FFAppState().cart) {
      final mealPlanId = cartItem.mealPlanId;
      if (mealPlanId == null) continue;

      // Fetch the price per unit from the PlansRecord linked to this cart item.
      double pricePerUnit = await fetchPriceForMealPlan(cartItem.planRef);

      // Fetch the number of selected students for this cart item.
      final studentSelections = selectedStudentsPerPlan[mealPlanId];
      int selectedCount = studentSelections?.values.where((selected) => selected).length ?? 0;

      double totalPriceForItem = pricePerUnit * (cartItem.quantity ?? 1) * selectedCount;

      String studentAssignmentText = selectedCount > 1 ? '$selectedCount Students' : '1 Student';

      breakdownItems.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$mealPlanId ($studentAssignmentText) x ${cartItem.quantity}'),
              Text('₹${totalPriceForItem.toStringAsFixed(2)}'),
            ],
          ),
        ),
      );
    }

    // Total price
    breakdownItems.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('₹${FFAppState().cartSum.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );

    return Column(children: breakdownItems);
  }

  Widget _buildSelectedStudentsList(String mealPlanId) {
    final selections = selectedStudentsPerPlan[mealPlanId];
    if (selections == null || selections.isEmpty) {
      return Text('No students selected');
    }

    final selectedStudentsNames = students.where((student) => selections[student['id']] ?? false)
        .map((student) => student['name'])
        .join(', ');

    return Text(selectedStudentsNames);
  }

}