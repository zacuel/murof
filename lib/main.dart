import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/authentication/auth_repository.dart';
import 'package:murof/firebase_tools/firebase_options.dart';

import 'authentication/auth_screen.dart';
import 'utils/error_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "forum",
      home: ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              // getData(data);
              // if (person != null) {
              //   setState(() {
              //     userColorScheme = ColorScheme.fromSeed(seedColor: person!.favoriteColor);
              //   });
              //   return const ScopedHomeScreen();
              // }
              return Placeholder();
            }
            return const AuthScreen();
          },
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader()),
    );
  }
}
