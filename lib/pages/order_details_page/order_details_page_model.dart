import '/backend/api_requests/api_calls.dart';
import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'order_details_page_widget.dart' show OrderDetailsPageWidget;
import 'package:flutter/material.dart';

class OrderDetailsPageModel extends FlutterFlowModel<OrderDetailsPageWidget> {
  ///  Local state fields for this page.

  List<String> products = [];
  void addToProducts(String item) => products.add(item);
  void removeFromProducts(String item) => products.remove(item);
  void removeAtIndexFromProducts(int index) => products.removeAt(index);
  void insertAtIndexInProducts(int index, String item) =>
      products.insert(index, item);
  void updateProductsAtIndex(int index, Function(String) updateFn) =>
      products[index] = updateFn(products[index]);

  bool loadingIsVisable = false;

  /// scan type can be(Item,Case,Pallet)
  String? scanType;

  List<int> scannedqtys = [];
  void addToScannedqtys(int item) => scannedqtys.add(item);
  void removeFromScannedqtys(int item) => scannedqtys.remove(item);
  void removeAtIndexFromScannedqtys(int index) => scannedqtys.removeAt(index);
  void insertAtIndexInScannedqtys(int index, int item) =>
      scannedqtys.insert(index, item);
  void updateScannedqtysAtIndex(int index, Function(int) updateFn) =>
      scannedqtys[index] = updateFn(scannedqtys[index]);

  List<int> requiredqtys = [];
  void addToRequiredqtys(int item) => requiredqtys.add(item);
  void removeFromRequiredqtys(int item) => requiredqtys.remove(item);
  void removeAtIndexFromRequiredqtys(int index) => requiredqtys.removeAt(index);
  void insertAtIndexInRequiredqtys(int index, int item) =>
      requiredqtys.insert(index, item);
  void updateRequiredqtysAtIndex(int index, Function(int) updateFn) =>
      requiredqtys[index] = updateFn(requiredqtys[index]);

  List<String> gtins = [];
  void addToGtins(String item) => gtins.add(item);
  void removeFromGtins(String item) => gtins.remove(item);
  void removeAtIndexFromGtins(int index) => gtins.removeAt(index);
  void insertAtIndexInGtins(int index, String item) =>
      gtins.insert(index, item);
  void updateGtinsAtIndex(int index, Function(String) updateFn) =>
      gtins[index] = updateFn(gtins[index]);

  String? customer;

  String? gln;

  String? sscc;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetOrderDetails)] action in OrderDetailsPage widget.
  ApiCallResponse? ordersDetails;
  // Model for SideBar component.
  late SideBarModel sideBarModel;
  // Model for Header component.
  late HeaderModel headerModel;
  // Model for Loading component.
  late LoadingModel loadingModel;

  @override
  void initState(BuildContext context) {
    sideBarModel = createModel(context, () => SideBarModel());
    headerModel = createModel(context, () => HeaderModel());
    loadingModel = createModel(context, () => LoadingModel());
  }

  @override
  void dispose() {
    sideBarModel.dispose();
    headerModel.dispose();
    loadingModel.dispose();
  }
}
