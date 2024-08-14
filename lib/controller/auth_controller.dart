import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemicates_test/services/firebase_services.dart';
import 'package:gemicates_test/widgets/my_custom_snack_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthController extends ChangeNotifier {
  final Ref ref;
  AuthController(this.ref);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();
  bool isLoading = false;

  User? get currentUser => _auth.currentUser;

  Future<bool> signUp(String email, String password, String name, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _firebaseService.saveUserDetails(userCredential.user!.uid, name, email);
      }
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        MycustomSnackbar.showSnackBar(context, e.message ?? "", isError: true);
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        MycustomSnackbar.showSnackBar(context, e.message ?? "", isError: true);
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}

final authController = ChangeNotifierProvider<AuthController>((ref) => AuthController(ref));
