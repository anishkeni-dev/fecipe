import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
      return;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     //
  //     // final GoogleSignInAuthentication? googleAuth =
  //     // await googleUser?.authentication;
  //     //
  //     // final credential = GoogleAuthProvider.credential(
  //     //   accessToken: googleAuth?.accessToken,
  //     //   idToken: googleAuth?.idToken,
  //     // );
  //
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
  Future<void> updateEmail({
    required String email,
  }) async {
    try {
      User firebaseUser = _firebaseAuth.currentUser!;
      firebaseUser
          .updateEmail(email)
          .then(
            (value) => debugPrint("changed"),
          )
          .catchError((onError) => Get.snackbar(
                "Error",
                "Something went wrong. Try again",
                snackPosition: SnackPosition.BOTTOM,
              ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
