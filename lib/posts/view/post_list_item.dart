import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/posts/posts.dart';


class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
        child: ListTile(
      leading: Text(
        '${post.id}',
        style: textTheme.caption,
      ),
      title: Text(post.title),
      subtitle: Text(post.body),
      isThreeLine: true,
      dense: true,
    ));
  }
}
