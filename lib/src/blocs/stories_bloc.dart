import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc{

  //Praticamente um StreamController
  final _topIds = PublishSubject<List<int>>();
  final _repository = Repository();
  //basicamente um streamController especial, que captura o ultimo item adicionado ao controller
  //e emite o mesmo como primeiro item para qualquer listener
  final _items = BehaviorSubject();

  //Getters para streams
   Stream<List<int>> get topIds => _topIds.stream;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids!);
  }

  //Metodo helper para ajudar a separar os IDS da stream, para que cada builder utilize apenas o seu
  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>>? cache, int id, _) {
            cache![id] = _repository.fetchItem(id) as Future<ItemModel> ;
            return cache;
        },
      <int, Future<ItemModel>>{},
    );
  }

  dispose(){
    _topIds.close();
  }

}