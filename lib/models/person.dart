import 'dart:convert';

import 'package:flutter/widgets.dart';

class Person {
  final String uid;
  final String alias;
  final Color favoriteColor;
  final List<String> favoriteArticleIds;
  final String codeGroup;
  Person({
    required this.uid,
    required this.alias,
    required this.favoriteColor,
    required this.favoriteArticleIds,
    required this.codeGroup,
  });

  Person copyWith({
    String? uid,
    String? alias,
    Color? favoriteColor,
    List<String>? favoriteArticleIds,
    String? codeGroup,
  }) {
    return Person(
      uid: uid ?? this.uid,
      alias: alias ?? this.alias,
      favoriteColor: favoriteColor ?? this.favoriteColor,
      favoriteArticleIds: favoriteArticleIds ?? this.favoriteArticleIds,
      codeGroup: codeGroup ?? this.codeGroup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'alias': alias,
      'favoriteColor': favoriteColor.value,
      'favoriteArticleIds': favoriteArticleIds,
      'codeGroup': codeGroup,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      alias: map['alias'] ?? '',
      favoriteColor: Color(map['favoriteColor']),
      favoriteArticleIds: List<String>.from(map['favoriteArticleIds']),
      codeGroup: map['codeGroup'] ?? '',
    );
  }
}
