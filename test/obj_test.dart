import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class Pessoa {
  late int _id;
  String nome;

  Pessoa(this.nome);

  int get id => _id;

  set id(int id) {
    if (id > 0) {
      _id = id;
    } else {
      throw ArgumentError('Identificador deve ser não negativo.');
    }
  }
}

mixin Ano {
  late int _ano;

  int get ano => _ano;

  set ano(int ano) {
    if (ano > 0) {
      _ano = ano;
    } else {
      throw ArgumentError('Ano deve ser maior que zero.');
    }
  }
}

class Aluno extends Pessoa with Ano {
  Aluno(super.nome, int ano) {
    this.ano = ano;
  }
}

class Disciplina {
  String nome;
  Disciplina(this.nome);
}

class Turma with Ano {
  Disciplina disciplina;
  Professor professor;
  final List<Aluno> _alunos = [];

  Turma(this.disciplina, this.professor, int ano) {
    this.ano = ano;
  }

  void matricular(Aluno aluno) {
    if (aluno.ano == ano) {
      _alunos.add(aluno);
    } else {
      throw ArgumentError('Ano deve ser mesmo.');
    }
  }
}

class Historico extends Turma {
  Map<Aluno, List<double>> notas = {};

  Historico(super.disciplina, super.professor, super.ano);

  @override
  void matricular(Aluno aluno) {
    super.matricular(aluno);
    notas[aluno] = [];
  }

  double media(Aluno aluno) {
    double media = 0;
    if (notas[aluno]!.isEmpty) return 0.0;
    for (double nota in notas[aluno]!) {
      media += nota;
    }
    media /= notas[aluno]!.length;
    return media;
  }

  bool isAprovado(Aluno aluno) {
    return media(aluno) > 6;
  }
}

class Professor extends Pessoa {
  Professor(super.nome);
}

void main() {
  test('Testar matrícula de alunos', () {
    debugPrint('--- Iniciando Testes ---');
    Disciplina disciplina1 = Disciplina('Flutter');
    Professor professor1 = Professor('João Silva'); // Objeto Professor criado
    Historico historico1 = Historico(disciplina1, professor1, 2023);

    // Cadastrar primeiro aluno sem erros
    Aluno aluno1 = Aluno('Maria', 2023);
    aluno1.id = 1;
    historico1.matricular(aluno1);

    debugPrint('\nTestando Aluno 1 (Maria) sem notas:');
    debugPrint(
      'Média atual: ${historico1.media(aluno1)} | Média esperada: 0.0',
    );
    expect(historico1.media(aluno1), 0.0);

    // Uso do operador ternário para formatar a saída booleana
    debugPrint(
      'Status aprovação atual: ${historico1.isAprovado(aluno1) ? "Aprovado" : "Reprovado"} | Status esperado: Reprovado',
    );
    expect(historico1.isAprovado(aluno1), false);

    // Inserindo notas para testar o método isAprovado
    historico1.notas[aluno1]!.addAll([7.0, 8.0]);

    debugPrint('\nTestando Aluno 1 (Maria) recebe notas 7.0 e 8.0:');
    debugPrint(
      'Média atual: ${historico1.media(aluno1)} | Média esperada: 7.5',
    );
    expect(historico1.media(aluno1), 7.5);

    // Uso do operador ternário novamente
    debugPrint(
      'Status aprovação atual: ${historico1.isAprovado(aluno1) ? "Aprovado" : "Reprovado"} | Status esperado: Aprovado',
    );
    expect(historico1.isAprovado(aluno1), true);

    // Cadastrar segundo aluno com erros
    debugPrint('\nTestando Aluno 2 (Paula - Ano Incorreto e ID inválido):');
    Aluno aluno2 = Aluno('Paula', 2022);

    try {
      aluno2.id = 0;
    } catch (error) {
      debugPrint('Erro esperado ao setar ID 0 capturado: $error');
      expect(error, isA<ArgumentError>());
    }

    try {
      historico1.matricular(aluno2);
    } catch (error) {
      debugPrint(
        'Erro esperado ao matricular aluno de ano diferente capturado: $error',
      );
      expect(error, isA<ArgumentError>());
    }
  });
}
