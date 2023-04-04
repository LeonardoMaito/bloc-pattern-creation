import 'package:flutter/material.dart';
import 'package:hacker_news_api/src/widgets/news_list_tile.dart';
import '../blocs/stories_provider.dart';
import 'package:rxdart/rxdart.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Consegue acesso a streams de top ids para conseguir dados
    final bloc = StoriesProvider.of(context);
    //Temporary
    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc){
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if(!snapshot.hasData){
          return Center(
            child:CircularProgressIndicator(),
          );

        }
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data![index]);
              return NewsListTile(itemId: snapshot.data![index]);
            }
        );
      },
    );
  }

}
