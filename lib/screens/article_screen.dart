import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/features/articles/favorite_articles_provider.dart';
import 'package:murof/models/article.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  const ArticleScreen(this.article, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  bool _showVoteButton = true;

  _vote(int listLength) {
    ref.read(favoriteArticlesProvider.notifier).toggleArticleFavoriteStatus(widget.article.articleId);
    setState(() {
      _showVoteButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favList = ref.watch(favoriteArticlesProvider);
    final isFav = favList.contains(widget.article.articleId);
    return Scaffold(
      floatingActionButton: _showVoteButton
          ? FloatingActionButton(
              onPressed: () => _vote(3),
              child: const Icon(Icons.thumb_up),
            )
          : null,
      appBar: AppBar(
        title: Text(widget.article.title),
        backgroundColor: isFav ? Colors.green : Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            //TDO format
            if (widget.article.url != null)
              TextButton(
                  onPressed: () async {
                    final Uri linkUrl = Uri.parse(widget.article.url!);
                    if (!await launchUrl(linkUrl)) {
                      throw Exception('Could not launch ${widget.article.url!}');
                    }
                  },
                  child: Text(
                    widget.article.url!,
                    style: const TextStyle(fontSize: 20),
                  )),
            if (widget.article.content != null) Expanded(child: Text(widget.article.content!)),
          ],
        ),
      ),
    );
  }
}
