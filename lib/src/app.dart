import 'package:flutter/material.dart';
import 'package:hacker_news_api/src/screens/news_detail.dart';
import 'package:hacker_news_api/src/screens/news_list.dart';
import 'blocs/comments_provider.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return NewsList();
        },
      );
    }
    return MaterialPageRoute(builder: (context) {
      final commentsBloc = CommentsProvider.of(context);
      //pegar o id da news
       final itemId =  int.parse(settings.name!.replaceFirst('/', ''));

       commentsBloc.fetchItemWithComments(itemId);

      return NewsDetail(itemId: itemId);
    });
  }
}
