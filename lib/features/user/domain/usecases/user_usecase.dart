import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUpUseCase {
  final UserRepository repository;

  SignUpUseCase(this.repository);

  Future<User> call(String name, String email, String password) async {
    return await repository.signUp(name, email, password);
  }
}

class SignInUseCase {
  final UserRepository repository;

  SignInUseCase(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}

class SignOutUseCase {
  final UserRepository repository;

  SignOutUseCase(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
