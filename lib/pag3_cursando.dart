import 'package:flutter/material.dart';
import 'package:dbestudante/cursando.dart';
import 'package:dbestudante/cursando_dao.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:dbestudante/drawer_widget.dart'; // 👈 Importação do Drawer

class Pag3Cursando extends StatefulWidget {
  const Pag3Cursando({super.key});

  @override
  State<Pag3Cursando> createState() => _Pag3CursandoState();
}

class _Pag3CursandoState extends State<Pag3Cursando> {
  final _cursandoDao = CursandoDao();
  final _estudanteDao = EstudanteDao();
  final _disciplinaDao = DisciplinaDao();

  List<Estudante> _estudantes = [];
  List<Disciplina> _disciplinas = [];
  Estudante? _estudanteSelecionado;
  Map<int, bool> _disciplinasSelecionadas = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async {
    final estudantes = await _estudanteDao.listarEstudantes();
    final disciplinas = await _disciplinaDao.listarDisciplinas();

    setState(() {
      _estudantes = estudantes;
      _disciplinas = disciplinas;
      _disciplinasSelecionadas = {
        for (var d in disciplinas) d.id!: false,
      };
    });
  }

  _salvarVinculo() async {
    if (_estudanteSelecionado == null) return;

    for (var d in _disciplinasSelecionadas.entries) {
      if (d.value) {
        await _cursandoDao.incluirCursando(
          Cursando(
            idEstudante: _estudanteSelecionado!.id!,
            idDisciplina: d.key,
          ),
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Disciplinas vinculadas com sucesso!")),
    );
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vincular Estudante a Disciplinas"),
        backgroundColor: Colors.green,
      ),
      drawer: appDrawer(context), // 👈 Drawer externo
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Selecione um estudante:"),
          ),
          DropdownButton<Estudante>(
            isExpanded: true,
            value: _estudanteSelecionado,
            hint: const Text("Escolha um estudante"),
            items: _estudantes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text("${e.nome} (${e.matricula})"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _estudanteSelecionado = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Selecione as disciplinas:"),
          ),
          Expanded(
            child: ListView(
              children: _disciplinas.map((disc) {
                return CheckboxListTile(
                  title: Text(disc.nome),
                  subtitle: Text("Prof: ${disc.professor}"),
                  value: _disciplinasSelecionadas[disc.id] ?? false,
                  onChanged: (val) {
                    setState(() {
                      _disciplinasSelecionadas[disc.id!] = val ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _salvarVinculo,
            child: const Text("Salvar vínculos"),
          ),
        ],
      ),
    );
  }
}
