import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source>[
    NewsApiProvider(),
    newsDbProvider,
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds(){
    if (sources.isEmpty) {
      print('SOURCES IS EMPTY');
    }
    return sources[0].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async{
    late ItemModel item;
    var source;
    for(source in sources) {
        item = await source.fetchItem(id);
        break;
    }
    for(var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }
    return item;
  }
}

abstract class Source {

  Future<List<int>>fetchTopIds();
  Future<ItemModel>fetchItem(int id);

}

abstract class Cache {

  Future<int> addItem(ItemModel item);

}