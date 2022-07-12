import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/widgets/bottom_loader.dart';

import 'bloc/post_bloc.dart';
import 'post_list_item.dart';


class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      switch (state.status) {
        case PostStatus.failure:
          return const Center(child: Text("Failed to fetch posts"));
        case PostStatus.success:
          if (state.posts.isEmpty) {
            return const Center(child: Text("No posts"));
          }
          return ListView.builder(
            itemBuilder: (buildContext, index) {
              return index >= state.posts.length
                  ? const BottomLoader()
                  : PostListItem(post: state.posts[index]);
            },
            itemCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1,
          );
        default:
          return const Center(child: CircularProgressIndicator());
      }
    });
  }
}