import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article_page.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../test/test_utils_and_dependencies.dart';

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  testWidgets(
      "verify tap on first article opens article page showing full content",
          (WidgetTester tester) async {
        final articles = getArticleList(numArticles: 3);
        when(() => mockNewsService.getArticles()).thenAnswer((_) async => articles);
        
        await tester.pumpWidget(createNewsPageWidgetUnderTest(mockNewsService));
        await tester.pump();
        await tester.tap(find.text(articles[0].title));
        await tester.pumpAndSettle();

        expect(find.byType(NewsPage), findsNothing);
        expect(find.byType(ArticlePage), findsOneWidget);
        expect(find.text(articles[0].title), findsOneWidget);
        expect(find.text(articles[0].content), findsOneWidget);
      });
}