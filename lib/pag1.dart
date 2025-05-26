import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:flutter/material.dart';
import 'package:dbestudante/drawer_widget.dart';

class pag1 extends StatefulWidget {
  const pag1({super.key});

  @override
  State<pag1> createState() => _pag1State();
}

class _pag1State extends State<pag1> {
  final _estudanteDAO = EstudanteDao();
  Estudante? _estudanteAtual;

  final _controllerNome = TextEditingController();
  final _controllerMatricula = TextEditingController();
  List<Estudante> _listaEstudantes = [];

  @override
  void initState() {
    super.initState();
    _loadEstudantes();
  }

  _loadEstudantes() async {
    List<Estudante> temp = await _estudanteDAO.listarEstudantes();
    setState(() {
      _listaEstudantes = temp;
    });
  }

  _salvarOUEditar() async {
    if (_estudanteAtual == null) {
      await _estudanteDAO.incluirEstudante(
        Estudante(
          nome: _controllerNome.text,
          matricula: _controllerMatricula.text,
        ),
      );
    } else {
      _estudanteAtual!.nome = _controllerNome.text;
      _estudanteAtual!.matricula = _controllerMatricula.text;
      await _estudanteDAO.editarEstudante(_estudanteAtual!);
    }
    _controllerNome.clear();
    _controllerMatricula.clear();
    setState(() {
      _estudanteAtual = null;
    });
    _loadEstudantes();
  }

  _apagarEstudante(int index) async {
    await _estudanteDAO.deleteEstudante(index);
    _loadEstudantes();
  }

  _editarEstudante(Estudante e) async {
    await _estudanteDAO.editarEstudante(e);
    _loadEstudantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Estudante"),
        backgroundColor: Colors.cyan,
      ),
      drawer: appDrawer(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerNome,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerMatricula,
              decoration: const InputDecoration(
                labelText: "Matrícula",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _salvarOUEditar,
              child: Text(_estudanteAtual == null ? "Salvar" : "Atualizar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaEstudantes.length,
              itemBuilder: (context, index) {
                final estudante = _listaEstudantes[index];
                return ListTile(
                  title: Text(estudante.nome),
                  subtitle: Text(estudante.matricula),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _apagarEstudante(estudante.id!),
                  ),
                  onTap: () {
                    setState(() {
                      _estudanteAtual = estudante;
                      _controllerNome.text = estudante.nome;
                      _controllerMatricula.text = estudante.matricula;
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
