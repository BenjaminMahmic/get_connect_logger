// ignore_for_file: unused_field, unnecessary_cast
// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';

class _LogColors {
  static const String BLACK = '\x1B[30m';
  static const String RED = '\x1B[31m';
  static const String GREEN = '\x1B[38;2;30;215;96;m';
  static const String YELLOW = '\x1B[33m';
  static const String BLUE = '\x1B[34m';
  static const String BLUE_LIGHT = '\x1B[38;2;0;141;253;m';
  static const String AQUA = '\x1B[38;2;183;220;214;m';
  static const String MAGENTA = '\x1B[35m';
  static const String CYAN = '\x1B[36m';
  static const String WHITE = '\x1B[37m';
  static const String ACCENT_GREEN = '\x1B[92m';
  static const String ORANGE = '\x1B[38;2;251;192;45;m';
  static const String PINK = '\x1B[38;2;241;125;164;m';
  static const String GREY = '\x1B[38;2;128;128;128;m';

  static const String METHOD_GET = '\x1B[38;2;66;170;248;m';
  static const String METHOD_POST = '\x1B[38;2;29;191;94;m';
  static const String METHOD_PUT = '\x1B[38;2;255;161;0;m';
  static const String METHOD_DELETE = '\x1B[38;2;252;75;79;m';
  static const String METHOD_PATCH = '\x1B[38;2;255;161;0;m';

  static const String STATUSCODE_200 = '\x1B[38;2;53;183;41;m';
  static const String STATUSCODE_300 = '\x1B[38;2;82;113;255;m';
  static const String STATUSCODE_400 = '\x1B[38;2;255;92;92;m';
  static const String STATUSCODE_500 = '\x1B[38;2;255;162;0;m';
}

class ConsoleLogHelper {
  static Future<void> logGetRequest(
    Request request, {
    int? requestNumber,
  }) async {
    final dateAndTime =
        '[ ${DateFormat('dd.MM.yyyy. HH:mm:ss').format(DateTime.now())} ]';

    String method = _colorizedMethod(request.method.toUpperCase());

    final endp =
        '${_LogColors.WHITE}Endpoint($method${_LogColors.WHITE}): ${_LogColors.CYAN}${request.url.path.toString()}';
    final realRequestUrl =
        '${_LogColors.WHITE}Request: ${_LogColors.CYAN}${request.url.toString()}';

    final bodyBytes = await request.bodyBytes.expand((chunk) => chunk).toList();
    final bodyString = utf8.decode(bodyBytes).toString();
    final body = bodyString
        .replaceAll('{', '${_LogColors.AQUA}{${_LogColors.CYAN}')
        .replaceAll('}', '${_LogColors.AQUA}}${_LogColors.CYAN}')
        .replaceAll(': ,', ': ${_LogColors.PINK}empty,')
        .replaceAll('null', '${_LogColors.PINK}null')
        .replaceAll(',', '${_LogColors.AQUA},${_LogColors.CYAN}');

    kIsWeb
        ? debugPrint(
            '${_LogColors.BLACK}·\n'
            '${_LogColors.GREEN}▲ REQUEST ▲ ${requestNumber != null ? '[$requestNumber]' : ''}\n'
            '${_LogColors.BLACK}·\n'
            '⏰ ${_LogColors.WHITE}$dateAndTime'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $realRequestUrl' : ''}'
            '${body.isNotEmpty ? '\n📦 $body' : ''}'
            '${_LogColors.BLACK}·',
          )
        : log(
            '${_LogColors.BLACK}·\n'
            '${_LogColors.GREEN}▲ REQUEST ▲ ${requestNumber != null ? '[$requestNumber]' : ''}\n'
            '${_LogColors.BLACK}·\n'
            '⏰ ${_LogColors.WHITE}$dateAndTime'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $realRequestUrl' : ''}'
            '${body.isNotEmpty ? '\n📦 $body' : ''}'
            '\n${_LogColors.BLACK}·',
            name: 'API',
          );
  }

