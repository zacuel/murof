import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/navigation.dart';
import 'package:murof/features/authentication/auth_controller.dart';
import 'package:murof/features/authentication/auth_repository.dart';
import 'package:murof/theme_provider.dart';
import 'package:murof/utils/snackybar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/name_engine.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final Future<SharedPreferences> sharedPreferences;
  const AuthScreen(this.sharedPreferences, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _entryWordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _codeCorrect = false;
  bool _customName = false;
  late String _madName;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _changeUserName();
  }

  _changeUserName() {
    setState(() {
      _madName = NameEngine.userName;
    });
  }

// Opening screen with function to prevent any user from beginning the account process wittout the correct key.
  Widget get _opener => Scaffold(
        appBar: AppBar(
          title: const Text('enter code'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: _goTo2ndScreen),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _entryWordController,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 150,
            ),
            ElevatedButton(
                onPressed: () {
                  navigateToInfoPage(context);
                },
                child: const Text('explain plz')),
          ],
        ),
      );

  _goTo2ndScreen() async {
    String result;
    ref.read(authRepositoryProvider).codeWord4InitialEntry.then((value) {
      result = value;
      if (_entryWordController.text.trim().toLowerCase() == result) {
        setState(() {
          _codeCorrect = true;
        });
      } else {
        showSnackBar(context, 'Code Incorrect');
      }
    });
  }

  Widget get _closingScreen => Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: _signUp,
          child: const Icon(Icons.arrow_forward),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                'choose username + color',
                style: TextStyle(fontSize: 19),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text("custom"),
                      value: true,
                      groupValue: _customName,
                      onChanged: (value) {
                        setState(() {
                          _customName = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text('madlib'),
                      value: false,
                      groupValue: _customName,
                      onChanged: (value) {
                        setState(() {
                          _customName = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              _customName
                  ? TextField(
                      controller: _userNameController,
                      textAlign: TextAlign.center,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_madName),
                        const SizedBox(
                          width: 50,
                        ),
                        ElevatedButton(
                          onPressed: _changeUserName,
                          child: const Text('change'),
                        )
                      ],
                    ),
              const Divider(),
              CheckboxListTile(
                title: const Text("dark theme"),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value!;
                  });
                  Brightness brightness = value! ? Brightness.dark : Brightness.light;
                  ref.read(colorThemeProvider.notifier).update((state) => ColorScheme.fromSeed(seedColor: Colors.purple, brightness: brightness));
                },
              ),
            ],
          ),
        ),
      );

  _signUp() async {
    if (!_customName) {
      final prefs = await widget.sharedPreferences;
      prefs.setBool("darkMode", _darkMode);
      ref.read(authControllerProvider.notifier).signUpAnon(_entryWordController.text.trim(), _userNameController.text.trim());
    } else {
      if (_userNameController.text.trim() != "") {
        final prefs = await widget.sharedPreferences;
        prefs.setBool("darkMode", _darkMode);
        ref.read(authControllerProvider.notifier).signUpAnon(_entryWordController.text.trim(), _userNameController.text.trim());
      } else {
        showSnackBar(context, 'please enter a username');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_codeCorrect) {
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
