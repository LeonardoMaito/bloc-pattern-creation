import 'package:flutter/material.dart';
import 'package:hacker_news_api/src/models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>>snapshot){
        if(!snapshot.hasData){
          return const Text('Stream Still Loading');
        }
        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot){
            if(!itemSnapshot.hasData){
              return Text('Item $itemId Still Loading');
            } else {
              return Text(itemSnapshot.data!.title!);
            }
          },
        );
      },
    );
  }
}
