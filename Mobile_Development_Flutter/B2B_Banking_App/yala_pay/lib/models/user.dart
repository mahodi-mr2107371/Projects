class User {
  //attributes
  String _firstName, _lastName, _email, _password;
  bool _isLogged = false;
  //Constructor
  User({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  })  : _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _password = password;

  //getter methods
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get password => _password;
  // ignore: unnecessary_getters_setters
  bool get isLogged => _isLogged;
  set isLogged(bool log) => _isLogged = log;

  //factory From Json method
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }

  // Getters
  String get getFirstName => _firstName;
  String get getLastName => _lastName;
  String get getEmail => _email;
  String get getPassword => _password;
  bool get getIsLogged => _isLogged;
}