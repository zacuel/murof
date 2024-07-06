import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/models/article.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends ConsumerWidget {
  final Article article;
  const ArticleScreen(this.article, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.thumb_up),
      ),
      appBar: AppBar(title: Text(article.title)),
      body: ListView(
        children: [
          //TDO format
          if (article.url != null)
            TextButton(
                onPressed: () async {
                  final Uri linkUrl = Uri.parse(article.url!);
                  if (!await launchUrl(linkUrl)) {
                    throw Exception('Could not launch ${article.url!}');
                  }
                },
                child: Text(
                  article.url!,
                  style: const TextStyle(fontSize: 20),
                )),
          if (article.content != null) Expanded(child: Text(article.content!)),
        ],
      ),
    );
  }
}
