import '/backend/api_requests/api_calls.dart';
import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/product_details_card/product_details_card_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_details_page_model.dart';
export 'order_details_page_model.dart';

/// Create a mobile page named "Scan & Validate" for PharmaApp (EN/AR).
///
/// Purpose: scan product barcodes/serials for a selected order and validate
/// them against order lines.
///
/// Layout:
/// - Top AppBar: back button, page title "Scan & Validate" + small order id
/// subtitle.
/// - Order summary card: Order No, Customer, Branch, Total items, Total
/// expected serials, Progress text "Scanned X / Y" and a progress bar.
/// - Large camera scanner area with rounded rectangle overlay, flash toggle,
/// camera switch, and a manual entry button. When camera active show live
/// preview.
/// - Below scanner: searchable ListView of order lines. Each line row:
/// product name + GTIN, batch, expiry, required qty, scanned qty badge,
/// status icon (green/red). Expand row to show scanned serials list.
/// - Sticky bottom bar: Left: current scanned count; Right: primary CTA
/// "Complete Order" (disabled until required scanned OR show "Force Complete"
/// with reason modal).
/// Interactions & logic:
/// - Page accepts param `orderId` (fetch order details & lines on load).
/// - On barcode scanned: parse barcode (support GS1 AIs if present). Find
/// matching order line by GTIN/batch/serial; if match and not duplicate ->
/// add to `scannedItems` state, increase scanned count, call API POST
/// /validateSerial {orderId, lineId, serial} -> show inline success toast. If
/// invalid -> show modal with reason + option to add to quarantine list.
/// - Provide manual-add flow (input field to type/paste code).
/// - Support device-specific scanning: if running on Zebra device use
/// DataWedge intent integration; otherwise use camera scanner (custom widget
/// e.g., MultiBarcodeScanner using mobile_scanner).
/// - Localization: all labels available in EN and AR. Use soft rounded cards,
/// subtle shadows, primary color consistent with app.
class OrderDetailsPageWidget extends StatefulWidget {
  const OrderDetailsPageWidget({
    super.key,
    required this.orderNO,
    required this.customer,
    required this.batchNo,
    required this.quantity,
  });

  final String? orderNO;
  final String? customer;
  final String? batchNo;
  final String? quantity;

  static String routeName = 'OrderDetailsPage';
  static String routePath = '/orderDetailsPage';

  @override
  State<OrderDetailsPageWidget> createState() => _OrderDetailsPageWidgetState();
}

class _OrderDetailsPageWidgetState extends State<OrderDetailsPageWidget> {
  late OrderDetailsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderDetailsPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.loadingIsVisable = true;
      safeSetState(() {});
      _model.ordersDetails = await OrdersAPIsGroup.getOrderDetailsCall.call(
        orderNO: widget.orderNO,
      );

      _model.products = OrdersAPIsGroup.getOrderDetailsCall
          .productsName(
            (_model.ordersDetails?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      _model.scannedqtys = OrdersAPIsGroup.getOrderDetailsCall
          .scannedQtys(
            (_model.ordersDetails?.jsonBody ?? ''),
          )!
          .toList()
          .cast<int>();
      _model.requiredqtys = OrdersAPIsGroup.getOrderDetailsCall
          .requiredQtys(
            (_model.ordersDetails?.jsonBody ?? ''),
          )!
          .toList()
          .cast<int>();
      _model.gtins = OrdersAPIsGroup.getOrderDetailsCall
          .gTINs(
            (_model.ordersDetails?.jsonBody ?? ''),
          )!
          .toList()
          .cast<String>();
      _model.customer = OrdersAPIsGroup.getOrderDetailsCall.customer(
        (_model.ordersDetails?.jsonBody ?? ''),
      );
      _model.gln = OrdersAPIsGroup.getOrderDetailsCall.gln(
        (_model.ordersDetails?.jsonBody ?? ''),
      );
      _model.sscc = OrdersAPIsGroup.getOrderDetailsCall.sscc(
        (_model.ordersDetails?.jsonBody ?? ''),
      );
      safeSetState(() {});
      _model.loadingIsVisable = false;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.sideBarModel,
            updateCallback: () => safeSetState(() {}),
            child: SideBarWidget(
              pageName: 'ScanPage',
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.headerModel,
                    updateCallback: () => safeSetState(() {}),
                    child: HeaderWidget(
                      pagename: '#${widget.orderNO}',
                      showMenu: () async {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8.0,
                                  color: Color(0x1A000000),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          widget.orderNO,
                                          '#123456',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Customer:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          _model.customer,
                                          'G',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Destination GLN:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          _model.gln,
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order SSCC:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          _model.sscc,
                                          'g',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF14181B),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Products in Order',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF323394),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 385.58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8.0,
                                      color: Color(0x1A000000),
                                      offset: Offset(
                                        0.0,
                                        2.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final itemNo = _model.products.toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: itemNo.length,
                                      itemBuilder: (context, itemNoIndex) {
                                        final itemNoItem = itemNo[itemNoIndex];
                                        return ProductDetailsCardWidget(
                                          key: Key(
                                              'Keyib2_${itemNoIndex}_of_${itemNo.length}'),
                                          productname: _model.products
                                              .elementAtOrNull(itemNoIndex)!,
                                          gtin: _model.gtins
                                              .elementAtOrNull(itemNoIndex)!,
                                          requiredqty: _model.requiredqtys
                                              .elementAtOrNull(itemNoIndex)!,
                                          scannedqty: _model.scannedqtys
                                              .elementAtOrNull(itemNoIndex)!,
                                          orderNo: widget.orderNO!,
                                          viewloadingcontrol: (view) async {
                                            _model.loadingIsVisable = view;
                                            safeSetState(() {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ].divide(SizedBox(height: 24.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_model.loadingIsVisable)
              wrapWithModel(
                model: _model.loadingModel,
                updateCallback: () => safeSetState(() {}),
                child: LoadingWidget(),
              ),
          ],
        ),
      ),
    );
  }
}
