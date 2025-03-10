
class User {
  //attributes
  String firstName, lastName, password;
  String email;
  bool isLogged = false;
  //Constructor
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  //factory From Json method
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      // uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }
  

  // Method to convert User to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}
