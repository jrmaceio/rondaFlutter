import 'package:ronda/controllers/visitante_controller.dart';
import 'package:flutter/material.dart';
import 'package:ronda/helpers/visitante_helper.dart';

class Visitante extends StatefulWidget {
  @override
  _VisitanteState createState() => _VisitanteState();
}

// roteiro: chama xxx_controller, que chama xxx_reporitory

class _VisitanteState extends State<Visitante> {
  final controller = VisitanteController(); // inicializar o controller

  VisitanteHelper helper = VisitanteHelper();

  List<Visitante> visitantes = [];

  //List<Api> _api;

  _success() {
    return ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: controller.api.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.airplay, color: Colors.black),
            title: Text(controller.api[index].nome ?? "",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            trailing: controller.api[index].status == 'Y'
                ? Icon(Icons.alarm, color: Colors.green)
                : Icon(Icons.room_service, color: Colors.red),
            subtitle: Text(
              controller.api[index].documento,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
            selected: true,
          );
        });
  }

  // pod desligar a internet para provocar esse erro
  _erros() {
    return Center(
        child: ElevatedButton(
      child: Text('Tentar novamente ...'),
      onPressed: () {
        //print('Pressed');
        //controller.start();
      },
    )
        /*RaisedButton(
        onPressed: () {
          controller.start();
        },
        child: Text('Tentar novamente'),
      ),*/
        );
  }

  _loading() {
    return Center(child: CircularProgressIndicator());
  }

  _start() {
    return Container();
  }

  // controlando o estado
  stateManagement(VisitanteState state) {
    switch (state) {
      case VisitanteState.start:
        return _start();
      case VisitanteState.loading:
        return _loading();
      case VisitanteState.error:
        return _erros();
      case VisitanteState.success:
        return _success();
      default:
        return _start();
    }
  }

  @override
  void initState() {
    // deleta o banco
    //helper.deleteDb();

    //pegar o que está gravado
    helper.getAllVisitantes().then((list) {
      setState(() {
        //atualiza a tela
        visitantes = list;
        print(visitantes);
      });
    });

    // troca o estado com valuenotifier
    controller.start('6');
    super.initState();
  }

  @override
  void dispose() {
    // DO STUFF
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitante',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
              icon: Icon(Icons.refresh_outlined),
              onPressed: () {
                controller.start('6');
              })
        ],
      ),
      //backgroundColor: Colors.purple[800],
      //extendBody: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: AnimatedBuilder(
              animation: controller.state,
              builder: (context, child) {
                return stateManagement(controller.state.value);
              },
            ),
          ),
          Expanded(
            child: Text('testetetete et etete te ete'),
          ),
        ],
      ),
    );
  }
}
