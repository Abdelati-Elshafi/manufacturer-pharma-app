import '/backend/api_requests/api_calls.dart';
import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'shipment_page_widget.dart' show ShipmentPageWidget;
import 'package:flutter/material.dart';

class ShipmentPageModel extends FlutterFlowModel<ShipmentPageWidget> {
  ///  Local state fields for this page.

  String? shipmentScanedsscc;

  String? orderno;

  String? ssccState;

  String? bath;

  String? customers;

  String? totolitems;

  bool loadingisvisable = false;

  ///  State fields for stateful widgets in this page.

  // Model for Header component.
  late HeaderModel headerModel;
  // State field(s) for OrdersDropDown widget.
  String? ordersDropDownValue;
  FormFieldController<String>? ordersDropDownValueController;
  // Stores action output result for [Backend Call - API (GetOrderDetails)] action in OrdersDropDown widget.
  ApiCallResponse? getOrderDetailsResp;
  var sscc = '';
  // Model for Loading component.
  late LoadingModel loadingModel;
  // Model for SideBar component.
  late SideBarModel sideBarModel;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    loadingModel = createModel(context, () => LoadingModel());
    sideBarModel = createModel(context, () => SideBarModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
    loadingModel.dispose();
    sideBarModel.dispose();
  }
}
