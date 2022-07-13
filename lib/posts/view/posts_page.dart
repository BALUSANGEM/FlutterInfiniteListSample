import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_infinite_list/posts/posts.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: BlocProvider(
          create: (_) =>
              PostBloc(httpClient: http.Client())..add(PostFectched()),
          child: const PostsList()),
    );
  }
}