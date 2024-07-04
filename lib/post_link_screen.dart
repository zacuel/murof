import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostLinkScreen extends ConsumerStatefulWidget {
  const PostLinkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostLinkScreenState();
}

class _PostLinkScreenState extends ConsumerState<PostLinkScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('post screen')),);
  }
}