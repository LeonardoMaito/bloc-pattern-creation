import 'package:hacker_news_api/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {

  test('Fetch Top IDs retorna uma lista de IDs', () async {

    //setup do caso de teste
    final newsApi = NewsApiProvider();

    //expectaction - metodo/resultado esperado

    newsApi.client =  MockClient((request) async {
      return Response(json.encode([1,2,3,4]), 200);
    });

    final ids = await newsApi.fetchTopIds();
    expect(ids, [1,2,3,4]);

  });

  test('FetchItem retorna um item model', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);

    });

    final item = await newsApi.fetchItem(999);
    expect(item.id, 123);

  });
}

