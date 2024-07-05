import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../utils/firebase_tools/firebase_providers.dart';
import '../../models/person.dart';
import '../../utils/type_defs.dart';

const String entryReq = "codeword";

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.authStateChange;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final auth = ref.read(authProvider);
  return AuthRepository(firestore: firestore, auth: auth);
});

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _auth = auth,
        _firestore = firestore;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<String> get _codeWord async {
    final document = await _firestore.collection(entryReq).doc(entryReq).get();

    return document.data()![entryReq];
  }

  Future<String> get codeWord4InitialEntry async {
    return _codeWord;
  }

  CollectionReference get _people => _firestore.collection('people');

  Stream<Person> getPersonData(String uid) {
    return _people.doc(uid).snapshots().map((event) => Person.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEitherFailureOr<void> signUpAnon({
    required String inputCodeWord,
    required String userName,
    required Color color,
  }) async {
    try {
      if (inputCodeWord == await _codeWord) {
        final anonCred = await _auth.signInAnonymously();
        final newPeron = Person(
          uid: anonCred.user!.uid,
          alias: userName,
          favoriteArticleIds: [],
          favoriteColor: color,
          codeGroup: inputCodeWord,
        );
        await _people.doc(newPeron.uid).set(newPeron.toMap());
        return right(null);
      } else {
        return left(Failure("invalid entry"));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
