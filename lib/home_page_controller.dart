import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import 'package:ronda/helpers/ronda_helper.dart';

import 'helpers/visitante_helper.dart';

/*
https://br.qr-code-generator.com/a1/?ut_source=google_c&ut_medium=cpc&ut_campaign=pr_qr_code_generisch&ut_content=qr_code_exact&ut_term=qrcode%20generator_e&gclid=Cj0KCQiAuJb_BRDJARIsAKkycUnUcjMzYx1a6YJ18tJQqpm_GxAUek2YYuBBJsM9uJgS2VhMVkuAeFcaAv06EALw_wcB

criar um qrcode de identificação do patrulheiro com: 
tipo=1,id_posto=50,id_patrulheiro=650,id_unidade,id_ponto_ronda
o tipo=1 indica uma configuração de inicio de ronda, onde o patrulheiro ler seu crachá com qrcode


criar o qrcode do ponto de ronda com:
tipo=2,id_posto=50,id_patrulheiro=650,id_unidade=5,id_ponto_ronda
a unidade é a unidade configurada no adianti admin
o tipo=2 indica que é uma ronda

/////////// indicar o fluxo se é entrada ou saida
//criar o qrcode do visitante com:
//tipo=3,id_posto=50,id_patrulheiro=650,id_unidade=5,id_visitante
//a unidade é a unidade configurada no adianti admin
               
//o tipo=3 indica que é um visitante
                    //posto
                    //patrulheiro: neste momento o id_patrulheiro não precisa porque vai receber de quem está fazendo a ronda no momento
                    //unidade: a unidade do posto de ronda(obra)
                    //visitante: id dele, o app deve pesquisar se ele está liberado e a validade da liberacao


cadastrar os pontos, as regras e visualizar ou agendar o envio automático por e-mail dos relatórios

*/

class HomePageController extends GetxController {
  var valorCodigoBarras = '';
  // ignore: non_constant_identifier_names
  var patrulheiro_id = "0";
  var tipo = 'não configurado';
  var latitudelongitude = '';
  // ignore: non_constant_identifier_names
  var unidade_id = '';
  // ignore: non_constant_identifier_names
  var ponto_ronda_id = '0';
  // ignore: non_constant_identifier_names
  var posto_id = '0';
  var visitante_id = '0';

  Future<void> escanearCodigoBarras() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (barcodeScanRes == '-1') {
      Get.snackbar('Cancelado', 'Leitura Cancelada');
    } else {
      valorCodigoBarras = barcodeScanRes;

      //separa o conteudo do qrcode por virgula para tratar
      final tagName = valorCodigoBarras;
      final split = tagName.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };

      //print(values);

      // configuração (tipo_id = 1)
      if (values[0] == '1') {
        tipo = values[0];
        unidade_id = values[3];
        ponto_ronda_id = values[4];
        patrulheiro_id = values[2];
        pegarLocalizacao();
        update();
      }

      // ronda (tipo_id = 2)
      if (values[0] == '2') {
        // ignore: unrelated_type_equality_checks
        if (patrulheiro_id != "0") {
          // faz a requisição web para criar o registro da ronda
          ponto_ronda_id = values[4];
          posto_id = values[1];
          pegarLocalizacao();
          fetch();
          update();
        } else {
          Get.snackbar('ERRO', 'Configure o Patrulheiro');
        }
      }

      // controle de acesso (tipo_id = 3)
      if (values[0] == '3') {
        // ignore: unrelated_type_equality_checks
        if (patrulheiro_id != "0") {
          // faz a requisição web para consultar se o visitante tem acesso
          visitante_id = values[4];
          posto_id = values[1];
          pegarLocalizacao();
          consultavisitante();

          // grava dados para proxima tela
          VisitanteHelper helper = VisitanteHelper();
          Visitante v = Visitante();
          v.id = 1;
          v.patrulheiro_id = patrulheiro_id;
          v.visitante_id = visitante_id;
          v.posto_id = posto_id;
          v.latitude = values[0];
          v.longitude = values[1];
          helper.saveVisitante(v);
          //helper.close();
        } else {
          Get.snackbar('ERRO', 'Configure o Agente de Portaria',
              duration: const Duration(seconds: 15));
        }
      }

      //final value1 = values[0];
      //final value2 = values[1];
      //final value3 = values[2];

