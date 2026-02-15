import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start SerialStatusUpdate Group Code

class SerialStatusUpdateGroup {
  static String getBaseUrl() =>
      'https://nonrepentantly-noblest-jacki.ngrok-free.dev/api_test/api/v1/status';
  static Map<String, String> headers = {};
  static CheckSerialStatusCall checkSerialStatusCall = CheckSerialStatusCall();
  static UpdateSerialStatusCall updateSerialStatusCall =
      UpdateSerialStatusCall();
}

class CheckSerialStatusCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = SerialStatusUpdateGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
"serial" : "######" 
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CheckSerialStatus',
      apiUrl: '${baseUrl}/check-serial',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateSerialStatusCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = SerialStatusUpdateGroup.getBaseUrl();

    final ffApiRequestBody = '''
{ 
"statusType": "DAMAGED", 
  "reasonCode": "D03", 
  "reasonDescription": "Torn packaging", 
  "operatorId": "USER-001", 
  "SerialList": 
[ 
    "Serial1", 
    "Serial2" 
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateSerialStatus',
      apiUrl: '${baseUrl}/update',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End SerialStatusUpdate Group Code

/// Start UserAccessMangment Group Code

class UserAccessMangmentGroup {
  static String getBaseUrl() =>
      'https://nonrepentantly-noblest-jacki.ngrok-free.dev/api_test';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  static GetAllUsersCall getAllUsersCall = GetAllUsersCall();
  static UserLoginCall userLoginCall = UserLoginCall();
}

class GetAllUsersCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = UserAccessMangmentGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'GetAllUsers',
      apiUrl: '${baseUrl}/GetAllUsers',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].username''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? role(dynamic response) => (getJsonField(
        response,
        r'''$[:].role''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class UserLoginCall {
  Future<ApiCallResponse> call({
    String? username = '',
    String? password = '',
  }) async {
    final baseUrl = UserAccessMangmentGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "username": "${escapeStringForJson(username)}",
  "password": "${escapeStringForJson(password)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UserLogin',
      apiUrl: '${baseUrl}/UserLogin',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End UserAccessMangment Group Code

/// Start OrdersAPIs Group Code

class OrdersAPIsGroup {
  static String getBaseUrl() =>
      'https://nonrepentantly-noblest-jacki.ngrok-free.dev/api_test/api/v1/orders';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  static GetOrderByUserCall getOrderByUserCall = GetOrderByUserCall();
  static GetOrderDetailsCall getOrderDetailsCall = GetOrderDetailsCall();
  static ProductSerialsDetailsCall productSerialsDetailsCall =
      ProductSerialsDetailsCall();
}

class GetOrderByUserCall {
  Future<ApiCallResponse> call({
    String? username = 'Admin',
    String? orderStatus = '',
  }) async {
    final baseUrl = OrdersAPIsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "username": "${escapeStringForJson(username)}",
  "Status": "${escapeStringForJson(orderStatus)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetOrderByUser',
      apiUrl: '${baseUrl}/GetOrderByUser',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? order(dynamic response) => (getJsonField(
        response,
        r'''$.data.items[:].orderNo''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? customer(dynamic response) => (getJsonField(
        response,
        r'''$.data.items[:].customer''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<int>? permitNo(dynamic response) => (getJsonField(
        response,
        r'''$.data.items[:].permitNo''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<String>? status(dynamic response) => (getJsonField(
        response,
        r'''$.data.items[:].status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetOrderDetailsCall {
  Future<ApiCallResponse> call({
    String? orderNO = 'SO-7781',
  }) async {
    final baseUrl = OrdersAPIsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "orderNo": "${escapeStringForJson(orderNO)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetOrderDetails',
      apiUrl: '${baseUrl}/GetOrderDetails',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? orderNo(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.orderNo''',
      ));
  String? customer(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.customer''',
      ));
  String? gln(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.gln''',
      ));
  String? sscc(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.sscc''',
      ));
  List<String>? productsName(dynamic response) => (getJsonField(
        response,
        r'''$.products[:].productName''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<int>? requiredQtys(dynamic response) => (getJsonField(
        response,
        r'''$.products[:].requiredQty''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<int>? scannedQtys(dynamic response) => (getJsonField(
        response,
        r'''$.products[:].scannedQty''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<String>? gTINs(dynamic response) => (getJsonField(
        response,
        r'''$.products[:].GTIN''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ProductSerialsDetailsCall {
  Future<ApiCallResponse> call({
    String? orderNo = '',
    String? gtin = '',
    String? sscc = '',
  }) async {
    final baseUrl = OrdersAPIsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "orderNo": "${escapeStringForJson(orderNo)}",
  "gtin": "${escapeStringForJson(gtin)}",
  "SSCC": "${escapeStringForJson(sscc)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ProductSerialsDetails',
      apiUrl: '${baseUrl}/ProductSerialsDetails',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  int? totalPallets(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data.summary.totalPallets''',
      ));
  int? totalCartons(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data.summary.totalCartons''',
      ));
  int? totalItems(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data.summary.totalItems''',
      ));
  List<String>? serial(dynamic response) => (getJsonField(
        response,
        r'''$.data.nodes[:].serial''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<int>? serialsitemsCount(dynamic response) => (getJsonField(
        response,
        r'''$.data.nodes[:].childCounts.item''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<String>? serialsitemstype(dynamic response) => (getJsonField(
        response,
        r'''$.data.nodes[:].type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<int>? serialspalletsCount(dynamic response) => (getJsonField(
        response,
        r'''$.data.nodes[:].childCounts.pallet''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List<int>? serialscartonsCount(dynamic response) => (getJsonField(
        response,
        r'''$.data.nodes[:].childCounts.carton''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

/// End OrdersAPIs Group Code

class GetOrdersDataCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'GetOrders Data',
      apiUrl: 'https://api.thecatapi.com/v1/images/search?limit=10',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? orders(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? products(dynamic response) => (getJsonField(
        response,
        r'''$[:].url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? customers(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? quantities(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
