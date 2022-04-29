import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'test_utils_and_dependencies.dart';

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  testWidgets(
      "verify title is displayed",
          (WidgetTester tester) async {
        final articles = getArticleList(numArticles: 3);
        when(() => mockNewsService.getArticles()).thenAnswer((_) async => articles);

        await tester.pumpWidget(createNewsPageWidgetUnderTest(mockNewsService));

        expect(find.text("News"), findsOneWidget);
      });

  testWidgets(
      "verify loading indicator shown",
          (WidgetTester tester) async {
        when(() => mockNewsService.getArticles()).thenAnswer((_) async {
          final articles = getArticleList(numArticles: 3);
          return await Future.delayed(const Duration(seconds: 2), () => articles);
        });

        await tester.pumpWidget(createNewsPageWidgetUnderTest(mockNewsService));
        await tester.pump(const Duration(milliseconds: 500));//force a rebuild for dynamic content

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        // expect(find.byKey(const Key("progress indicator")), findsOneWidget);
        await tester.pumpAndSettle();
      });

  testWidgets(
      "verify articles are displayed",
          (WidgetTester tester) async {
        final articles = getArticleList(numArticles: 3);
        when(() => mockNewsService.getArticles()).thenAnswer((_) async => articles);
        
        await tester.pumpWidget(createNewsPageWidgetUnderTest(mockNewsService));
        await tester.pump();

        for (final article in articles) {
          expect(find.text(article.title), findsOneWidget);
          expect(find.text(article.content), findsOneWidget);
        }
      });
}