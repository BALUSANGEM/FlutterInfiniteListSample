import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_infinite_list/widgets/bottom_loader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostBlock extends MockBloc<PostEvent, PostState> implements PostBloc {
}

List<Post> generateMockPosts(int n) {
  return List.generate(
      n, (index) => Post(id: index, title: "Title", body: "This is body"));
}

void main() {
  late PostBloc bloc;
  setUp(() => {bloc = MockPostBlock()});

  final mockFivePosts = generateMockPosts(5);

  final mockTenPosts = generateMockPosts(10);

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
      when(() => bloc.state).thenReturn(
          PostState(status: PostStatus.success, posts: mockFivePosts));
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.byType(PostListItem), findsNWidgets(5));
      expect(find.byType(BottomLoader), findsOneWidget);
    });

    testWidgets('When max reached does not show bottom loader', (tester) async {
      when(() => bloc.state).thenReturn(PostState(
          status: PostStatus.success,
          posts: mockFivePosts,
          hasReachedMax: true));
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.byType(BottomLoader), findsNothing);
    });

    testWidgets('When scrolled to bottom fetch more posts', (tester) async {
      when(() => bloc.state).thenReturn(PostState(
        status: PostStatus.success,
        posts: mockTenPosts,
      ));
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      await tester.drag(find.byType(PostsList), const Offset(0, -500));
      verify(() => bloc.add(PostFectched())).called(1);
    });
  });
}
