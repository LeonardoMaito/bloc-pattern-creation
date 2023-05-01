import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  //Praticamente um StreamController
  final _topIds = PublishSubject<List<int>>();
  final _repository = Repository();
  //basicamente um streamController especial, que captura o ultimo item adicionado ao controller
  //e emite o mesmo como primeiro item para qualquer listener
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  StoriesBloc(){
       _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  //Getters para streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  Function(int) get fetchItem => _itemsFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }

  //Metodo helper para ajudar a separar os IDS da stream, para que cada builder utilize apenas o seu
  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        //Pega um ID, transforma em ItemModel, joga isso dentro do Cache
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