  static void logGetResponse(
    Request<Object?> request,
    Response<Object?> response, {
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
      statusCodeString = '${_LogColors.RED}NULL';
    } else {
      if (statusCode < 200) {
        statusCodeString = '${_LogColors.WHITE}$statusCode';
      }
      if (statusCode >= 200) {
        statusCodeString = '${_LogColors.STATUSCODE_200}$statusCode';
      }
      if (statusCode >= 300) {
        statusCodeString = '${_LogColors.STATUSCODE_300}$statusCode';
      }
      if (statusCode >= 400) {
        statusCodeString = '${_LogColors.STATUSCODE_400}$statusCode';
      }
      if (statusCode >= 500) {
        statusCodeString = '${_LogColors.STATUSCODE_500}$statusCode';
      }
    }

    final endp =
        '${_LogColors.WHITE}Endpoint($method${_LogColors.WHITE}): ${_LogColors.CYAN}${request.url.path.toString()}';
    final items = response.body is Map<String, dynamic> &&
            (response.body as Map<String, dynamic>)['data']
                is Map<String, dynamic> &&
            (response.body as Map<String, dynamic>)['data']?['items'] is List
        ? '${_LogColors.WHITE}Total items: ${_LogColors.CYAN}${((response.body as Map<String, dynamic>)['data']['items']).length}'
        : '';
    final bodySize = _size(response.body.toString());
    final resBody = response.body.toString().length > maxResponseLenghtForPrint
        ? '${response.body.toString().substring(0, maxResponseLenghtForPrint)} ${_LogColors.YELLOW}... + ${response.body.toString().length - maxResponseLenghtForPrint}'
        : response.body.toString();

    final queryParams =
        '${_LogColors.WHITE}Query params: ${_LogColors.CYAN}[ ${request.url.queryParameters.isNotEmpty ? '?${request.url.queryParameters.entries.map((e) => '${e.key}=${e.value}').join(', ')}' : ' '} ]'
            .replaceAll('?', '');

    final body =
        '${_LogColors.WHITE}Response($statusCodeString${_LogColors.WHITE}): ${_LogColors.CYAN}$resBody'
            .replaceAll('{', '${_LogColors.AQUA}{${_LogColors.CYAN}')
            .replaceAll('}', '${_LogColors.AQUA}}${_LogColors.CYAN}')
            .replaceAll(': ,', ': ${_LogColors.PINK}empty,')
            .replaceAll('null', '${_LogColors.PINK}null')
            .replaceAll(',', '${_LogColors.AQUA},${_LogColors.CYAN}');

    List<String> nullValues = [];
    if (logBodyNullValues) {
      nullValues = response.body is Map<String, dynamic>
          ? _findNullValues((response.body as Map<String, dynamic>)['data'])
          : [];
    }

    String nullValuesString = logBodyNullValues && nullValues.isNotEmpty
        ? '${_LogColors.RED}❓ Null values: [\n${_LogColors.WHITE}${nullValues.join(', ')}${_LogColors.RED}\n]'
            .replaceAll(',', '${_LogColors.RED},${_LogColors.WHITE}')
            .replaceAll('.', '${_LogColors.PINK}.${_LogColors.WHITE}')
            .replaceAll('[0]', '${_LogColors.PINK}[0]${_LogColors.WHITE}')
        : '';

    if (nullValuesString.contains('Null values: []')) {
      nullValuesString = '';
    }

    kIsWeb
        ? debugPrint(
            '${_LogColors.BLACK}·\n'
            '${_LogColors.BLUE_LIGHT}▼ RESPONSE ▼ ${requestNumber != null ? '[$requestNumber]' : ''}\n '
            '${_LogColors.BLACK}·\n'
            '${response.isOk ? '✅ ${_LogColors.GREEN}SUCCESS' : '❌ ${_LogColors.RED}FAILED'} ⏰ ${_LogColors.WHITE}$dateAndTime $reqDuration $bodySize'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $queryParams' : ''}'
            '${items.isNotEmpty ? '\n📝 $items' : ''}'
            '\n📦 $body'
            '\n$nullValuesString'
            '${_LogColors.BLACK}·',
          )
        : log(
            '${_LogColors.BLACK}·\n'
            '${_LogColors.BLUE_LIGHT}▼ RESPONSE ▼ ${requestNumber != null ? '[$requestNumber]' : ''}\n'
            '${_LogColors.BLACK}·\n'
            '${response.isOk ? '✅ ${_LogColors.GREEN}SUCCESS' : '❌ ${_LogColors.RED}FAILED'} ⏰ ${_LogColors.WHITE}$dateAndTime $reqDuration $bodySize'
            '\n🔗 $endp'
            '${request.url.queryParameters.isNotEmpty ? '\n🔀 $queryParams' : ''}'
            '${items.isNotEmpty ? '\n📝 $items' : ''}'
            '\n📦 $body'
            '\n$nullValuesString'
            '\n${_LogColors.BLACK}·',
            name: 'API',
          );

    //if (logBodyNullValues &&
    //    nullValues.isNotEmpty &&
    //    !nullValues.toString().contains('[]')) {
    //  log(
    //      '❓${_LogColors.RED}Response ${requestNumber != null ? '[$requestNumber] ' : ''}'
    //      'null values (Total: ${nullValues.length})',
    //      name: 'API');
    //  inspect(nullValues);
    //}
  }

  static _colorizedMethod(String method) {
    switch (method) {
      case 'POST':
        method = '${_LogColors.METHOD_POST}$method';
        break;
      case 'GET':
        method = '${_LogColors.METHOD_GET}$method';
        break;
      case 'PUT':
        method = '${_LogColors.METHOD_PUT}$method';
        break;
      case 'DELETE':
        method = '${_LogColors.METHOD_DELETE}$method';
        break;
      case 'PATCH':
        method = '${_LogColors.METHOD_PATCH}$method';
        break;
      default:
        method = '${_LogColors.WHITE}$method';
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
