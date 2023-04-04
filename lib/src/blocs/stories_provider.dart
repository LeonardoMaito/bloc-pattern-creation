import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

//InheritedWidget ajuda a subir o contexto dentro de qualquer hierarquia
class StoriesProvider extends InheritedWidget {

  final StoriesBloc bloc;

  StoriesProvider({Key? key, required Widget child})
  :bloc = StoriesBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  //Fazer a instancia de bloc acessivel na hierarquia de widget
  static StoriesBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoriesProvider>()!.bloc;

  }
}