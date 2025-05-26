import 'package:flutter/material.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:dbestudante/drawer_widget.dart'; // 👈 importação do Drawer externo

class Pag2Disciplina extends StatefulWidget {
  const Pag2Disciplina({super.key});

  @override
  State<Pag2Disciplina> createState() => _Pag2DisciplinaState();
}

class _Pag2DisciplinaState extends State<Pag2Disciplina> {
  final _disciplinaDao = DisciplinaDao();
  final _controllerNome = TextEditingController();
  final _controllerProfessor = TextEditingController();

  Disciplina? _disciplinaAtual;
  List<Disciplina> _listaDisciplinas = [];

  @override
  void initState() {
    super.initState();
    _carregarDisciplinas();
  }

  _carregarDisciplinas() async {
    List<Disciplina> temp = await _disciplinaDao.listarDisciplinas();
    setState(() {
      _listaDisciplinas = temp;
    });
  }

  _salvarOuEditar() async {
    if (_disciplinaAtual == null) {
      await _disciplinaDao.incluirDisciplina(
        Disciplina(
          nome: _controllerNome.text,
          professor: _controllerProfessor.text,
        ),
      );
    } else {
      _disciplinaAtual!.nome = _controllerNome.text;
      _disciplinaAtual!.professor = _controllerProfessor.text;
      await _disciplinaDao.editarDisciplina(_disciplinaAtual!);
    }

    _controllerNome.clear();
    _controllerProfessor.clear();
    setState(() {
      _disciplinaAtual = null;
    });
    _carregarDisciplinas();
  }

  _apagarDisciplina(int id) async {
    await _disciplinaDao.deleteDisciplina(id);
    _carregarDisciplinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Disciplina"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: appDrawer(context), // 👈 drawer reaproveitado
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controllerNome,
              decoration: const InputDecoration(
                labelText: "Nome da disciplina",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controllerProfessor,
              decoration: const InputDecoration(
                labelText: "Professor",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _salvarOuEditar,
              child: Text(_disciplinaAtual == null ? "Salvar" : "Atualizar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaDisciplinas.length,
              itemBuilder: (context, index) {
                final d = _listaDisciplinas[index];
                return ListTile(
                  title: Text(d.nome),
                  subtitle: Text(d.professor),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _apagarDisciplina(d.id!),
                  ),
                  onTap: () {
                    setState(() {
                      _disciplinaAtual = d;
                      _controllerNome.text = d.nome;
                      _controllerProfessor.text = d.professor;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
