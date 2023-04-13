import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ronda/home_page_controller.dart';
import 'package:ronda/rondas.dart';

class HomePage extends StatefulWidget {
  HomePage() {
    Get.put(HomePageController());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Acesso e Ronda Eletrônica'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          //Get.snackbar(
          //    'Info',
          //    'Operador: ' +
          //        controller.patrulheiro_id +
          //        '\n\n' +
          //        ' Tipo Configurado: ' +
          //        controller.tipo +
          //        '\n\n' +
          //        ' Localização: ' +
          //        controller.latitudelongitude +
          //        '\n\n');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RondaPage()),
          );
        },
        tooltip: 'Info',
        child: Icon(Icons.info),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Configuração:',
              style: Get.theme.textTheme.headline4
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            GetBuilder<HomePageController>(
              builder: (controller) {
                return Text(
                  controller.valorCodigoBarras,
                  style: Get.theme.textTheme.headline5,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextButton.icon(
                icon: Image.asset(
                  'assets/icon.png',
                  width: 50,
                ),
                label: Text('Visitante', style: Get.theme.textTheme.headline6),
                onPressed: () {
                  Navigator.of(context).pushNamed("/visitante");
                }),
            TextButton.icon(
                icon: Image.asset(
                  'assets/icon.png',
                  width: 50,
                ),
                label: Text('Ler QRCode', style: Get.theme.textTheme.headline6),
                onPressed: () {
                  Get.find<HomePageController>().escanearCodigoBarras();
                }),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 100,
                color: Colors.orange,
                child: Center(
                    child: Text(
                        "Suporte (82) 98105-9908 facilitahomeservice@gmail.com")))
          ],
        ),
      ),
    );
  }
}
