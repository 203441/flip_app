import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> signUp(String name, String email, String password);
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
}

class FirebaseUserDataSource implements UserDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseUserDataSource({required this.firebaseAuth});

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = userCredential.user!;
    await user.updateDisplayName(name);
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
