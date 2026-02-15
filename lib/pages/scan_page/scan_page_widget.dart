import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/order_data/order_data_widget.dart';
import '/components/s_s_c_c_card/s_s_c_c_card_widget.dart';
import '/components/scanning/scanning_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/components/test/test_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'scan_page_model.dart';
export 'scan_page_model.dart';

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
class ScanPageWidget extends StatefulWidget {
  const ScanPageWidget({
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

  static String routeName = 'ScanPage';
  static String routePath = '/scanPage';

  @override
  State<ScanPageWidget> createState() => _ScanPageWidgetState();
}

class _ScanPageWidgetState extends State<ScanPageWidget> {
  late ScanPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanPageModel());
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
                      pagename: 'Scan & Validation',
                      showMenu: () async {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120.0,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: wrapWithModel(
                            model: _model.orderDataModel,
                            updateCallback: () => safeSetState(() {}),
                            child: OrderDataWidget(
                              orderNo: widget.orderNO!,
                              batchNo: widget.batchNo!,
                              customer: widget.customer!,
                              quantity: widget.quantity!,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                        child: wrapWithModel(
                          model: _model.testModel,
                          updateCallback: () => safeSetState(() {}),
                          child: TestWidget(
                            totalPallets: 0,
                            totalCartons: 0,
                            totalItems: 0,
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
                          height: 160.0,
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
                                                'Keyy74_${itemsNoItem}',
                                              ),
                                              sscc: _model.scannedCodes
                                                  .elementAtOrNull(
                                                      itemsNoIndex)!,
                                              itemcount: 20,
                                              serialtype: '0',
                                              palletcount: 0,
                                              cartooncount: 0,
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
              wrapWithModel(
                model: _model.scanningModel,
                updateCallback: () => safeSetState(() {}),
                child: ScanningWidget(
                  qraction: (scanType) async {
                    _model.code = await FlutterBarcodeScanner.scanBarcode(
                      '#C62828', // scanning line color
                      'Cancel', // cancel button text
                      true, // whether to show the flash icon
                      ScanMode.QR,
                    );

                    _model.addToScannedCodes(_model.code);
                    safeSetState(() {});
                    _model.addToNoPackForSSCCs(10);
                    safeSetState(() {});
                    _model.totalCases = _model.totalCases + 1;
                    safeSetState(() {});
                    _model.scanType = scanType;
                    safeSetState(() {});

                    safeSetState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
