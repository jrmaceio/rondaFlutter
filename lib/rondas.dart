import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ronda/api.dart';
import 'helpers/ronda_helper.dart';

enum OrderOptions { orderaz, orderza, limpar }

class RondaPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<RondaPage> {
  RondaHelper helper = RondaHelper();

  List<Ronda> rondas = [];

  late List<Api> _api;

  @override
  void initState() {
    super.initState();

    // deleta o banco de dados do celular helper.deleteDb();

    //teste de criação do banco e inclusão de um registro
    //Ronda c = Ronda();
    //c.unidade_id = "3";
    //c.tipo_id = "8";
    //c.hora_ronda = "09:00:00";
    //c.data_ronda = "2021-01-10";
    //c.descricao = "ronda efetuada com sucesso";
    //c.status_tratamento = "0";
    //c.patrulheiro_id = "99";
    //c.ponto_ronda_id = "99";
    //c.posto_id = "99";
    //c.latitude = "-999999999";
    //c.longitude = "-777777777";
    //c.sincronizado = "0";
    //helper.saveRonda(c);

    //pegar o que está gravado
    helper.getAllRondas().then((list) {
      setState(() {
        //atualiza a tela
        rondas = list;
      });
    });
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rondas efetuadas"),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Não Sincronizadas"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Sincronizadas"),
                value: OrderOptions.orderza,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Limpar Sincronizadas"),
                value: OrderOptions.limpar,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('Aguarde', 'Sincronizando ...',
              duration: const Duration(seconds: 10));

          for (int i = 0; i < rondas.length; i++) {
            if (rondas[i].sincronizado == "0") {
              //id, unidadeid, patrulheiroid, pontorondaid, postoid, latitude, longitude, dataronda, horaronda
              Timer(Duration(seconds: 2), () {
                //print("$i aqui");
                sincronizar(
                    rondas[i].id,
                    rondas[i].unidade_id,
                    rondas[i].patrulheiro_id,
                    rondas[i].ponto_ronda_id,
                    rondas[i].posto_id,
                    rondas[i].latitude,
                    rondas[i].longitude,
                    rondas[i].data_ronda,
                    rondas[i].hora_ronda,
                    rondas[i]);
              });
            }
          }

          //:TODO não está atualizando a tela
          // atualiza a tela
          helper.getAllRondas().then((list) {
            setState(() {
              //atualiza a tela
              rondas = list;
            });
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(5.0),
          itemCount: rondas.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.security, color: Colors.black),
              title: _dataronda(rondas[index].data_ronda ?? "",
                  rondas[index].hora_ronda ?? ""),
              trailing: rondas[index].sincronizado == '1'
                  ? Icon(Icons.done, color: Colors.green)
                  : Icon(Icons.check_box_outline_blank_outlined,
                      color: Colors.red),
              subtitle: Text(
                "Posto: " +
                    rondas[index].posto_id +
                    ", Patrulheiro: " +
                    rondas[index].patrulheiro_id +
                    ", Ponto: " +
                    rondas[index].ponto_ronda_id,
                style: TextStyle(color: Colors.black, fontSize: 13.0),
              ),
              selected: true,
            );
          }),
    );
  }

