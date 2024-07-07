import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/person.dart';
import '../../utils/snackybar.dart';
import 'auth_repository.dart';

final personProvider = StateProvider<Person?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return AuthController(authRepository: authRepository);
  },
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(false);

  Stream<Person> getPersonData(String uid) => _authRepository.getPersonData(uid);

  Future<void> signUpAnon(String passWord, String alias, Color color, BuildContext context) async {
    state = true;
    final result = await _authRepository.signUpAnon(inputCodeWord: passWord, userName: alias, color: color);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) => null);
  }
}
