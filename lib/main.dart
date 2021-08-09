import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {

    //Pegando o caminho tanto no Android como no IOS
    final caminhoBancoDados = await getDatabasesPath();
    //Recuperando o caminho do banco de dados
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    //Criando o banco de dados
    var db = await openDatabase(
      localBancoDados,
      version: 2,
      //Ele executa uma função anonima ao ser criado que recebe o banco de
        //dados e a versão mais recebte
      onCreate: (db, dbVersaoRecente){
        //Uma variavel que recebe o comando SQL
        String sql = "CREATE TABLE usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }

    );

    //print("aberto: " + bd.isOpen.toString());
    return db;
  }

  //Método responsavel por salvar no banco de dado
  _salvar() async{
    Database db = await _recuperarBancoDados();

    //Map responsavel por armazenar as informações do usuário
    Map<String, dynamic> dadosUsuario = {
      //Todas as chaves devem ter o mesmo nome que no banco de dados
      "nome": "Doglas Monte Negro",
      "idade": 46,
    };

    //Inserindo valores na tabela
    int id = await db.insert("usuario", dadosUsuario);

    //print("Salvo: $id");
  }

  //Método responsavel por recuperar as informações no banco de dados
  _listarUsuario() async {
    Database db = await _recuperarBancoDados();

    //Uma variável para armazenar o comando SQL
    //Recuperando todas as informações da tabela usuario
    String sql = "SELECT * FROM usuario";
    //Recuperando os usuarios que tem idade igual a 46
    //String sql = "SELECT * FROM usuario WHERE idade = 46";
    //Recuperando o usuario com o nome Andrey Cesar
    //String sql = "SELECT * FROM usuario WHERE nome = 'Andrey Cesar'";
    //Recuperando o usuario com idade e nome
    //String sql = "SELECT * FROM usuario WHERE nome = 'Carlos Silvério' AND idade = 25";
    //Recuperando informação entre valores
    //String sql = "SELECT * FROM usuario WHERE idade BETWEEN 26 AND 30";
    //Recuperando informação com o carcter coringa '%' que diz que qualquer valor depois e aceito
    //String sql = "SELECT * FROM usuario WHERE nome LIKE 'Ana%'";
    //Ordenado os nome de forma decresente
    //String sql = "SELECT * FROM usuario WHERE 1=1 ORDER BY UPPER(nome) DESC";
    //Colocando um limite para os resultados
    //String sql = "SELECT * FROM usuario LIMIT 4";


    //Ele recupera as informações da tabela
    List usuarioInfo = await db.rawQuery(sql);

    print("usuário: " + usuarioInfo.toString() );

  }

  _recuperarUsuarioID(int id) async {
    Database db = await _recuperarBancoDados();

    List usuarios = await db.query(
      "usuario",
      columns: ["id", "nome", 'idade'],
      where: "id = ? ",
      whereArgs: [id]
    );

    print(usuarios);

  }

  _excluirUsuario(int id) async {
    Database db = await _recuperarBancoDados();

    int retorno = await db.delete(
      "usuario",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  _atualizarUsuario(int id) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Maria Suzana",
      "idade": 67,
    };

    int retorno = await db.update("usuario", dadosUsuario, where: "id = ?", whereArgs: [id]);

  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_recuperarUsuarioID(6);
    //_excluirUsuario(4);
    //_atualizarUsuario(6);
    _listarUsuario();

    return Container();
  }
}


