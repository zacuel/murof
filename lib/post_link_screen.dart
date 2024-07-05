import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostLinkScreen extends ConsumerStatefulWidget {
  const PostLinkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostLinkScreenState();
}

class _PostLinkScreenState extends ConsumerState<PostLinkScreen> {
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _urlValid = false;
  bool _textOnly = false;
  bool _linkAndContent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('post screen'),
      ),
      body: ListView(
        children: [
          const Text("please add a title"),
          TextField(
            controller: _titleController,
          ),
          const Text("please paste your link"),
          TextField(
            controller: _urlController,
            onChanged: (value) {
              if (Uri.parse(value).isAbsolute) {
                setState(() {
                  _urlValid = true;
                });
              }
            },
          ),
          _urlValid
              ? Row(
                  children: [
                    const Text("add additional content"),
                    Checkbox(
                      value: _linkAndContent,
                      onChanged: (value) {
                        setState(() {
                          _linkAndContent = value!;
                        });
                      },
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Text("custom text content only"),
                    Checkbox(
                      value: _textOnly,
                      onChanged: (value) {
                        setState(() {
                          _textOnly = value!;
                        });
                      },
                    ),
                  ],
                ),
          if ((_linkAndContent == true) || (_textOnly == true))
            TextField(
              controller: _contentController,
              maxLines: 1000,
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _urlController.dispose();
    _titleController.dispose();
  }
}
