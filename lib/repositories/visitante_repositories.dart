import 'dart:convert';
import 'package:ronda/model/api_visitante.dart';
import 'package:http/http.dart' as http;

class VisitanteRepository {
  // http
  Future<List<Data>> getVisitanteHttp(visitanteid) async {
    try {
      List<Data> listVisitante = [];
      final response = await http.get(Uri.parse(
          'https://ronda.facilitahomeservice.com.br/rest.php?class=VisitanteService&method=getVisitante&visitante_id=' +
              visitanteid));

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        descodeJson['data']
            .forEach((item) => listVisitante.add(Data.fromJson(item)));
        //print(listMural);
        return listVisitante;
      } else {
        print(response);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