//ListView.builder(
//            padding: EdgeInsets.all(5.0),
//            itemCount: rondas.length,
//            itemBuilder: (context, index) {
//              return _rondaCard(context, index);
//            })

  Widget teste(BuildContext context, int index) {
    return ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: rondas.length,
        itemBuilder: (context, index) {
          return _rondaCard(context, index);
        });
  }

  Widget _rondaCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _dataronda(rondas[index].data_ronda ?? "",
                        rondas[index].hora_ronda ?? ""),
                    Text(
                      "Localização: " +
                          rondas[index].latitude +
                          ',' +
                          rondas[index].longitude,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    Text(
                      "Posto: " +
                          rondas[index].posto_id +
                          ", Patrulheiro: " +
                          rondas[index].patrulheiro_id +
                          ", Ponto: " +
                          rondas[index].ponto_ronda_id,
                      style: TextStyle(fontSize: 13.0),
                    ),
                    _sinc(rondas[index].sincronizado),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        //Get.snackbar('aqui', 'teclei!');
        //InkWell(
        //    child: Icon(Icons.delete),
        //    onTap: () {
        //      //deleteChapter();
        //      setState(() {});
        //    });
      },
    );
  }

  _sinc(sincronizado) {
    String texto = "Não sincronizada";
    if (sincronizado == "1") {
      texto = "Sincronizada";
    }
    return Text(
      texto,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
    );
  }

  // ignore: non_constant_identifier_names
  _dataronda(data_ronda, hora_ronda) {
    NumberFormat formatter = NumberFormat("00");

    // ignore: non_constant_identifier_names
    List _data_ronda = data_ronda.split('/');
    _data_ronda[0] = formatter.format(int.parse(_data_ronda[0]));
    _data_ronda[1] = formatter.format(int.parse(_data_ronda[1]));
    _data_ronda[2] = formatter.format(int.parse(_data_ronda[2]));
    String _data = _data_ronda[2] + "/" + _data_ronda[1] + "/" + _data_ronda[0];

    List _hora_ronda = hora_ronda.split(':');
    _hora_ronda[0] = formatter.format(int.parse(_hora_ronda[0]));
    _hora_ronda[1] = formatter.format(int.parse(_hora_ronda[1]));
    _hora_ronda[2] = formatter.format(int.parse(_hora_ronda[2]));
    String _hora =
        _hora_ronda[0] + ':' + _hora_ronda[1] + ':' + _hora_ronda[2] + 'hs';

    return Text(
      "Data: " + _data + " Hora: " + _hora,
      style: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        rondas.sort((a, b) {
          return a.sincronizado
              .toLowerCase()
              .compareTo(b.sincronizado.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        rondas.sort((a, b) {
          return b.sincronizado
              .toLowerCase()
              .compareTo(a.sincronizado.toLowerCase());
        });
        break;
      case OrderOptions.limpar:
        AlertDialog(
          title: Text('Deseja excluir ?'),
          content: Text('Está operação não opderá ser desfeita.'),
          actions: <Widget>[
            RaisedButton(
                color: Colors.red,
                child: Text('Cancelar', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  //Navigator.of(context).pop();
                }),
            RaisedButton(
                color: Colors.red,
                child: Text('Remover', style: TextStyle(color: Colors.green)),
                onPressed: () {}),
          ],
        );
      //helper.deleteRondaSinc();
      //helper.getAllRondas().then((list) {
      //  setState(() {
      //    rondas = list;
      //  });
      //});
      //break;
    }
    setState(() {});
  }

  Future sincronizar(id, unidadeid, patrulheiroid, pontorondaid, postoid,
      latitude, longitude, dataronda, horaronda, rondas) async {
    // id é o id no banco sqlite para editar gravando que foi seincronizada

    // retira a barra da data e coloca o padrão do php
    NumberFormat formatter = NumberFormat("00");
    List _data_ronda3 = dataronda.split('/');
    _data_ronda3[0] = formatter.format(int.parse(_data_ronda3[0]));
    _data_ronda3[1] = formatter.format(int.parse(_data_ronda3[1]));
    _data_ronda3[2] = formatter.format(int.parse(_data_ronda3[2]));
    String _data =
        _data_ronda3[0] + "-" + _data_ronda3[1] + "-" + _data_ronda3[2];

    var dadosnewRonda = '/rest.php?class=RondaService&method=SincRonda';
    var dadosgetRonda = '/rest.php?class=RondaService&method=getRonda';

    var dados = '&unidade_id=' +
        unidadeid +
        '&descricao=ronda sincronizada' +
        '&patrulheiro_id=' +
        patrulheiroid +
        '&ponto_ronda_id=' +
        pontorondaid +
        '&posto_id=' +
        postoid +
        '&longitude=' +
        longitude +
        '&latitude=' +
        latitude +
        '&data_ronda=' +
        _data +
        '&hora_ronda=' +
        horaronda;

    var url = 'https://ronda.facilitahomeservice.com.br';
    //var url1 = Uri.http(url, dadosgetRonda + dados);

    try {
      //var response = await http.get(url1);

      //usando dio
      var dio = Dio();

      //print(url + dadosgetRonda + dados);
      final response = await dio.get(url + dadosgetRonda + dados);

      if (response.statusCode == 200) {
        try {
          // se existir ele vai retornar o registro
          // mas se não existir vai gerar uma excessão
          //http var descodeJson = jsonDecode(response.body);
          //http print(descodeJson['data']['id']);

          // Dio
          //print("VERIFICAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print(response.data['data']['id']);
        } catch (e) {
          // criar o novo registro
          //var url2 = Uri.http(url, dadosnewRonda + dados);
          //var response2 = await http.post(url2);
          //usando dio
          final response2 = await dio.get(url + dadosnewRonda + dados);

          if (response2.statusCode == 200) {
            Get.snackbar('SUCESSO', 'Sincronizada com sucesso!');
            rondas.sincronizado = "1";
            helper.updateRonda(rondas);
          }
        }
      }
    } on SocketException {
      Get.snackbar('ERRO', 'Sem conexão com internet!');
      //print('No Internet connection');
    }
  }

  Future<List<Api>?> _getRonda(id, unidadeid, patrulheiroid, pontorondaid,
      postoid, latitude, longitude, dataronda, horaronda, rondas) async {
    var descricao = '';

    try {
      List<Api> listRonda = [];

      var url = 'https://ronda.facilitahomeservice.com.br';

      var dados = '/ronda/rest.php?class=RondaService&method=getRonda' +
          '&unidade_id=' +
          unidadeid +
          '&descricao=' +
          descricao +
          '&patrulheiro_id=' +
          patrulheiroid +
          '&ponto_ronda_id=' +
          pontorondaid +
          '&posto_id=' +
          postoid +
          '&longitude=' +
          longitude +
          '&latitude=' +
          latitude +
          '&data_ronda=' +
          dataronda +
          '&hora_ronda=' +
          horaronda;

      var url1 = Uri.https(url, dados);

      final response = await http.get(url1);

      //print(response.statusCode);
      //print(response.body);
      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        //descodeJson.forEach((item) => listRonda.add(Api.fromJson(item)));

        if (descodeJson['data'][0] != null) {
          //print(descodeJson['data'][0]);
          rondas.sincronizado = "1";
          helper.updateRonda(rondas);
        }

        return listRonda;
      } else {
        print("Erro ao verificar se a ronda conta na nuvem.");
        return null;
      }
    } catch (e) {
      print("Erro ao carregar lista.");
      return null;
    }
  }

  void _getAllRondas() {
    helper.getAllRondas().then((list) {
      setState(() {
        rondas = list;
      });
    });
  }
}
