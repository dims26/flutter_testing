import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:mocktail/mocktail.dart';

import 'test_utils_and_dependencies.dart';

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "verify initial values correct",
        () {
      expect(sut.articles, getArticleList(numArticles: 0));
      expect(sut.isLoading, false);
    },
  );

  group(
    "test getArticles",
        () {
      test("verify NewsService dependency called",
            () async {
          when(() => mockNewsService.getArticles()).thenAnswer((_) async => []);

          await sut.getArticles();

          verify(() => mockNewsService.getArticles()).called(1);
        },
      );

      test(
        """
        verify isLoading indicator triggered true, 
        articles updated,
        isLoading indicator triggered false
        """,
            () async {
          final articles = getArticleList(numArticles: 3);
          when(() => mockNewsService.getArticles()).thenAnswer((_) async => articles);

          final articlesFuture =  sut.getArticles();

          expect(sut.isLoading, true);
          await articlesFuture;
          expect(sut.articles, articles);
          expect(sut.isLoading, false);
        },
      );
    },
  );
}