import 'package:flutter/material.dart';
import 'package:murof/post_article_screen.dart';

navigateToPostLink(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const PostLinkScreen(),
  ));
}
