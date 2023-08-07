import 'package:app_auth/features/user/data/datasources/firebase_datasource.dart';
import 'package:app_auth/features/user/domain/entities/user.dart';
import 'package:app_auth/features/user/domain/repositories/user_repository.dart';
import 'package:app_auth/features/user/data/models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<User> signUp(String name, String email, String password) async {
    final userModel = await dataSource.signUp(name, email, password);
    return userModel.toDomain();
  }

  @override
  Future<User> signIn(String email, String password) async {
    final userModel = await dataSource.signIn(email, password);
    return userModel.toDomain();
  }

  @override
  Future<void> signOut() async {
    await dataSource.signOut();
  }
}
