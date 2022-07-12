import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'posts/posts_page.dart';


void main() {
  // BlocOverrides.runZoned(
  //   () async {
  //     var bloc = PostBloc(httpClient: http.Client());
  //     bloc.add(PostFectched());
  //     print("Current Posts are ${bloc.state.posts}");
  //     print("Fetching posts!");
  //     await Future<void>.delayed(const Duration(seconds: 60));
  //     print("Fetched Posts are ${bloc.state}");
  //   },
  // );

  BlocOverrides.runZoned(() => runApp(const App()));
}

class App extends MaterialApp {
  const App({Key? key}) : super(key: key, home: const PostsPage());
}

