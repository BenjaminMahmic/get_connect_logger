// ignore_for_file: unused_field, unnecessary_cast
// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';

import '../constants/log_colors.dart';

class ConsoleLogHelper {
  static void printConsoleMessage(
    Request request,
    Response response, {
    int? requestNumber,
    DateTime? reqStartTime,
    int maxResponseLenghtForPrint = 2000,
    bool logBodyNullValues = true,
  }) async {
    await _logGetRequest(
      request,
      requestNumber: requestNumber,
    );
    _logGetResponse(
      request,
      response,
      requestNumber: requestNumber,
      reqStartTime: reqStartTime,
      maxResponseLenghtForPrint: maxResponseLenghtForPrint,
      logBodyNullValues: logBodyNullValues,
    );
  }

  static Future<void> _logGetRequest(
    Request request, {
    int? requestNumber,
  }) async {
    final dateAndTime =
        '[ ${DateFormat('dd.MM.yyyy. HH:mm:ss').format(DateTime.now())} ]';

    String method = _colorizedMethod(request.method.toUpperCase());

    final endp =
        '${LogColors.WHITE}Endpoint($method${LogColors.WHITE}): ${LogColors.CYAN}${request.url.path.toString()}';
    final realRequestUrl =
        '${LogColors.WHITE}Request: ${LogColors.CYAN}${request.url.toString()}';

    final bodyBytes = await request.bodyBytes.expand((chunk) => chunk).toList();
    final bodyString = utf8.decode(bodyBytes).toString();
    final body = bodyString
        .replaceAll('{', '${LogColors.AQUA}{${LogColors.CYAN}')
        .replaceAll('}', '${LogColors.AQUA}}${LogColors.CYAN}')
        .replaceAll(': ,', ': ${LogColors.PINK}empty,')
        .replaceAll('null', '${LogColors.PINK}null')
        .replaceAll(',', '${LogColors.AQUA},${LogColors.CYAN}');

    kIsWeb
        ? debugPrint(
            '${LogColors.BLACK}·\n'
            '${LogColors.GREEN}▲ REQUEST ▲ ${requestNumber != null ? '[$requestNumber]' : ''}\n'
            '${LogColors.BLACK}·\n'
            '⏰ ${LogColors.WHITE}$dateAndTime'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $realRequestUrl' : ''}'
            '${body.isNotEmpty ? '\n📦 $body' : ''}'
            '${LogColors.BLACK}·',
          )
        : log(
            '${LogColors.BLACK}·\n'
            '${LogColors.GREEN}▲ REQUEST ▲ ${requestNumber != null ? '[$requestNumber]' : ''}\n'
            '${LogColors.BLACK}·\n'
            '⏰ ${LogColors.WHITE}$dateAndTime'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $realRequestUrl' : ''}'
            '${body.isNotEmpty ? '\n📦 $body' : ''}'
            '\n${LogColors.BLACK}·',
            name: 'GCL',
          );
  }

