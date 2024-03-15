import 'package:firebase_auth/firebase_auth.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'orders_model.dart';
export 'orders_model.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late OrdersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdersModel());

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
            'Your Orders',
            style: FlutterFlowTheme.of(context).headlineMedium,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Your recent orders',
                      style: FlutterFlowTheme.of(context).labelMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: StreamBuilder<List<OrdersRecord>>(
                  stream: OrdersRecord.queryUserOrders(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots()
                      .map((list) => list.docs
                      .map((doc) => OrdersRecord.fromSnapshot(doc))
                      .toList()),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    List<OrdersRecord> listViewOrdersRecordList =
                        snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listViewOrdersRecordList.length,
                      itemBuilder: (context, listViewIndex) {
                        final listViewOrdersRecord = listViewOrdersRecordList[listViewIndex];

                        return FutureBuilder<DocumentSnapshot>(
                          future: listViewOrdersRecord.items.first.planRef?.get(),
                          builder: (context, planSnapshot) {
                            if (planSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (planSnapshot.hasError) {
                              return Center(child: Text('Error: ${planSnapshot.error}'));
                            }
                            if (!planSnapshot.hasData || planSnapshot.data == null) {
                              return Center(child: Text('Document does not exist.'));
                            }


                              final planDetails = PlansRecord.fromSnapshot(planSnapshot.data!);
                              // Continue building your widget using planDetails...

                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Color(0x411D2429),
                                      offset: Offset(0.0, 1.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 1.0, 1.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6.0),
                                          child: Image.network(
                                            planDetails.image.isNotEmpty ? planDetails.image : 'https://via.placeholder.com/80', // Placeholder image
                                            width: 80.0,
                                            height: 80.0,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              // This builder handles any errors loading the image, such as if the image cannot be found at the URL
                                              return Icon(Icons.error); // You can return an error icon or any other widget if the image fails to load
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 4.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                planDetails.item, // Use the plan name here
                                                style: FlutterFlowTheme.of(context).headlineSmall,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 0.0),
                                                child: AutoSizeText(
                                                  'Status: ${listViewOrdersRecord.status}', // Display the order status
                                                  style: FlutterFlowTheme.of(context).labelMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 4.0, 8.0),
                                        child: Text(
                                          dateTimeFormat('MMMEd', listViewOrdersRecord.timestamp!),
                                          textAlign: TextAlign.end,
                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );


                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
