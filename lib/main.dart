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
      "nome": "Andrey Cesar",
      "idade": 26,
    };

    //Inserindo valores na tabela
    int id = await db.insert("usuario", dadosUsuario);
    print("Salvo: $id");
  }

  @override
  Widget build(BuildContext context) {
    _salvar();

    return Container();
  }
}