      //update();

      // faz a requisição web para criar o registro da ronda
      //fetch();
    }
  }
}

/*
ronda.facilitahomeservice.com.br/rest.php?class=RondaService&method=newRonda&unidade_id=1&descricao="ronda efetuada"&patrulheiro_id=1&longitude=111111111&latitude=222222222&ponto_ronda_id=1&porto_id=1

*/
Future fetch() async {
  final controller = Get.put(HomePageController());

  RondaHelper helper = RondaHelper();

  //separa a latitude e longitude por virgula para tratar
  final tagName = controller.latitudelongitude;
  final split = tagName.split(',');
  final Map<int, String> values = {
    for (int i = 0; i < split.length; i++) i: split[i]
  };

  final dataatual = DateTime.now();

  var descricao = 'ronda efetuada com sucesso online';

  var url = 'https://ronda.facilitahomeservice.com.br';

  var dados = '/rest.php?class=RondaService&method=newRonda' +
      '&unidade_id=' +
      controller.unidade_id +
      '&descricao=' +
      descricao +
      '&patrulheiro_id=' +
      controller.patrulheiro_id +
      '&ponto_ronda_id=' +
      controller.ponto_ronda_id +
      '&posto_id=' +
      controller.posto_id +
      '&longitude=' +
      values[1] +
      '&latitude=' +
      values[0];

  try {
    //print(url + dados);

    //var url1 = Uri.http(url, dados);

    //print(url1);

    //var client = http.Client();
    //var teste = await client.get(url1);

    //var t = 'http://' + url + dados;
    //var response = await http.get(Uri.parse(t));
    //var response = await http.get(url1);

    var dio = Dio();

    final response = await dio.get(url + dados);

    if (response.statusCode == 200) {
      //var descodeJson = jsonDecode(response.body);

      //if (response.body['data']['id'] > 0) {
      Get.snackbar('REGISTRADA ONLINE', 'Concluído!',
          duration: const Duration(seconds: 10));

      Ronda c = Ronda();
      c.unidade_id = controller.unidade_id;
      c.tipo_id = "8";
      c.hora_ronda = dataatual.hour.toString() +
          ":" +
          dataatual.minute.toString() +
          ":" +
          dataatual.second.toString();
      c.data_ronda = dataatual.year.toString() +
          "/" +
          dataatual.month.toString() +
          "/" +
          dataatual.day.toString();
      c.descricao = "ronda efetuada com sucesso online";
      c.status_tratamento = "0";
      c.patrulheiro_id = controller.patrulheiro_id;
      c.ponto_ronda_id = controller.ponto_ronda_id;
      c.posto_id = controller.posto_id;
      c.latitude = values[0];
      c.longitude = values[1];
      c.sincronizado = "1";
      helper.saveRonda(c);
      //}
    } else {
      Get.snackbar('SEM INTERNET', 'REGISTRADA LOCALMENTE!',
          duration: const Duration(seconds: 10));

      Ronda c = Ronda();
      c.unidade_id = controller.unidade_id;
      c.tipo_id = "8";
      c.hora_ronda = dataatual.hour.toString() +
          ":" +
          dataatual.minute.toString() +
          ":" +
          dataatual.second.toString();
      c.data_ronda = dataatual.year.toString() +
          "/" +
          dataatual.month.toString() +
          "/" +
          dataatual.day.toString();
      c.descricao = "ronda efetuada com sucesso offiline";
      c.status_tratamento = "0";
      c.patrulheiro_id = controller.patrulheiro_id;
      c.ponto_ronda_id = controller.ponto_ronda_id;
      c.posto_id = controller.posto_id;
      c.latitude = values[0];
      c.longitude = values[1];
      c.sincronizado = "0";
      helper.saveRonda(c);
    }
  } catch (e) {
    print('Excessão: $e');

    Get.snackbar('EXCESSÃO', 'REGISTRADA LOCALMENTE!',
        duration: const Duration(seconds: 10));

    Ronda c = Ronda();
    c.unidade_id = controller.unidade_id;
    c.tipo_id = "8";
    c.hora_ronda = dataatual.hour.toString() +
        ":" +
        dataatual.minute.toString() +
        ":" +
        dataatual.second.toString();
    c.data_ronda = dataatual.year.toString() +
        "/" +
        dataatual.month.toString() +
        "/" +
        dataatual.day.toString();
    c.descricao = "ronda efetuada com sucesso offiline";
    c.status_tratamento = "0";
    c.patrulheiro_id = controller.patrulheiro_id;
    c.ponto_ronda_id = controller.ponto_ronda_id;
    c.posto_id = controller.posto_id;
    c.latitude = controller
        .latitudelongitude; // erro neste momento tem as duas coordenadas juntas
    c.longitude = controller.latitudelongitude;
    c.sincronizado = "0";
    helper.saveRonda(c);
  }
}

