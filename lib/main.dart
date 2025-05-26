import 'package:flutter/material.dart';
import 'package:dbestudante/pag1.dart';
import 'package:dbestudante/pag2_disciplina.dart';
import 'package:dbestudante/pag3_cursando.dart';
import 'package:dbestudante/pag4_vinculos.dart'; // ⬅️ importar a nova tela

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CRUD Estudante",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const pag1(),
        '/disciplinas': (context) => const Pag2Disciplina(),
        '/cursando': (context) => const Pag3Cursando(),
        '/vinculos': (context) => const Pag4Vinculos(), // ✅ nova rota adicionada
      },
    );
  }
}
