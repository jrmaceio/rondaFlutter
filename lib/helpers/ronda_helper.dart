import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String rondaTable = "rondaTable";
final String idColumn = "idColumn";
// ignore: non_constant_identifier_names
final String unidade_idColumn = "unidade_idColumn";
// ignore: non_constant_identifier_names
final String tipo_idColumn = "tipo_idColumn";
// ignore: non_constant_identifier_names
final String hora_rondaColumn = "hora_rondaColumn";
// ignore: non_constant_identifier_names
final String data_rondaColumn = "data_rondaColumn";
final String descricaoColumn = "descricaoColumn";
// ignore: non_constant_identifier_names
final String status_tratamentoColumn = "status_tratamentoColumn";
// ignore: non_constant_identifier_names
final String patrulheiro_idColumn = "patrulheiro_idColumn";
// ignore: non_constant_identifier_names
final String ponto_ronda_idColumn = "ponto_ronda_idColumn";
// ignore: non_constant_identifier_names
final String posto_idColumn = "posto_idColumn";
final String latitudeColumn = "latitudeColumn";
final String longitudeColumn = "longitudeColumn";
final String sincronizadoColumn = "sincronizadoColumn";

class RondaHelper {
  static final RondaHelper _instance = RondaHelper.internal();

  factory RondaHelper() => _instance;

  RondaHelper.internal();

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
    final path = join(databasesPath, "ronda.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $rondaTable("
          "$idColumn INTEGER PRIMARY KEY,"
          "$unidade_idColumn TEXT,"
          "$tipo_idColumn TEXT,"
          "$hora_rondaColumn TEXT,"
          "$data_rondaColumn TEXT,"
          "$descricaoColumn TEXT,"
          "$status_tratamentoColumn TEXT,"
          "$patrulheiro_idColumn TEXT,"
          "$ponto_ronda_idColumn TEXT,"
          "$posto_idColumn TEXT,"
          "$latitudeColumn TEXT,"
          "$longitudeColumn TEXT,"
          "$sincronizadoColumn TEXT)");
    });
  }

  // apagar o banco de teste
  // ignore: missing_return
  Future<Database> deleteDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "ronda.db");
    await deleteDatabase(path);
  }

  Future<Ronda> saveRonda(Ronda ronda) async {
    Database dbRonda = await db;
    ronda.id = await dbRonda.insert(rondaTable, ronda.toMap());
    return ronda;
  }

  Future<Ronda> getRonda(int id) async {
    Database dbRonda = await db;
    List<Map> maps = await dbRonda.query(rondaTable,
        columns: [
          idColumn,
          unidade_idColumn,
          tipo_idColumn,
          hora_rondaColumn,
          data_rondaColumn,
          descricaoColumn,
          status_tratamentoColumn,
          patrulheiro_idColumn,
          ponto_ronda_idColumn,
          posto_idColumn,
          latitudeColumn,
          longitudeColumn,
          sincronizadoColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Ronda.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRondaSinc() async {
    Database dbRonda = await db;
    return await dbRonda
        .delete(rondaTable, where: "$sincronizadoColumn = ?", whereArgs: [1]);
  }

  Future<int> deleteRonda(int id) async {
    Database dbRonda = await db;
    return await dbRonda
        .delete(rondaTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateRonda(Ronda ronda) async {
    Database dbRonda = await db;
    return await dbRonda.update(rondaTable, ronda.toMap(),
        where: "$idColumn = ?", whereArgs: [ronda.id]);
  }

  Future<List> getAllRondas() async {
    Database dbRonda = await db;
    List listMap = await dbRonda.rawQuery("SELECT * FROM $rondaTable");
    List<Ronda> listRonda = List();
    for (Map m in listMap) {
      listRonda.add(Ronda.fromMap(m));
    }
    return listRonda;
  }

  //exemplo de como pegar a qtd de registros
  //Future<int> getNumber() async {
  //  Database dbContact = await db;
  //  return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  //}

  Future close() async {
    Database dbRonda = await db;
    dbRonda.close();
  }
}

class Ronda {
  // deixei todos os int como string porque não vai importar na hora de chamar a api
  int id;
  // ignore: non_constant_identifier_names
  String unidade_id;
  // ignore: non_constant_identifier_names
  String tipo_id;
  // ignore: non_constant_identifier_names
  String hora_ronda;
  // ignore: non_constant_identifier_names
  String data_ronda;
  String descricao;
  // ignore: non_constant_identifier_names
  String status_tratamento;
  // ignore: non_constant_identifier_names
  String patrulheiro_id;
  // ignore: non_constant_identifier_names
  String ponto_ronda_id;
  // ignore: non_constant_identifier_names
  String posto_id;
  String latitude;
  String longitude;
  String sincronizado;

  Ronda(); // construtor vazio, para eu chamar na hora de fazer os testes de inserir um regsitro

  Ronda.fromMap(Map map) {
    id = map[idColumn];
    unidade_id = map[unidade_idColumn];
    tipo_id = map[tipo_idColumn];
    hora_ronda = map[hora_rondaColumn];
    data_ronda = map[data_rondaColumn];
    descricao = map[descricaoColumn];
    status_tratamento = map[status_tratamentoColumn];
    patrulheiro_id = map[patrulheiro_idColumn];
    ponto_ronda_id = map[ponto_ronda_idColumn];
    posto_id = map[posto_idColumn];
    latitude = map[latitudeColumn];
    longitude = map[longitudeColumn];
    sincronizado = map[sincronizadoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      unidade_idColumn: unidade_id,
      tipo_idColumn: tipo_id,
      hora_rondaColumn: hora_ronda,
      data_rondaColumn: data_ronda,
      descricaoColumn: descricao,
      status_tratamentoColumn: status_tratamento,
      patrulheiro_idColumn: patrulheiro_id,
      ponto_ronda_idColumn: ponto_ronda_id,
      posto_idColumn: posto_id,
      latitudeColumn: latitude,
      longitudeColumn: longitude,
      sincronizadoColumn: sincronizado
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Ronda(unidade_id: $unidade_id, tipo_id: $tipo_id, hora_ronda: $hora_ronda, data_ronda: $data_ronda, descricao: $descricao, status_tratamento: $status_tratamento, patrulheiro_id: $patrulheiro_id, ponto_ronda_id: $ponto_ronda_id, posto_id: $posto_id, latitude: $latitude, longitude: $longitude, sincronizado: $sincronizado)";
  }
}
