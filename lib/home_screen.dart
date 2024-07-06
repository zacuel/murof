import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/features/articles/articles_controller.dart';
import 'package:murof/navigation.dart';
import 'package:murof/utils/error_loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [ElevatedButton(onPressed: () => navigateToPostLink(context), child: const Text("post something"))],
      ),
      body: ref.watch(articleFeedProvider).when(
          data: (data) {
            data.sort(
              (a, b) => a.upvoteIds.length.compareTo(b.upvoteIds.length),
            );
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final article = data[index];
                return ListTile(
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
