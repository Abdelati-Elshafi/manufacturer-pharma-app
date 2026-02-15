import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/s_s_c_c_card/s_s_c_c_card_widget.dart';
import '/components/scanning/scanning_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/components/test/test_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'scan_product_page_widget.dart' show ScanProductPageWidget;
import 'package:flutter/material.dart';

class ScanProductPageModel extends FlutterFlowModel<ScanProductPageWidget> {
  ///  Local state fields for this page.

  List<String> scannedCodes = [];
  void addToScannedCodes(String item) => scannedCodes.add(item);
  void removeFromScannedCodes(String item) => scannedCodes.remove(item);
  void removeAtIndexFromScannedCodes(int index) => scannedCodes.removeAt(index);
  void insertAtIndexInScannedCodes(int index, String item) =>
      scannedCodes.insert(index, item);
  void updateScannedCodesAtIndex(int index, Function(String) updateFn) =>
      scannedCodes[index] = updateFn(scannedCodes[index]);

  bool loadingIsVisable = false;

  /// scan type can be(Item,Case,Pallet)
  String? scanType;

  List<int> noPackForSSCCs = [];
  void addToNoPackForSSCCs(int item) => noPackForSSCCs.add(item);
  void removeFromNoPackForSSCCs(int item) => noPackForSSCCs.remove(item);
  void removeAtIndexFromNoPackForSSCCs(int index) =>
      noPackForSSCCs.removeAt(index);
  void insertAtIndexInNoPackForSSCCs(int index, int item) =>
      noPackForSSCCs.insert(index, item);
  void updateNoPackForSSCCsAtIndex(int index, Function(int) updateFn) =>
      noPackForSSCCs[index] = updateFn(noPackForSSCCs[index]);

  int totalCartons = 0;

  int? totalpallets = 0;

  int? totalitems = 0;

  int? ffffffff = 0;

  ///  State fields for stateful widgets in this page.

  // Model for SideBar component.
  late SideBarModel sideBarModel;
  // Model for Header component.
  late HeaderModel headerModel;
  // Model for test component.
  late TestModel testModel;
  // Models for SSCCCard dynamic component.
  late FlutterFlowDynamicModels<SSCCCardModel> sSCCCardModels;
  // Model for Loading component.
  late LoadingModel loadingModel;
  // Model for Scanning component.
  late ScanningModel scanningModel;
  var code = '';

  @override
  void initState(BuildContext context) {
    sideBarModel = createModel(context, () => SideBarModel());
    headerModel = createModel(context, () => HeaderModel());
    testModel = createModel(context, () => TestModel());
    sSCCCardModels = FlutterFlowDynamicModels(() => SSCCCardModel());
    loadingModel = createModel(context, () => LoadingModel());
    scanningModel = createModel(context, () => ScanningModel());
  }

  @override
  void dispose() {
    sideBarModel.dispose();
    headerModel.dispose();
    testModel.dispose();
    sSCCCardModels.dispose();
    loadingModel.dispose();
    scanningModel.dispose();
  }
}
