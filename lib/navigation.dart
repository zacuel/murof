import 'package:flutter/material.dart';
import 'package:murof/post_article_screen.dart';

import 'article_screen.dart';
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