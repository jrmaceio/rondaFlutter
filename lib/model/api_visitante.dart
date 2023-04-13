class api_visitante {
  String status;
  List<Data> data;

  api_visitante({this.status, this.data});

  api_visitante.fromJson(Map<String, dynamic> json) {
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
  String nome;
  String status;
  String postoId;
  String motivoFuncaoFinalidade;
  String documento;
  String telefone;
  String observacao;
  String permissaoDomIni;
  String permissaoDomFim;
  String permissaoSegIni;
  String permissaoSegFim;
  String permissaoTerIni;
  String permissaoTerFim;
  String permissaoQuaIni;
  String permissaoQuaFim;
  String permissaoQuiIni;
  String permissaoQuiFim;
  String permissaoSexIni;
  String permissaoSexFim;
  String permissaoSabIni;
  String permissaoSabFim;
  String dataPermitida;
  String dataIni;
  String dataFim;
  String unidadeId;

  Data(
      {this.id,
      this.nome,
      this.status,
      this.postoId,
      this.motivoFuncaoFinalidade,
      this.documento,
      this.telefone,
      this.observacao,
      this.permissaoDomIni,
      this.permissaoDomFim,
      this.permissaoSegIni,
      this.permissaoSegFim,
      this.permissaoTerIni,
      this.permissaoTerFim,
      this.permissaoQuaIni,
      this.permissaoQuaFim,
      this.permissaoQuiIni,
      this.permissaoQuiFim,
      this.permissaoSexIni,
      this.permissaoSexFim,
      this.permissaoSabIni,
      this.permissaoSabFim,
      this.dataPermitida,
      this.dataIni,
      this.dataFim,
      this.unidadeId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    status = json['status'];
    postoId = json['posto_id'];
    motivoFuncaoFinalidade = json['motivo_funcao_finalidade'];
    documento = json['documento'];
    telefone = json['telefone'];
    observacao = json['observacao'];
    permissaoDomIni = json['permissao_dom_ini'];
    permissaoDomFim = json['permissao_dom_fim'];
    permissaoSegIni = json['permissao_seg_ini'];
    permissaoSegFim = json['permissao_seg_fim'];
    permissaoTerIni = json['permissao_ter_ini'];
    permissaoTerFim = json['permissao_ter_fim'];
    permissaoQuaIni = json['permissao_qua_ini'];
    permissaoQuaFim = json['permissao_qua_fim'];
    permissaoQuiIni = json['permissao_qui_ini'];
    permissaoQuiFim = json['permissao_qui_fim'];
    permissaoSexIni = json['permissao_sex_ini'];
    permissaoSexFim = json['permissao_sex_fim'];
    permissaoSabIni = json['permissao_sab_ini'];
    permissaoSabFim = json['permissao_sab_fim'];
    dataPermitida = json['data_permitida'];
    dataIni = json['data_ini'];
    dataFim = json['data_fim'];
    unidadeId = json['unidade_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['status'] = this.status;
    data['posto_id'] = this.postoId;
    data['motivo_funcao_finalidade'] = this.motivoFuncaoFinalidade;
    data['documento'] = this.documento;
    data['telefone'] = this.telefone;
    data['observacao'] = this.observacao;
    data['permissao_dom_ini'] = this.permissaoDomIni;
    data['permissao_dom_fim'] = this.permissaoDomFim;
    data['permissao_seg_ini'] = this.permissaoSegIni;
    data['permissao_seg_fim'] = this.permissaoSegFim;
    data['permissao_ter_ini'] = this.permissaoTerIni;
    data['permissao_ter_fim'] = this.permissaoTerFim;
    data['permissao_qua_ini'] = this.permissaoQuaIni;
    data['permissao_qua_fim'] = this.permissaoQuaFim;
    data['permissao_qui_ini'] = this.permissaoQuiIni;
    data['permissao_qui_fim'] = this.permissaoQuiFim;
    data['permissao_sex_ini'] = this.permissaoSexIni;
    data['permissao_sex_fim'] = this.permissaoSexFim;
    data['permissao_sab_ini'] = this.permissaoSabIni;
    data['permissao_sab_fim'] = this.permissaoSabFim;
    data['data_permitida'] = this.dataPermitida;
    data['data_ini'] = this.dataIni;
    data['data_fim'] = this.dataFim;
    data['unidade_id'] = this.unidadeId;
    return data;
  }
}
