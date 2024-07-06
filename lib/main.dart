import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murof/features/authentication/auth_controller.dart';
import 'package:murof/features/authentication/auth_repository.dart';
import 'package:murof/theme_provider.dart';
import 'package:murof/utils/firebase_tools/firebase_options.dart';
import 'package:murof/screens/home_screen.dart';

import 'features/articles/favorite_articles_provider.dart';
import 'screens/auth_screen.dart';
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
  void getData(User data) async {
    final person = await ref.read(authControllerProvider.notifier).getPersonData(data.uid).first;
    ref.read(personProvider.notifier).update((state) => person);
    ref.read(favoriteArticlesProvider.notifier).createListState(person.favoriteArticleIds);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Oxygen", colorScheme: ref.watch(colorThemeProvider)),
      title: "forum",
      home: ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              getData(data);

              return const HomeScreen();
            }
            return const AuthScreen();
          },
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader()),
    );
  }
}
