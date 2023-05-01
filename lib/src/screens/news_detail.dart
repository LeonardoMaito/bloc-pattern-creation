import 'package:flutter/material.dart';
import 'package:hacker_news_api/src/blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {

  final int itemId;
  const NewsDetail({required this.itemId});

  @override
  Widget build(BuildContext context) {
    final commentsBloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: buildBody(commentsBloc),
    );
  }

  Widget buildBody(commentsBloc) {
    return StreamBuilder(stream: commentsBloc.itemWithComments,
      builder: (BuildContext context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        final itemFuture = snapshot.data?[itemId];

        return FutureBuilder(future: itemFuture,
          builder: (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if(!snapshot.hasData){
              return Text('Loading');
            }
            return buildList(itemSnapshot.data!, snapshot.data!);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap){
    final children = <Widget>[];
    children.add(Text(item.title));
    final commentsList = item.kids?.map((kidId) => Comment(itemId: kidId, itemMap: itemMap,))
        .toList();
    children.addAll(commentsList!);

      return ListView(
        children: children,


      );
  }
}
