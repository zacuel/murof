import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/features/articles/articles_repository.dart';
import 'package:murof/models/article.dart';
import 'package:uuid/uuid.dart';

import '../../utils/snackybar.dart';
import '../authentication/auth_controller.dart';

final articleFeedProvider = StreamProvider<List<Article>>((ref) {
  final articlesController = ref.read(articlesControllerProvider.notifier);
  return articlesController.articleFeed;
});

final articlesControllerProvider = StateNotifierProvider<ArticlesController, bool>((ref) {
  final articlesRepo = ref.read(articlesRepositoryProvider);
  return ArticlesController(articlesRepository: articlesRepo, ref: ref);
});

class ArticlesController extends StateNotifier<bool> {
  final ArticlesRepository _articlesRepository;
  final Ref _ref;

  ArticlesController({required ArticlesRepository articlesRepository, required Ref ref})
      : _articlesRepository = articlesRepository,
        _ref = ref,
        super(false);

  Future<void> postArticle({
    required String title,
    String? url,
    String? content,
    required BuildContext context,
  }) async {
    state = true;
    final newId = const Uuid().v1();
    final person = _ref.read(personProvider)!;
    final newArticle = Article(
      articleId: newId,
      authorId: person.uid,
      authorName: person.alias,
      title: title,
      upvoteIds: [person.uid],
      url: url,
      content: content,
    );
    final result = await _articlesRepository.postArticle(newArticle);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      // _ref.read(favoriteArticlesProvider.notifier).addArticleUponCreation(article.articleId);
      showSnackBar(context, 'Posted!');
      Navigator.of(context).pop();
    });
  }

  Stream<List<Article>> get articleFeed => _articlesRepository.articleFeed;
}
