
import 'package:flutter/foundation.dart';

class Article {
  final String articleId;
  final String authorId;
  final String authorName; 
  final String title;
  final String? url;
  final String? content;
  final List<String> upvoteIds;
  Article({
    required this.articleId,
    required this.authorId,
    required this.authorName,
    required this.title,
    this.url,
    this.content,
    required this.upvoteIds,
  });

  // Article copyWith({
  //   String? articleId,
  //   String? authorId,
  //   String? authorName,
  //   String? title,
  //   ValueGetter<String?>? url,
  //   ValueGetter<String?>? content,
  //   List<String>? upvoteIds,
  // }) {
  //   return Article(
  //     articleId: articleId ?? this.articleId,
  //     authorId: authorId ?? this.authorId,
  //     authorName: authorName ?? this.authorName,
  //     title: title ?? this.title,
  //     url: url != null ? url() : this.url,
  //     content: content != null ? content() : this.content,
  //     upvoteIds: upvoteIds ?? this.upvoteIds,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'url': url,
      'content': content,
      'upvoteIds': upvoteIds,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      articleId: map['articleId'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      title: map['title'] ?? '',
      url: map['url'],
      content: map['content'],
      upvoteIds: List<String>.from(map['upvoteIds']),
    );
  }





}
