import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/posts/bloc/post_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostBlock extends MockBloc<PostEvent, PostState> implements PostBloc {
}

void main() {
  late PostBloc bloc;
  setUp(() => {bloc = MockPostBlock()});

  group('PostList', () {
    testWidgets('When post status is initial show circular progressbar',
        (tester) async {
      when(() => bloc.state).thenReturn(const PostState());
      await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(value: bloc, child: const PostsList())));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
