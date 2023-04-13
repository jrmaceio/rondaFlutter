import 'package:ronda/repositories/visitante_repositories.dart';
import 'package:flutter/material.dart';
import 'package:ronda/model/api_visitante.dart';

class VisitanteController {
  List<Data> api = [];
  final repository = VisitanteRepository();
  final state = ValueNotifier<VisitanteState>(VisitanteState.start);

  Future start(visitanteid) async {
    await Future.delayed(const Duration(seconds: 2)); // delay de 2 segundos
    state.value = VisitanteState.loading;
    try {
      api = await repository.getVisitanteHttp(visitanteid);
      state.value = VisitanteState.success;
    } catch (e) {
      print(e);
      state.value = VisitanteState.error;
    }
  }
}

// gerenciar os estados
enum VisitanteState { start, loading, success, error }
