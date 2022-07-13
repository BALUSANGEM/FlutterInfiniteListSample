import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Posts Bloc', () {

    late http.Client httpClient;
    
    setUp(() => {
      httpClient = MockClient()
    });
    test('Initial state is PostState()', () {
      expect(PostBloc(httpClient: httpClient).state, const PostState());
    });
  });
}
