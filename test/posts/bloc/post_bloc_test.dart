import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

Uri _postsUrl({required int start}) {
  return Uri.https(
    'jsonplaceholder.typicode.com',
    '/posts',
    <String, String>{'_start': '$start', '_limit': '20'},
  );
}

void main() {
  group('Posts Bloc', () {
    late http.Client httpClient;

    const List<Post> mockPosts = [
      Post(id: 1, title: "Title", body: "This is mocked body")
    ];

    setUpAll(() => {registerFallbackValue(Uri())});

    setUp(() => {httpClient = MockClient()});
    test('Initial state is PostState()', () {
      expect(PostBloc(httpClient: httpClient).state, const PostState());
    });

    group('PostFetched', () {
      blocTest('Emits nothing when posts limit has reached ',
          build: () => PostBloc(httpClient: httpClient),
          seed: () => const PostState(hasReachedMax: true),
          act: (PostBloc bloc) => bloc.add(PostFectched()),
          expect: () => <PostState>[]);

      blocTest(
        'Emits posts successfully when initial request is successful ',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "Title", "body": "This is mocked body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (PostBloc bloc) => bloc.add(PostFectched()),
        expect: () => const <PostState>[
          PostState(
              status: PostStatus.success,
              posts: mockPosts,
              hasReachedMax: false)
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 0))).called(1);
        },
      );
    });
  });
}
