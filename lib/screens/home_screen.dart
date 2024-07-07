import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/features/articles/articles_controller.dart';
import 'package:murof/features/articles/favorite_articles_provider.dart';
import 'package:murof/navigation.dart';
import 'package:murof/utils/error_loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  _showInfo(BuildContext context) {
    navigateToInfoPage(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favList = ref.watch(favoriteArticlesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Text("info"),
          onPressed: () => _showInfo(context),
        ),
        actions: [ElevatedButton(onPressed: () => navigateToPostLink(context), child: const Text("post something"))],
      ),
      body: ref.watch(articleFeedProvider).when(
          data: (data) {
            data.sort(
              (a, b) => b.upvoteIds.length.compareTo(a.upvoteIds.length),
            );
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final article = data[index];
                final isFav = favList.contains(article.articleId);
                return ListTile(
                  tileColor: isFav ? Colors.amber.withOpacity(.5) : null,
                  onTap: () {
                    navigateToArticle(context, article);
                  },
                  title: Text(article.title),
                  trailing: Text(article.upvoteIds.length.toString()),
                );
              },
            );
          },
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader()),
    );
  }
}
