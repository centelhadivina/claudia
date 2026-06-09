import 'dart:async';

import 'package:centelha_claudia/core/error/exceptions.dart';
import 'package:centelha_claudia/core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorLogDatasource {
  static const Duration _timeoutDuration = Duration(seconds: 30);
  final SupabaseService _supabaseService = SupabaseService.instance;

  Future<void> limparErrosAntigos(int diasRetencao) async {
    try {
      await _supabaseService.client
          .from('error_logs')
          .delete()
          .lt(
            'data_erro',
            DateTime.now().subtract(Duration(days: diasRetencao)),
          )
          .timeout(_timeoutDuration);
    } on TimeoutException {
      if (kDebugMode) {
        print('Timeout ao limpar erros antigos');
      }
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print('Erro ao limpar erros antigos: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro inesperado ao limpar erros: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> obterErrosPorModulo(
    String modulo, {
    int limite = 100,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('error_logs')
          .select()
          .eq('modulo', modulo)
          .order('data_erro', ascending: false)
          .limit(limite)
          .timeout(_timeoutDuration);

      return List<Map<String, dynamic>>.from(response);
    } on TimeoutException {
      throw ServerException('Timeout ao buscar erros. Tente novamente.');
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar erros: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<List<Map<String, dynamic>>> obterErrosRecentes({
    int limite = 100,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('error_logs')
          .select()
          .order('data_erro', ascending: false)
          .limit(limite)
          .timeout(_timeoutDuration);

      return List<Map<String, dynamic>>.from(response);
    } on TimeoutException {
      throw ServerException('Timeout ao buscar erros. Tente novamente.');
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar erros: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<List<Map<String, dynamic>>> obterErrosRecentes24h() async {
    try {
      final response = await _supabaseService.client
          .from('error_logs_recentes')
          .select()
          .timeout(_timeoutDuration);

      return List<Map<String, dynamic>>.from(response);
    } on TimeoutException {
      throw ServerException('Timeout ao buscar erros. Tente novamente.');
    } on PostgrestException catch (error) {
      throw ServerException('Erro ao buscar erros: ${error.message}');
    } catch (error) {
      throw ServerException('Erro inesperado: $error');
    }
  }

  Future<void> registrarErro({
    required String erroTipo,
    required String erroMensagem,
    String? erroStackTrace,
    String? modulo,
    String? funcionalidade,
    String? plataforma,
    String? versaoApp,
    Map<String, dynamic>? dadosAdicionais,
  }) async {
    try {
      final usuarioId = _supabaseService.client.auth.currentUser?.id;

      await _supabaseService.client
          .from('error_logs')
          .insert({
            'erro_tipo': erroTipo,
            'erro_mensagem': erroMensagem,
            'erro_stack_trace': erroStackTrace,
            'modulo': modulo,
            'funcionalidade': funcionalidade,
            'usuario_id': usuarioId,
            'plataforma': plataforma ?? 'flutter',
            'versao_app': versaoApp,
            'dados_adicionais': dadosAdicionais ?? {},
          })
          .timeout(_timeoutDuration);
    } on TimeoutException {
      // Silenciar timeout de log para não gerar loop infinito de erros
      if (kDebugMode) {
        print('Timeout ao registrar erro no banco de dados');
      }
    } on PostgrestException catch (e) {
      // Silenciar erro de log para não gerar loop infinito de erros
      if (kDebugMode) {
        print('Erro ao registrar erro no banco de dados: ${e.message}');
      }
    } catch (e) {
      // Silenciar qualquer erro de log para não gerar loop infinito de erros
      if (kDebugMode) {
        print('Erro inesperado ao registrar erro: $e');
      }
    }
  }
}
