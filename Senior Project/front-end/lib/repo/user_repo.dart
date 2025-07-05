import 'package:google_sign_in/google_sign_in.dart';
import 'package:sdp/modals/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository handling user authentication and management operations
///
/// Supports multiple authentication methods including email/password and Google sign-in,
/// as well as user data operations with Supabase backend.
class UserRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  // OAuth client identifiers for Google authentication
  static var webClientId =
      '250630496067-6rd5kjvjmo93oqtiost2n7esq6atnppt.apps.googleusercontent.com';
  static var iosClientId =
      '1050748759477-o2t1qifus5rsjejm9ij2qr12viaauu0r.apps.googleusercontent.com';
  static const androidClientId =
      '250630496067-j2d4ts61rl2eqbgl1d0fci1q2lhm0jq7.apps.googleusercontent.com';

  //---------------------- EMAIL/PASSWORD AUTHENTICATION ----------------------//

  /// Signs in a user with email and password
  ///
  /// @param email User's email address
  /// @param password User's password
  /// @returns User object if authentication is successful, null otherwise
  Future<Users?> signInWithEmailPassword(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
    return getUser(email);
  }

  /// Registers a new user with email and password
  ///
  /// Creates both an authentication entry and a database record for the user
  ///
  /// @param user User object containing registration information
  /// @returns true if registration is successful, false otherwise
  Future<bool> addUser(Users user) async {
    try {
      // Create authentication entry
      await _supabase.auth.signUp(email: user.email, password: user.password!);

      // Store user data in database
      await _supabase.from('users').insert({
        'name': user.name,
        'email': user.email,
        'password': user.password,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //---------------------- GOOGLE AUTHENTICATION ----------------------//

  /// Signs in a user using Google OAuth
  ///
  /// Initiates Google authentication flow and creates/updates user record in database
  ///
  /// @returns User object if authentication is successful, null otherwise
  Future<Users?>? google_SignIn() async {
    try {
      // Initialize Google Sign-In with appropriate client IDs
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      // Start Google authentication flow
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Get authentication tokens
        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null || idToken == null) {
          throw 'Missing authentication tokens.';
        }

        // Sign in to Supabase with Google credentials
        final response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        if (response.user != null) {
          // Extract user information from response
          final user = response.user!;
          final name = user.userMetadata?['name'];
          final email = user.email!;
          final id = user.id;

          // Create user object and check if it exists in database
          Users newUser = Users(email: email, id: id, name: name);
          getUserwithId(id, newUser);
          return newUser;
        }
      }
    } catch (e) {
      // Log authentication errors but don't propagate
      print('Error during Google Sign-In: $e');
    }
    return null;
  }

  //---------------------- SIGN OUT METHODS ----------------------//

  /// Signs out the currently authenticated user from Supabase
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Signs out the currently authenticated Google user
  ///
  /// This method is static to allow calling without an instance
  static Future<void> googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    await googleSignIn.signOut();
  }

  //---------------------- USER DATA OPERATIONS ----------------------//

  /// Stores a user record in the database
  ///
  /// Used when creating new user accounts or updating existing ones
  ///
  /// @param user User object containing data to be stored
  Future<void> storeUser(Users user) async {
    await _supabase.from('users').insert({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': user.password,
    });
  }

  /// Retrieves a user by email address
  ///
  /// @param email Email address to search for
  /// @returns User object if found, null otherwise
  Future<Users?> getUser(String email) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      // ignore: unnecessary_cast
      return Users.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Retrieves a user by ID and stores if not found
  ///
  /// This is primarily used during Google authentication to ensure
  /// the user exists in the database
  ///
  /// @param id User ID to search for
  /// @param user User object to store if not found
  /// @returns User ID if found, empty string if stored, null on error
  Future<String?> getUserwithId(String id, Users user) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', id).maybeSingle();

      if (response == null) {
        // User doesn't exist in the database, store them
        storeUser(user);
        return "";
      }
      return response['id'];
    } catch (e) {
      return null;
    }
  }
}
