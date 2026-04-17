import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

Future<int> process() async {
  await Future.delayed(Duration(seconds: 5));
  return 0;
}

Map<String, List<double>> alunos = {
  'Maria': [8.0, 9.0],
  'Bruna': [7.0, 7.0],
  'Carla': [10.0, 9.0],
};

Future<List<double>?> search(String key) async {
  return Future.delayed(Duration(seconds: 2), () {
    if (alunos.containsKey(key)) {
      return alunos[key]!;
    }
    throw ArgumentError('Aluno não encontrado.');
  });
}

Stream<int> count() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

Stream<double> media(List<String> nomes) async* {
  for (String nome in nomes) {
    try {
      List<double>? notas = await search(nome);
      if (notas != null) {
        double soma = notas.reduce((a, b) => a + b);
        double resultadoMedia = soma / notas.length;
        debugPrint('Calculando média de $nome: $resultadoMedia');
        yield resultadoMedia;
      }
    } catch (e) {
      // Capturamos o erro aqui para que a Stream não "morra"
      debugPrint('Aviso na função media: Aluno $nome não encontrado.');
    }
  }
}

void main() {
  group('Testes de programação assíncrona', () {
    late Future<int> result;
    setUp(() => result = process());
    test('Aguardando...', () => expect(result, isNotNull));
    test('Testando o resultado', () async {
      int num = await result;
      expect(num, 0);
    });
    test('Testando busca sem erros em Future', () {
      search('Maria').then((notas) => expect(notas, [8.0, 9.0]));
    });
    test('Testando busca com erros em Future', () {
      search('Paula').then((notas) {}).catchError((error) {
        expect(error, isA<ArgumentError>());
      });
    });
    test('Testando contagem em Stream', () {
      List<int> resultados = [];
      count().listen(
        (resultado) {
          resultados.add(resultado);
        },
        onDone: () {
          expect(resultados, [1, 2, 3]);
        },
        onError: (error) => expect(error, isNotNull),
      );
    });
    test('Testando media em Stream', () async {
      // Adicione async aqui
      List<double> resultados = [];

      debugPrint('--- Iniciando processamento da Stream de Médias ---');

      // Adicione o await e o .asFuture() no final
      await media(['Maria', 'Paula', 'Bruna'])
          .listen(
            (resultado) {
              debugPrint('Média recebida: $resultado');
              resultados.add(resultado);
            },
            onDone: () {
              debugPrint(
                'Stream finalizada. Resultados acumulados: $resultados',
              );
              expect(resultados, [8.5, 7.0]);
            },
            onError: (error) {
              debugPrint('Erro detectado na Stream: $error');
              // Note: Paula não disparará erro aqui por causa do try-catch no seu método media
            },
          )
          .asFuture();
    });
  });
}
