import 'package:marketplace/models/user.dart';

abstract interface class UserRepository {
  Future<User?> authenticate(String email, String password);
}
