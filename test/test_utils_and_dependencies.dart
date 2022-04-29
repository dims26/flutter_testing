import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

List<Article> getArticleList({required int numArticles}) {
  var result = <Article>[];

  for(int i = 0; i < numArticles; i++) {
    result.add(Article(title: "Article ${i + 1} title", content: "Article ${i + 1} content"));
  }

  return result;
}

Widget createNewsPageWidgetUnderTest(MockNewsService mockNewsService) {
  return MaterialApp(
    title: 'News App',
    home: ChangeNotifierProvider(
      create: (_) => NewsChangeNotifier(mockNewsService),
      child: const NewsPage(),
    ),
  );
}