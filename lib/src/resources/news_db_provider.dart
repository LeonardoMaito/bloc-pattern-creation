import 'package:hacker_news_api/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache{
  late Database db;

  NewsDbProvider(){
    init();
  }

  void init() async {
    //Pega uma referencia de uma pasta no dispositivo movel onde podemos guardar dados
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //Damos um join no caminho e no banco de dados
    final path = join(documentsDirectory.path, "items.db");

    //Tenta abrir o BD no caminho referenciado, e se nao existe, cria um novo
    db = await openDatabase(
        path,
        version: 1,
        //onCreate roda uma vez quando o usuario abre o app pela primeira vez
        onCreate: (Database newDb, int version){
                newDb.execute("""
                  CREATE TABLE Items
                  (
                     id INTEGER PRIMARY KEY,
                     type TEXT,
                     by TEXT,
                     time INTEGER,
                     parent INTEGER,
                     kids BLOB,
                     dead INTEGER, 
                     deleted INTEGER, 
                     url TEXT,
                     score INTEGER,
                     title TEXT,
                     descendants INTEGER
                  )
                """);
        });
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
   final maps =  await db.query(
      "Items",
      //queremos retornar todas as colunas, e nao uma em especifico
      columns: null,
      //queremos um ID igual a algo
      where: "id=?",
      whereArgs: [id],
    );

    if(maps.isNotEmpty){
        return ItemModel.fromDb(maps.first);
    }else {
      return null;
    }
  }

  @override
  Future<int>addItem(ItemModel item) {
    return db.insert("Items", item.toMapForDb());
  }

  //To-do: Armazenar top ids em banco local
  @override
  Future<List<int>> fetchTopIds() {
    throw UnimplementedError();
  }
}
//Nao é interessante abrir o banco de dados várias vezes, melhor uma instancia global
final newsDbProvider = NewsDbProvider();

