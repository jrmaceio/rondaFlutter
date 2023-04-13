import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page_controller.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomePageController());

  HomePage() {
    Get.put(HomePageController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FacilitaSmart Ronda Eletrônica'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
              'Info',
              'Operador: ' +
                  controller.patrulheiro_id +
                  '\n\n' +
                  ' Tipo Configurado: ' +
                  controller.tipo +
                  '\n\n' +
                  ' Localização: ' +
                  controller.latitudelongitude +
                  '\n\n');
        },
        tooltip: 'Info',
        child: Icon(Icons.info),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QRCode:',
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
              label: Text('Ler Código de Barras',
                  style: Get.theme.textTheme.headline6),
              onPressed: () =>
                  Get.find<HomePageController>().escanearCodigoBarras(),
            ),
          ],
        ),
      ),
    );
  }
}
