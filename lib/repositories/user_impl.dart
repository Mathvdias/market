import 'package:marketplace/models/user.dart';
import 'package:marketplace/repositories/mocks/user.dart';
import 'package:marketplace/repositories/user.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<User?> authenticate(String email, String password) async {
    if (email == userJson['email'] && password == userJson['password']) {
      return User.fromJson(userJson);
    }
    return null;
  }
}
