import '/backend/api_requests/api_calls.dart';
import '/components/loading/loading_widget.dart';
import '/components/s_s_c_c_card/s_s_c_c_card_widget.dart';
import '/components/scanning/scanning_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/components/test/test_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan_product_page_model.dart';
export 'scan_product_page_model.dart';

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
class ScanProductPageWidget extends StatefulWidget {
  const ScanProductPageWidget({
    super.key,
    String? product,
    required this.orderno,
    required this.gtin,
  }) : this.product = product ?? 'Pharma A';

  final String product;
  final String? orderno;
  final String? gtin;

  static String routeName = 'ScanProductPage';
  static String routePath = '/scanProductPage';

  @override
  State<ScanProductPageWidget> createState() => _ScanProductPageWidgetState();
}

class _ScanProductPageWidgetState extends State<ScanProductPageWidget> {
  late ScanProductPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanProductPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.loadingIsVisable = true;
      safeSetState(() {});
      _model.productdetails =
          await OrdersAPIsGroup.productSerialsDetailsCall.call(
        orderNo: widget.orderno,
        gtin: widget.gtin,
        sscc: '0',
      );

      if ((_model.productdetails?.succeeded ?? true)) {
        _model.scannedCodes = OrdersAPIsGroup.productSerialsDetailsCall
            .serial(
              (_model.productdetails?.jsonBody ?? ''),
            )!
            .toList()
            .cast<String>();
        safeSetState(() {});
      }
      for (int loop1Index = 0;
          loop1Index < _model.scannedCodes.length;
          loop1Index++) {
        final currentLoop1Item = _model.scannedCodes[loop1Index];
        _model.totalCartons = _model.totalCartons +
            OrdersAPIsGroup.productSerialsDetailsCall.totalCartons(
              (_model.productdetails?.jsonBody ?? ''),
            )!;
        _model.totalpallets = _model.totalpallets! +
            OrdersAPIsGroup.productSerialsDetailsCall.totalPallets(
              (_model.productdetails?.jsonBody ?? ''),
            )!;
        _model.totalitems = _model.totalitems! +
            OrdersAPIsGroup.productSerialsDetailsCall.totalItems(
              (_model.productdetails?.jsonBody ?? ''),
            )!;
      }
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                        child: wrapWithModel(
                          model: _model.testModel,
                          updateCallback: () => safeSetState(() {}),
                          child: TestWidget(
                            totalPallets: _model.totalpallets!,
                            totalCartons: _model.totalCartons,
                            totalItems: _model.totalitems!,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                        color: Color(0xFFE0E3E7),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                        child: Container(
                          width: double.infinity,
                          height: 394.29,
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
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Builder(
                                    builder: (context) {
                                      final itemsNo =
                                          _model.scannedCodes.toList();

                                      return ListView.separated(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: itemsNo.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 2.0),
                                        itemBuilder: (context, itemsNoIndex) {
                                          final itemsNoItem =
                                              itemsNo[itemsNoIndex];
                                          return wrapWithModel(
                                            model:
                                                _model.sSCCCardModels.getModel(
                                              itemsNoItem,
                                              itemsNoIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: SSCCCardWidget(
                                              key: Key(
                                                'Keyy0n_${itemsNoItem}',
                                              ),
                                              sscc: _model.scannedCodes
                                                  .elementAtOrNull(
                                                      itemsNoIndex)!,
                                              itemcount: 9,
                                              serialtype: 'Case',
                                              palletcount: 9,
                                              cartooncount: 9,
                                              delete: () async {
                                                _model.removeFromScannedCodes(
                                                    itemsNoItem);
                                                safeSetState(() {});
                                              },
                                            ),
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
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            await _model.backToOrderDetailesPage(
                              context,
                              orderno: widget.orderno,
                              customer: '999',
                            );
                          },
                          text: 'Cancel ',
                          icon: Icon(
                            Icons.cancel_rounded,
                            size: 25.0,
                          ),
                          options: FFButtonOptions(
                            width: 160.0,
                            height: 50.0,
                            padding: EdgeInsets.all(8.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFFD32F2F),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      Flexible(
                        child: FFButtonWidget(
                          onPressed: () {
                            print('ConfirmButton pressed ...');
                          },
                          text: 'Update',
                          icon: Icon(
                            Icons.upload_sharp,
                            size: 25.0,
                          ),
                          options: FFButtonOptions(
                            width: 160.0,
                            height: 50.0,
                            padding: EdgeInsets.all(8.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFFD32F2F),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ],
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
            if (true)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                child: wrapWithModel(
                  model: _model.scanningModel,
                  updateCallback: () => safeSetState(() {}),
                  child: ScanningWidget(
                    qraction: (scanType) async {
                      var confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('hjk'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        alertDialogContext, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext, true),
                                    child: Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;
                      _model.scannedCode = await _model.checkAndAddSerial(
                        context,
                        serial: '111',
                        list: _model.scannedCodes,
                      );
                      _model.addToScannedCodes(_model.scannedCode!);
                      safeSetState(() {});
                      _model.addToNoPackForSSCCs(10);
                      safeSetState(() {});
                      _model.totalCartons = _model.totalCartons + 1;
                      safeSetState(() {});
                      _model.scanType = scanType;
                      safeSetState(() {});

                      safeSetState(() {});
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
