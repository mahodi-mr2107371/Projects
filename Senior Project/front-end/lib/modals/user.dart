/// User model representing application users
///
/// This class stores user data including authentication credentials
/// and profile information needed throughout the application.
class Users {
  // User profile and authentication data
  final String? name;
  final String email;
  final String? password;
  final String? id;

  /// Creates a user with required and optional fields
  ///
  /// @param email Required email address for the user
  /// @param password Optional password (may be null for OAuth users)
  /// @param name Optional display name
  /// @param id Optional unique identifier (assigned by backend)
  Users({
    required this.email,
    this.password,
    this.name,
    this.id,
  });

  /// Gets the user's unique identifier
  String? get getId => id;

  /// Gets the user's display name
  String? get getName => name;

  /// Gets the user's email address
  String get getEmail => email;

  /// Gets the user's password (may be null for OAuth users)
  String? get getPassword => password;

  /// Creates a User object from a JSON map
  ///
  /// Used when deserializing user data from the backend
  ///
  /// @param map JSON map containing user properties
  /// @returns A new Users instance
  factory Users.fromJson(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  /// Converts the User object to a JSON map
  ///
  /// Used when sending user data to the backend
  ///
  /// @param id Optional ID to include in the map (overrides the user's ID)
  /// @returns Map representing the user's data
  Map<String, dynamic> toJson(int? id) {
    return {
      'id': id ?? this.id,
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