  static void _logGetResponse(
    Request request,
    Response response, {
    int maxResponseLenghtForPrint = 2000,
    int? requestNumber,
    DateTime? reqStartTime,
    bool logBodyNullValues = true,
  }) {
    final dateAndTime =
        '[ ${DateFormat('dd.MM.yyyy. HH:mm:ss').format(DateTime.now())} ]';
    final reqDuration = reqStartTime == null
        ? ''
        : DateTime.now().difference(reqStartTime).inMilliseconds > 1000
            ? '[ ${(DateTime.now().difference(reqStartTime).inMilliseconds / 1000).toStringAsFixed(2)}s ]'
            : '[ ${DateTime.now().difference(reqStartTime).inMilliseconds}ms ]';

    String method = _colorizedMethod(request.method.toUpperCase());

    int? statusCode = response.statusCode;
    String statusCodeString = '';
    if (statusCode == null) {
      statusCodeString = '${LogColors.RED}NULL';
    } else {
      if (statusCode < 200) {
        statusCodeString = '${LogColors.WHITE}$statusCode';
      }
      if (statusCode >= 200) {
        statusCodeString = '${LogColors.STATUSCODE_200}$statusCode';
      }
      if (statusCode >= 300) {
        statusCodeString = '${LogColors.STATUSCODE_300}$statusCode';
      }
      if (statusCode >= 400) {
        statusCodeString = '${LogColors.STATUSCODE_400}$statusCode';
      }
      if (statusCode >= 500) {
        statusCodeString = '${LogColors.STATUSCODE_500}$statusCode';
      }
    }

    final endp =
        '${LogColors.WHITE}Endpoint($method${LogColors.WHITE}): ${LogColors.CYAN}${request.url.path.toString()}';
    final items = response.body is Map<String, dynamic> &&
            (response.body as Map<String, dynamic>)['data']
                is Map<String, dynamic> &&
            (response.body as Map<String, dynamic>)['data']?['items'] is List
        ? '${LogColors.WHITE}Total items: ${LogColors.CYAN}${((response.body as Map<String, dynamic>)['data']['items']).length}'
        : '';
    final bodySize = _size(response.body.toString());
    final resBody = response.body.toString().length > maxResponseLenghtForPrint
        ? '${response.body.toString().substring(0, maxResponseLenghtForPrint)} ${LogColors.YELLOW}... + ${response.body.toString().length - maxResponseLenghtForPrint}'
        : response.body.toString();

    final queryParams =
        '${LogColors.WHITE}Query params: ${LogColors.CYAN}[ ${request.url.queryParameters.isNotEmpty ? '?${request.url.queryParameters.entries.map((e) => '${e.key}=${e.value}').join(', ')}' : ' '} ]'
            .replaceAll('?', '');

    final body =
        '${LogColors.WHITE}Response($statusCodeString${LogColors.WHITE}): ${LogColors.CYAN}$resBody'
            .replaceAll('{', '${LogColors.AQUA}{${LogColors.CYAN}')
            .replaceAll('}', '${LogColors.AQUA}}${LogColors.CYAN}')
            .replaceAll(': ,', ': ${LogColors.PINK}empty,')
            .replaceAll('null', '${LogColors.PINK}null')
            .replaceAll(',', '${LogColors.AQUA},${LogColors.CYAN}');

    List<String> nullValues = [];
    if (logBodyNullValues) {
      nullValues = response.body is Map<String, dynamic>
          ? _findNullValues((response.body as Map<String, dynamic>)['data'])
          : [];
    }

    String nullValuesString = logBodyNullValues && nullValues.isNotEmpty
        ? '${LogColors.RED}❓ Null values: [\n${LogColors.WHITE}${nullValues.join(', ')}${LogColors.RED}\n]'
            .replaceAll(',', '${LogColors.RED},${LogColors.WHITE}')
            .replaceAll('.', '${LogColors.PINK}.${LogColors.WHITE}')
            .replaceAll('[0]', '${LogColors.PINK}[0]${LogColors.WHITE}')
        : '';

    if (nullValuesString.contains('Null values: [\n\n]')) {
      nullValuesString = '';
    }

    kIsWeb
        ? debugPrint(
            '${LogColors.BLACK}·\n'
            '${LogColors.BLUE_LIGHT}▼ RESPONSE ▼ ${requestNumber != null ? '[$requestNumber]' : ''}\n '
            '${LogColors.BLACK}·\n'
            '${response.isOk ? '✅ ${LogColors.GREEN}SUCCESS' : '❌ ${LogColors.RED}FAILED'} ⏰ ${LogColors.WHITE}$dateAndTime $reqDuration $bodySize'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $queryParams' : ''}'
            '${items.isNotEmpty ? '\n📝 $items' : ''}'
            '\n📦 $body'
            '\n$nullValuesString'
            '${LogColors.BLACK}·',
          )
        : log(
            '${LogColors.BLACK}·\n'
            '${LogColors.BLUE_LIGHT}▼ RESPONSE ▼ ${requestNumber != null ? '[$requestNumber]' : ''}\n'
            '${LogColors.BLACK}·\n'
            '${response.isOk ? '✅ ${LogColors.GREEN}SUCCESS' : '❌ ${LogColors.RED}FAILED'} ⏰ ${LogColors.WHITE}$dateAndTime $reqDuration $bodySize'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $queryParams' : ''}'
            '${items.isNotEmpty ? '\n📝 $items' : ''}'
            '\n📦 $body'
            '\n$nullValuesString'
            '\n${LogColors.BLACK}·',
            name: 'GCL',
          );
  }

  static _colorizedMethod(String method) {
    switch (method) {
      case 'POST':
        method = '${LogColors.METHOD_POST}$method';
        break;
      case 'GET':
        method = '${LogColors.METHOD_GET}$method';
        break;
      case 'PUT':
        method = '${LogColors.METHOD_PUT}$method';
        break;
      case 'DELETE':
        method = '${LogColors.METHOD_DELETE}$method';
        break;
      case 'PATCH':
        method = '${LogColors.METHOD_PATCH}$method';
        break;
      case 'HEAD':
        method = '${LogColors.METHOD_HEAD}$method';
        break;
      default:
        method = '${LogColors.WHITE}$method';
    }

    return method;
  }

  static String _size(String body) {
    List<int> bytes = utf8.encode(body);
    int sizeInBytes = bytes.length;
    double sizeInMB = sizeInBytes / (1024 * 1024);
    if (sizeInMB < 1) {
      return '[ ${(sizeInBytes / 1024).toStringAsFixed(2)} KB ]';
    }
    return '[ ${sizeInMB.toStringAsFixed(5)} MB ]';
  }

  static List<String> _findNullValues(dynamic value, [String parentKey = '']) {
    List<String> nullValues = [];

    if (value is Map<String, dynamic>) {
      value.forEach((key, value) {
        String newKey = parentKey.isEmpty ? key : '$parentKey.$key';
        nullValues.addAll(_findNullValues(value, newKey));
      });
    } else if (value is List) {
      if ((value as List).isNotEmpty) {
        nullValues.addAll(_findNullValues(value[0], '$parentKey[0]'));
      }
    } else if (value == null) {
      nullValues.add(parentKey);
    }

    return nullValues;
  }
}
