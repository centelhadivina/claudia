import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ErrorLogEntry {
  final DateTime timestamp;
  final String error;
  final String? stackTrace;
  final String source;
  final String route;
  final String? additionalInfo;

  ErrorLogEntry({
    required this.timestamp,
    required this.error,
    this.stackTrace,
    required this.source,
    required this.route,
    this.additionalInfo,
  });

  String get formattedTimestamp {
    final dt = timestamp.toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(dt.day)}/${twoDigits(dt.month)}/${dt.year} ${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}';
  }
}

class ErrorLogService {
  static final ErrorLogService instance = ErrorLogService._();

  final List<ErrorLogEntry> _entries = [];

  factory ErrorLogService() => instance;

  ErrorLogService._();

  UnmodifiableListView<ErrorLogEntry> get entries =>
      UnmodifiableListView(_entries.reversed);

  void clear() {
    _entries.clear();
  }

  void logError(
    Object error,
    StackTrace? stackTrace, {
    String source = 'Unhandled',
    String? route,
    String? additionalInfo,
  }) {
    final currentRoute = route ?? Get.currentRoute;
    _entries.add(
      ErrorLogEntry(
        timestamp: DateTime.now(),
        error: error.toString(),
        stackTrace: stackTrace?.toString(),
        source: source,
        route: currentRoute.isNotEmpty ? currentRoute : 'desconhecido',
        additionalInfo: additionalInfo,
      ),
    );
  }

  void logFlutterError(FlutterErrorDetails details) {
    logError(
      details.exception,
      details.stack,
      source: 'FlutterError.onError',
      additionalInfo: details.context?.toDescription(),
    );
    FlutterError.presentError(details);
  }
}
