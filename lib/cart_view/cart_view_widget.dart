import '../checkout/checkout_widget.dart';
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
  late CartViewModel _model;
  // bool get isCheckoutEnabled => FFAppState().cart.length == 1;
  // String? get errorMessage => isCheckoutEnabled ? null : 'Please add exactly one plan to the cart before checkout.';
  bool get isCheckoutEnabled {
    if (FFAppState().cart.isEmpty) {
      return false;
    }
    // Count items per meal plan.
    final Map<String, int> mealPlanCounts = {};
    for (final cartItem in FFAppState().cart) {
      final mealPlanId = cartItem.mealPlanId ?? 'unknown';
      mealPlanCounts[mealPlanId] = (mealPlanCounts[mealPlanId] ?? 0) + 1;
    }

    // Enable checkout if there's at most one item per meal plan.
    return mealPlanCounts.values.every((count) => count == 1);
  }


    // Check if any meal plan has more than one item.

  String? get errorMessage {
    if (FFAppState().cart.isEmpty) {
      return 'Your cart is empty.';
    }
    if (!isCheckoutEnabled) {
      return 'You can only add one plan from each meal plan.';
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
      MaterialPageRoute(builder: (context) => CheckoutWidget()),

    );
  }


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Below are the items in your cart.',
                        style: FlutterFlowTheme.of(context).labelMedium,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Builder(
                        builder: (context) {
                          final cartItem = FFAppState().cart.toList();
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: cartItem.length,
                            itemBuilder: (context, cartItemIndex) {
                              final cartItemItem = cartItem[cartItemIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 0.0),
                                child: StreamBuilder<PlansRecord>(
                                  stream: PlansRecord.getDocument(
                                      cartItemItem.planRef!),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
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
                                      width: double.infinity,
                                      height: 160.0,
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
                                                  FFAppState()
                                                      .removeAtIndexFromCart(
                                                          cartItemIndex);
                                                  FFAppState().cartSum =
                                                      FFAppState().cartSum +
                                                          containerPlansRecord
                                                                  .price *
                                                              -1;
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
                  isCheckoutEnabled ? FlutterFlowTheme.of(context).primary : Colors.grey,
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
}
