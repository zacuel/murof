import 'package:flutter/material.dart';
import 'package:murof/screens/post_article_screen.dart';

import 'screens/article_screen.dart';
import 'models/article.dart';

navigateToPostLink(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const PostLinkScreen(),
  ));
}

navigateToArticle(BuildContext context, Article article) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ArticleScreen(article),
  ));
}