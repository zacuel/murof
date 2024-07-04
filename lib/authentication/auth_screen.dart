import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/authentication/auth_controller.dart';
import 'package:murof/authentication/auth_repository.dart';
import 'package:murof/utils/snackybar.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _entryWordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool codeCorrect = false;

// Opening screen with function to prevent any user from beginning the account process wittout the correct key.
  Widget get _opener => Scaffold(
        appBar: AppBar(
          title: const Text('opener'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: _getReady),
        body: Center(
          child: TextField(
            controller: _entryWordController,
          ),
        ),
      );

  _getReady() async {
    String result;
    ref.read(authRepositoryProvider).codeWord4InitialEntry.then((value) {
      result = value;
      if (_entryWordController.text.trim().toLowerCase() == result) {
        setState(() {
          codeCorrect = true;
        });
      } else {
        showSnackBar(context, 'Password Incorrect');
      }
    });
  }

  // auth screen before anonAccount is created.
  Widget get _closingScreen => Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: _go),
        body: Center(
          child: Column(
            children: [
              const Text('choose a username'),
              TextField(
                controller: _userNameController,
              ),
            ],
          ),
        ),
      );

  _go() async {
    if (_userNameController.text.trim() != "") {
      ref.read(authControllerProvider.notifier).signUpAnon(_entryWordController.text.trim(), _userNameController.text.trim());
    } else {
      showSnackBar(context, 'please enter a username');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (codeCorrect) {
      case false:
        return _opener;
      case true:
        return _closingScreen;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _entryWordController.dispose();
    _userNameController.dispose();
  }
}
