import 'package:dbestudante/DatabaseHelper.dart';
import 'package:dbestudante/cursando.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:sqflite/sqflite.dart';

class CursandoDao {
  final Databasehelper _dbHelper = Databasehelper();

  Future<void> incluirCursando(Cursando c) async {
    final db = await _dbHelper.database;
    await db.insert("cursando", c.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> deletarCursando(int idEstudante, int idDisciplina) async {
    final db = await _dbHelper.database;
    await db.delete(
      "cursando",
      where: "id_estudante = ? AND id_disciplina = ?",
      whereArgs: [idEstudante, idDisciplina],
    );
  }

  Future<List<Cursando>> listarCursando() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("cursando");
    return List.generate(maps.length, (i) => Cursando.fromMap(maps[i]));
  }

  // 🔍 JOIN: retorna todas as disciplinas de um estudante
  Future<List<Disciplina>> buscarDisciplinasPorEstudante(int idEstudante) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT d.* FROM disciplina d
      INNER JOIN cursando c ON d.id = c.id_disciplina
      WHERE c.id_estudante = ?
    ''', [idEstudante]);

    return result.map((map) => Disciplina.fromMap(map)).toList();
  }

  // 🔍 JOIN: retorna todos os estudantes que cursam uma disciplina
  Future<List<Estudante>> buscarEstudantesPorDisciplina(int idDisciplina) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT e.* FROM estudante e
      INNER JOIN cursando c ON e.id = c.id_estudante
      WHERE c.id_disciplina = ?
    ''', [idDisciplina]);

    return result.map((map) => Estudante.fromMap(map)).toList();
  }
}
