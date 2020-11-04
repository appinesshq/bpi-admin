import '../models/user.dart';

abstract class UserRepository {
  // Future<User> registerUser(String email, String password, String passwordConfirm);
  // Future<User> createUser(String email, String password, String passwordConfirm, List<UserRole> roles);
  Future<List<User>> fetchUsers(int page, int rows);
  Future<User> getUser(String q);
  // Future<User> updateUser(String id, {String email, String password, String passwordConfirm, List<UserRole> roles});
  // Future<bool> deleteUser(String id);
}
