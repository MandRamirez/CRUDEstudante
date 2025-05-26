import 'package:flutter/material.dart';
import 'package:dbestudante/cursando_dao.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/drawer_widget.dart'; // 👈 Importação do Drawer

class Pag4Vinculos extends StatefulWidget {
  const Pag4Vinculos({super.key});

  @override
  State<Pag4Vinculos> createState() => _Pag4VinculosState();
}

class _Pag4VinculosState extends State<Pag4Vinculos> {
  final _estudanteDao = EstudanteDao();
  final _disciplinaDao = DisciplinaDao();
  final _cursandoDao = CursandoDao();

  List<Estudante> _estudantes = [];
  List<Disciplina> _disciplinas = [];
  Estudante? _estudanteSelecionado;
  Disciplina? _disciplinaSelecionada;

  List<Disciplina> _disciplinasDoEstudante = [];
  List<Estudante> _estudantesDaDisciplina = [];

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
    });
  }

  _buscarDisciplinasDoEstudante(int idEstudante) async {
    final join = await _cursandoDao.buscarDisciplinasPorEstudante(idEstudante);
    setState(() {
      _disciplinasDoEstudante = join;
      _disciplinaSelecionada = null;
    });
  }

  _buscarEstudantesDaDisciplina(int idDisciplina) async {
    final join = await _cursandoDao.buscarEstudantesPorDisciplina(idDisciplina);
    setState(() {
      _estudantesDaDisciplina = join;
      _estudanteSelecionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vínculos Estudante x Disciplina"),
        backgroundColor: Colors.indigo,
      ),
      drawer: appDrawer(context), // 👈 Drawer reutilizável
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Buscar Disciplinas por Estudante"),
            DropdownButton<Estudante>(
              value: _estudanteSelecionado,
              hint: const Text("Selecione um estudante"),
              isExpanded: true,
              items: _estudantes.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text("${e.nome} (${e.matricula})"),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _estudanteSelecionado = value);
                  _buscarDisciplinasDoEstudante(value.id!);
                }
              },
            ),
            if (_disciplinasDoEstudante.isNotEmpty)
              ..._disciplinasDoEstudante.map((d) => ListTile(
                    title: Text(d.nome),
                    subtitle: Text("Prof. ${d.professor}"),
                  )),

            const SizedBox(height: 32),
            const Text("Buscar Estudantes por Disciplina"),
            DropdownButton<Disciplina>(
              value: _disciplinaSelecionada,
              hint: const Text("Selecione uma disciplina"),
              isExpanded: true,
              items: _disciplinas.map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: Text(d.nome),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _disciplinaSelecionada = value);
                  _buscarEstudantesDaDisciplina(value.id!);
                }
              },
            ),
            if (_estudantesDaDisciplina.isNotEmpty)
              ..._estudantesDaDisciplina.map((e) => ListTile(
                    title: Text(e.nome),
                    subtitle: Text("Matrícula: ${e.matricula}"),
                  )),
          ],
        ),
      ),
    );
  }
}
