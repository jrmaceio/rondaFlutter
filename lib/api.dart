class Api {
  String status;
  List<Data> data;

  Api({this.status, this.data});

  Api.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String unidadeId;
  String tipoId;
  String horaRonda;
  String dataRonda;
  String descricao;
  String statusTratamento;
  String patrulheiroId;
  String pontoRondaId;
  String postoId;
  String latitude;
  String longitude;
  String dataHoraAtualizacao;

  Data(
      {this.id,
      this.unidadeId,
      this.tipoId,
      this.horaRonda,
      this.dataRonda,
      this.descricao,
      this.statusTratamento,
      this.patrulheiroId,
      this.pontoRondaId,
      this.postoId,
      this.latitude,
      this.longitude,
      this.dataHoraAtualizacao});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unidadeId = json['unidade_id'];
    tipoId = json['tipo_id'];
    horaRonda = json['hora_ronda'];
    dataRonda = json['data_ronda'];
    descricao = json['descricao'];
    statusTratamento = json['status_tratamento'];
    patrulheiroId = json['patrulheiro_id'];
    pontoRondaId = json['ponto_ronda_id'];
    postoId = json['posto_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dataHoraAtualizacao = json['data_hora_atualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unidade_id'] = this.unidadeId;
    data['tipo_id'] = this.tipoId;
    data['hora_ronda'] = this.horaRonda;
    data['data_ronda'] = this.dataRonda;
    data['descricao'] = this.descricao;
    data['status_tratamento'] = this.statusTratamento;
    data['patrulheiro_id'] = this.patrulheiroId;
    data['ponto_ronda_id'] = this.pontoRondaId;
    data['posto_id'] = this.postoId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['data_hora_atualizacao'] = this.dataHoraAtualizacao;
    return data;
  }
}
