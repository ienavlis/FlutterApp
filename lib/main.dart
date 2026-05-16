import 'package:flutter/material.dart';
import 'components.dart';
import 'students_page.dart';
import 'theme.dart'; // Importação obrigatória para o tema da Semana 11 [cite: 11]

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silvanei Flutter Demo',
      // Configuração dos esquemas de cores conforme o roteiro
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(), // Tema claro verde
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: MaterialTheme.darkScheme(), // Tema escuro
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Alterna conforme o sistema
      home: const MyHomePage(title: 'Silvanei Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Usa as cores automáticas do novo tema verde
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // Seu Menu Lateral preservado
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Menu',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.pages),
                title: const Text('Componentes'),
                onTap: () {
                  Navigator.pop(context); // fecha o drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComponentsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Alunos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StudentsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _incrementCounter,
              child: const Text('Increment'),
            ),
            TextButton(
              onPressed: _decrementCounter,
              child: const Text('Decrement'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