/*
ronda.facilitahomeservice.com.br/rest.php?class=VisitanteService&method=getVisitante&id_visitante=3
*/
Future consultavisitante() async {
  final controller = Get.put(HomePageController());

  //separa a latitude e longitude por virgula para tratar
  //final tagName = controller.latitudelongitude;
  //final split = tagName.split(',');
  //final Map<int, String> values = {
  //  for (int i = 0; i < split.length; i++) i: split[i]
  //};

  var url =
      'https://ronda.facilitahomeservice.com.br/rest.php?class=VisitanteService&method=getVisitante&visitante_id=';
  var dados = controller.visitante_id;

  try {
    var dio = Dio();
    print(url + dados);
    final response = await dio.get(url + dados);

    if (response.statusCode == 200) {
      var descodeJson = response.data;

      if (descodeJson['data'][0] != null) {
        //print(descodeJson['data'][0]['status']);

        if (descodeJson['data'][0]['status'] == 'Y') {
          var data = new DateTime.now();
          var diaDaSemana = data.weekday;
          //print(diaDaSemana);
          var horario = '';
          switch (diaDaSemana) {
            case 7:
              {
                horario = 'Domingo ' +
                    descodeJson['data'][0]['permissao_dom_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_dom_fim'];
              }
              break;

            case 6:
              {
                horario = 'Sábado ' +
                    descodeJson['data'][0]['permissao_sab_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_sab_fim'];
              }
              break;

            case 5:
              {
                horario = 'Sexta-feira ' +
                    descodeJson['data'][0]['permissao_sex_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_sex_fim'];
              }
              break;

            case 4:
              {
                horario = 'Quinta-feira ' +
                    descodeJson['data'][0]['permissao_qui_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_qui_fim'];
              }
              break;
            case 3:
              {
                horario = 'Quarta-feira ' +
                    descodeJson['data'][0]['permissao_qua_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_qua_fim'];
              }
              break;
            case 2:
              {
                horario = 'Terça-feira ' +
                    descodeJson['data'][0]['permissao_ter_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_ter_fim'];
              }
              break;
            case 1:
              {
                horario = 'Segunda-feira ' +
                    descodeJson['data'][0]['permissao_seg_ini'] +
                    ' as ' +
                    descodeJson['data'][0]['permissao_seg_fim'];
              }
              break;
            default:
              {
                horario = "Dia inválido";
              }
              break;
          }

          Get.snackbar('LIBERADO',
              'Acesso Liberado!\n\n ${descodeJson['data'][0]['nome']}.\n\n Horário: ${horario}.\n\n Permissão temporária: ${descodeJson['data'][0]['data_permitida']}\n\n das ${descodeJson['data'][0]['data_ini']} as ${descodeJson['data'][0]['data_fim']}',
              duration: const Duration(seconds: 5));
        } else {
          Get.snackbar('BLOQUEADO', 'Consulte a adminitração!',
              duration: const Duration(seconds: 5));
        }
      }
    } else {
      Get.snackbar('SEM INTERNET', 'TENTE NOVAMENTE!',
          duration: const Duration(seconds: 5));

      //print('erro, sem internet');
    }
  } on SocketException {
    //print('No Internet connection');
    Get.snackbar('SEM INTERNET', 'TENTE NOVAMENTE!',
        duration: const Duration(seconds: 10));
  }
}

// ignore: missing_return
Future<String> pegarLocalizacao() async {
  final controller = Get.put(HomePageController());

  final minhaLocalizacao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  //print(minhaLocalizacao);

  // ignore: non_constant_identifier_names
  String latitude_longitude = '';
  latitude_longitude = minhaLocalizacao.latitude.toString() +
      ',' +
      minhaLocalizacao.longitude.toString();

  controller.latitudelongitude = latitude_longitude;
}
