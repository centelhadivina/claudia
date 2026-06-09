import 'dart:collection';

import 'package:centelha_claudia/core/services/error_log_datasource.dart';
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
  final ErrorLogDatasource _datasource = ErrorLogDatasource();

  final List<ErrorLogEntry> _entries = [];

  factory ErrorLogService() => instance;

  ErrorLogService._();

  UnmodifiableListView<ErrorLogEntry> get entries =>
      UnmodifiableListView(_entries.reversed);

  void clear() {
    _entries.clear();
  }

  Future<void> limparErrosAntigos(int diasRetencao) async {
    return await _datasource.limparErrosAntigos(diasRetencao);
  }

  void logError(
    Object error,
    StackTrace? stackTrace, {
    String source = 'Unhandled',
    String? route,
    String? additionalInfo,
    String? modulo,
    String? funcionalidade,
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

    // Registrar no banco de dados de forma assíncrona (sem bloquear)
    _registrarNoSupabase(
      erroTipo: source,
      erroMensagem: error.toString(),
      erroStackTrace: stackTrace?.toString(),
      modulo: modulo,
      funcionalidade: funcionalidade,
      rota: currentRoute.isNotEmpty ? currentRoute : 'desconhecido',
      dadosAdicionais: additionalInfo,
    );
  }

  void logFlutterError(FlutterErrorDetails details) {
    logError(
      details.exception,
      details.stack,
      source: 'FlutterError.onError',
      additionalInfo: details.context?.toDescription(),
      modulo: 'Flutter',
      funcionalidade: 'Erro não tratado',
    );
    FlutterError.presentError(details);
  }

  Future<List<Map<String, dynamic>>> obterErrosPorModulo(
    String modulo, {
    int limite = 100,
  }) async {
    return await _datasource.obterErrosPorModulo(modulo, limite: limite);
  }

  // Métodos para acessar logs do Supabase
  Future<List<Map<String, dynamic>>> obterErrosRecentes({
    int limite = 100,
  }) async {
    return await _datasource.obterErrosRecentes(limite: limite);
  }

  Future<List<Map<String, dynamic>>> obterErrosRecentes24h() async {
    return await _datasource.obterErrosRecentes24h();
  }

  void _registrarNoSupabase({
    required String erroTipo,
    required String erroMensagem,
    String? erroStackTrace,
    String? modulo,
    String? funcionalidade,
    String? rota,
    String? dadosAdicionais,
  }) {
    // Executar assincronamente sem bloquear
    Future.microtask(() async {
      try {
        await _datasource.registrarErro(
          erroTipo: erroTipo,
          erroMensagem: erroMensagem,
          erroStackTrace: erroStackTrace,
          modulo: modulo,
          funcionalidade: funcionalidade,
          dadosAdicionais: {'rota': rota, 'info_adicional': dadosAdicionais},
        );
      } catch (e) {
        // Silenciar erro para não gerar loop infinito
        if (kDebugMode) {
          print('Erro ao registrar log no Supabase: $e');
        }
      }
    });
  }
}
