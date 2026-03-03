import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

 
  /// SIGN UP

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: credential.user!.uid,
        fullName: name,
        email: email,
        age: age,
      );

      await _userService.saveUser(user);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }


  /// LOGIN

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
  }


  User? get currentUser => _auth.currentUser;
}