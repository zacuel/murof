import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/navigation.dart';
import 'package:murof/features/authentication/auth_controller.dart';
import 'package:murof/features/authentication/auth_repository.dart';
import 'package:murof/theme_provider.dart';
import 'package:murof/utils/snackybar.dart';
import 'package:murof/utils/text_validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/name_engine.dart';

Color get randomColor {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(255),
    random.nextInt(255),
    random.nextInt(255),
    1,
  );
}

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
  Color pickerColor = Colors.blue;
  Color currentColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _changeUserName();
    setState(() {
      pickerColor = randomColor;
      currentColor = pickerColor;
    });
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
        floatingActionButton: FloatingActionButton(
          onPressed: _goTo2ndScreen,
          child: const Icon(Icons.arrow_forward),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _entryWordController,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
                onPressed: () {
                  _goTo2ndScreen();
                },
                child: const Text('proceed')),
            const SizedBox(
              height: 200,
            ),
            TextButton(
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
              const SizedBox(height: 30),
              CheckboxListTile(
                title: const Text("dark mode"),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value!;
                  });
                  Brightness brightness = value! ? Brightness.dark : Brightness.light;
                  ref.read(colorThemeProvider.notifier).update((state) => state.copyWith(brightness: brightness));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Choose a color to theme your experience"),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _showColorDialogue,
                child: ColoredBox(
                  color: currentColor,
                  child: const SizedBox(
                    height: 120,
                    width: 350,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void _changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  _showColorDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: _changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                ref.read(colorThemeProvider.notifier).update((state) => ColorScheme.fromSeed(seedColor: currentColor, brightness: state.brightness));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _signUp() async {
    if (_customName && !validTextValue(_userNameController)) {
      showSnackBar(context, 'please choose a username');
    } else {
      final userName = _customName ? validTextValueReturner(_userNameController) : _madName;
      await widget.sharedPreferences.then((prefs) {
        prefs.setBool("darkMode", _darkMode);
        prefs.setInt("color", currentColor.value);
        ref.read(authControllerProvider.notifier).signUpAnon(_entryWordController.text.trim(), userName, currentColor, context);
      });
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
