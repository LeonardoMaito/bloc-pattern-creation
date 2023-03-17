import 'dart:convert';
import 'package:hacker_news_api/src/resources/repository.dart';
import 'package:http/http.dart' show Client;
import '../models/item_model.dart';

final _urlRoot = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {

  Client client = Client();

    Future <List<int>> fetchTopIds() async {
    //Await pois o get é assíncrono.
    final response = await client.get(Uri.parse('$_urlRoot/topstories.json'));
    //Convertendo o JSON
    final ids = json.decode(response.body);

    //No encode, dart não sabe que tipo é o json.decode
    //Estamos auxiliando dizendo que é uma lista de int através do cast
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {

    final response = await client.get(Uri.parse('$_urlRoot/item/$id.json'));
    final parsedJson = json.decode(response.body);

    return ItemModel.fromJson(parsedJson);

  }

}