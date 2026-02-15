import '/backend/api_requests/api_calls.dart';
import '/components/header/header_widget.dart';
import '/components/loading/loading_widget.dart';
import '/components/side_bar/side_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'mainpage_widget.dart' show MainpageWidget;
import 'package:flutter/material.dart';

class MainpageModel extends FlutterFlowModel<MainpageWidget> {
  ///  Local state fields for this page.

  bool loadingisvisable = false;

  ///  State fields for stateful widgets in this page.

  // Model for Header component.
  late HeaderModel headerModel;
  // Stores action output result for [Backend Call - API (GetOrderByUser)] action in OrdersButtonContainer widget.
  ApiCallResponse? getOrdersApiResults;
  // Stores action output result for [Backend Call - API (GetOrderByUser)] action in ShipmentButtonContainer widget.
  ApiCallResponse? getCompletedOrders;
  // Stores action output result for [Backend Call - API (GetOrderByUser)] action in CancelShipmentContainer widget.
  ApiCallResponse? getShipedOrders;
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
