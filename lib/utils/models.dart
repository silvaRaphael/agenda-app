class ModelEscolaridade {
  final int codEscolaridade;
  final String escolaridade;
  const ModelEscolaridade({
    required this.codEscolaridade,
    required this.escolaridade,
  });
}

class ModelTipoVaga {
  final int codTipoVaga;
  final String tipoVaga;
  const ModelTipoVaga({
    required this.codTipoVaga,
    required this.tipoVaga,
  });
}

class ModelEstado {
  final int id;
  final String nome;
  final String sigla;
  const ModelEstado({
    required this.id,
    required this.nome,
    required this.sigla,
  });
}

class ModelCidade {
  final int id;
  final int idUf;
  final String nome;
  const ModelCidade({
    required this.id,
    required this.idUf,
    required this.nome,
  });
}

class ModelDisponibilidade {
  final int diaSemana;
  int horaInicial;
  int horaFinal;
  bool disponivel = true;
  ModelDisponibilidade({
    required this.diaSemana,
    required this.horaInicial,
    required this.horaFinal,
    required this.disponivel,
  });
}

class ModelAgendamento {
  final String name;
  final DateTime date;
  final double value;
  final int type;
  final bool entry;
  const ModelAgendamento({
    required this.name,
    required this.date,
    required this.value,
    required this.type,
    required this.entry,
  });
}
