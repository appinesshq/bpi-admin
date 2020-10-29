import 'dart:convert';

enum UserRole {
  ADMIN,
  USER,
}

UserRole userRole(String s) {
  switch (s.toLowerCase()) {
    case 'admin':
      return UserRole.ADMIN;
    case 'user':
      return UserRole.USER;
    default:
      throw Exception('Invalid role $s');
  }
}

List<UserRole> userRoles(List<dynamic> roles) =>
    roles.map<UserRole>((role) => userRole(role)).toList();

class User {
  String id;
  String email;
  List<UserRole> roles;
  DateTime dateCreated;
  DateTime dateUpdated;

  User(this.id, this.email, this.roles, this.dateCreated, this.dateUpdated);

  User.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        email = data['email'],
        roles = userRoles(data['roles']),
        dateCreated = DateTime.parse(data['date_created']),
        dateUpdated = DateTime.parse(data['date_updated']);

  bool isAdmin() => roles.contains(UserRole.ADMIN);

  String toJson() {
    return json.encode(<String, dynamic>{
      'id': id,
      'email': email,
      'roles': roles.map((role) => role.toString()).toList(),
      'date_created': dateCreated,
      'date_updated': dateUpdated,
    });
  }
}
