import 'package:marketplace/models/user.dart';

abstract class UserRepository {
  Future<User?> authenticate(String email, String password);
}
