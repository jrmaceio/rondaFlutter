import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String visitanteTable = "visitanteTable";
final String idColumn = "idColumn";
final String patrulheiro_idColumn = "patrulheiro_idColumn";
final String visitante_idColumn = "visitante_idColumn";
final String posto_idColumn = "posto_idColumn";
final String latitudeColumn = "latitudeColumn";
final String longitudeColumn = "longitudeColumn";

// banco sqlite somente com um registro para gravar os dados que foram lido no qrcode do visitante naquele momento
// com a finalidade de prover dados para a tela de analise de dados do visitante
// banco somente com o registro id=1
class VisitanteHelper {
  static final VisitanteHelper _instance = VisitanteHelper.internal();

  factory VisitanteHelper() => _instance;

  VisitanteHelper.internal();

  Database _db;

  // inicializar banco de dados
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "visitante.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $visitanteTable("
          "$idColumn INTEGER PRIMARY KEY,"
          "$patrulheiro_idColumn TEXT,"
          "$posto_idColumn TEXT,"
          "$visitante_idColumn TEXT,"
          "$latitudeColumn TEXT,"
          "$longitudeColumn TEXT)");
    });
  }

  // apagar o banco de teste
  Future<Database> deleteDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "visitante.db");
    await deleteDatabase(path);
  }

  Future<Visitante> saveVisitante(Visitante visitante) async {
    Database dbVisitante = await db;
    visitante.id = await dbVisitante.insert(visitanteTable, visitante.toMap());
    return visitante;
  }

  Future<Visitante> getVisitante(int id) async {
    Database dbVisitante = await db;
    List<Map> maps = await dbVisitante.query(visitanteTable,
        columns: [
          idColumn,
          patrulheiro_idColumn,
          visitante_idColumn,
          posto_idColumn,
          latitudeColumn,
          longitudeColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Visitante.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteVisitante(int id) async {
    Database dbVisitante = await db;
    return await dbVisitante
        .delete(visitanteTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateVisitante(Visitante visitante) async {
    Database dbVisitante = await db;
    return await dbVisitante.update(visitanteTable, visitante.toMap(),
        where: "$idColumn = ?", whereArgs: [visitante.id]);
  }

  Future<List> getAllVisitantes() async {
    Database dbVisitante = await db;
    List listMap = await dbVisitante.rawQuery("SELECT * FROM $visitanteTable");
    List<Visitante> listVisitante = List();
    for (Map m in listMap) {
      listVisitante.add(Visitante.fromMap(m));
    }
    return listVisitante;
  }

  //exemplo de como pegar a qtd de registros
  //Future<int> getNumber() async {
  //  Database dbContact = await db;
  //  return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  //}

  Future close() async {
    Database dbVisitante = await db;
    dbVisitante.close();
  }
}

class Visitante {
  // deixei todos os int como string porque não vai importar na hora de chamar a api
  int id;
  String patrulheiro_id;
  String visitante_id;
  String posto_id;
  String latitude;
  String longitude;

  Visitante(); // construtor vazio, para eu chamar na hora de fazer os testes de inserir um regsitro

  Visitante.fromMap(Map map) {
    id = map[idColumn];
    patrulheiro_id = map[patrulheiro_idColumn];
    visitante_id = map[visitante_idColumn];
    posto_id = map[posto_idColumn];
    latitude = map[latitudeColumn];
    longitude = map[longitudeColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      patrulheiro_idColumn: patrulheiro_id,
      visitante_idColumn: visitante_id,
      posto_idColumn: posto_id,
      latitudeColumn: latitude,
      longitudeColumn: longitude
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Visitante(patrulheiro_id: $patrulheiro_id, visitante_id: $visitante_id, posto_id: $posto_id, latitude: $latitude, longitude: $longitude)";
  }
}
