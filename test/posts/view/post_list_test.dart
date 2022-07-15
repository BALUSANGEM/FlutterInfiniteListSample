import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_infinite_list/widgets/bottom_loader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostBlock extends MockBloc<PostEvent, PostState> implements PostBloc {
}

void main() {
  late PostBloc bloc;
  setUp(() => {bloc = MockPostBlock()});

  final mockPosts = List.generate(
      5, (index) => Post(id: index, title: "Title", body: "This is body"));

  group('PostList', () {
    testWidgets('When post status is initial show circular progressbar',
        (tester) async {
      when(() => bloc.state).thenReturn(const PostState());
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('When post status is success but posts list is empty',
        (tester) async {
      when(() => bloc.state).thenReturn(const PostState(
          status: PostStatus.success, posts: [], hasReachedMax: false));
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.text('No posts'), findsOneWidget);
    });

    testWidgets('When max not reached shows 5 posts and bottom loader',
        (tester) async {
      when(() => bloc.state)
          .thenReturn(PostState(status: PostStatus.success, posts: mockPosts));
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.byType(PostListItem), findsNWidgets(5));
      expect(find.byType(BottomLoader), findsOneWidget);
    });

    testWidgets('When max reached does not show bottom loader', (tester) async {
      when(() => bloc.state).thenReturn(PostState(
          status: PostStatus.success, posts: mockPosts, hasReachedMax: true));
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.byType(BottomLoader), findsNothing);
    });
  });
}
