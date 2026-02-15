import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/s_s_c_c_card/s_s_c_c_card_widget.dart';
import '/components/scanning/scanning_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/components/test/test_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
    required this.serials,
    required this.serialsitemsCount,
    required this.serialsitemstype,
    required this.serialscartonsCount,
    required this.serialspalletsCount,
  }) : this.product = product ?? 'Pharma A';

  final String product;
  final List<String>? serials;
  final List<int>? serialsitemsCount;
  final List<String>? serialsitemstype;
  final List<int>? serialscartonsCount;
  final List<int>? serialspalletsCount;

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
      for (int loop1Index = 0;
          loop1Index < widget.serials!.length;
          loop1Index++) {
        final currentLoop1Item = widget.serials![loop1Index];
        var confirmDialogResponse = await showDialog<bool>(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text(
                      '${(widget.serialsitemsCount?.elementAtOrNull(loop1Index))?.toString()}|${(widget.serialscartonsCount?.elementAtOrNull(loop1Index))?.toString()}|${(widget.serialspalletsCount?.elementAtOrNull(loop1Index))?.toString()}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext, true),
                      child: Text('Confirm'),
                    ),
                  ],
                );
              },
            ) ??
            false;
        _model.totalCartons = _model.totalCartons +
            valueOrDefault<int>(
              widget.serialscartonsCount?.elementAtOrNull(valueOrDefault<int>(
                loop1Index,
                0,
              )),
              0,
            );
        _model.totalpallets = _model.totalpallets! +
            (widget.serialspalletsCount!.elementAtOrNull(loop1Index))!;
        _model.totalitems = _model.totalitems! +
            (widget.serialsitemsCount!.elementAtOrNull(loop1Index))!;
      }
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
                      pagename: 'Scan',
                      showMenu: () async {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ),
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
                          height: 318.43,
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
                                      final itemsNo = widget.serials!.toList();

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
                                              sscc: (widget.serials!
                                                  .elementAtOrNull(
                                                      itemsNoIndex))!,
                                              itemcount: (widget
                                                  .serialsitemsCount!
                                                  .elementAtOrNull(
                                                      itemsNoIndex))!,
                                              serialtype: (widget
                                                  .serialsitemstype!
                                                  .elementAtOrNull(
                                                      itemsNoIndex))!,
                                              palletcount: (widget
                                                  .serialspalletsCount!
                                                  .elementAtOrNull(
                                                      itemsNoIndex))!,
                                              cartooncount: (widget
                                                  .serialscartonsCount!
                                                  .elementAtOrNull(
                                                      itemsNoIndex))!,
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
                    _model.totalCartons = _model.totalCartons + 1;
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
