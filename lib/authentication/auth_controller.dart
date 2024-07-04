import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return AuthController(authRepository: authRepository, ref: ref);
  },
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Future<void> signUpAnon(String passWord, String alias) async {
    state = true;
    final result = await _authRepository.signUpAnon(inputCodeWord: passWord, userName: alias, color: Colors.green);
  }
}
