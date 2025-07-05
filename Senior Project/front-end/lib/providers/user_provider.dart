import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdp/modals/user.dart';
import 'package:sdp/repo/chat_repo.dart';
import 'package:sdp/repo/user_repo.dart';

/// Manages user authentication state and operations
///
/// This notifier handles user authentication flows including:
/// - User registration
/// - Email/password authentication
/// - Google authentication
/// - Session management
/// - Sign out functionality
class UserNotifier extends AutoDisposeAsyncNotifier<List<Users>> {
  /// Currently logged-in user
  static Users? _loggedInUser;

  /// Repository instances for data access
  final ChatRepo chatRepo = ChatRepo();
  final UserRepo _userRepo = UserRepo();

  @override
  Future<List<Users>> build() async {
    // Initialize with empty list
    return [];
  }

  //---------------------- AUTHENTICATION METHODS ----------------------//

  /// Registers a new user in the system
  ///
  /// @param user The user object containing registration details
  /// @returns true if registration was successful, false otherwise
  Future<bool> addUser(Users user) async {
    try {
      return await _userRepo.addUser(user);
    } catch (e, stack) {
      // Update state with error and propagate failure
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Authenticates a user with email and password
  ///
  /// @param email User's email address
  /// @param password User's password
  /// @returns User object if authentication successful, null otherwise
  Future<Users?> authenticateUser(String email, String password) async {
    try {
      final user = await _userRepo.signInWithEmailPassword(email, password);
      loginUser(user);
      return user;
    } catch (e, stack) {
      // Update state with error and return null to indicate failure
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Authenticates a user using Google Sign-In
  ///
  /// @returns User object if authentication successful, null otherwise
  Future<Users?> googleSignIn() async {
    try {
      Users? user = await _userRepo.google_SignIn();
      if (user != null) {
        loginUser(user);
      }
      return user;
    } catch (e, stack) {
      // Update state with error and return null to indicate failure
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  //---------------------- SESSION MANAGEMENT ----------------------//

  /// Updates the logged-in user reference
  ///
  /// @param user The user object to set as current user
  void loginUser(Users? user) {
    _loggedInUser = user;
  }

  /// Gets the currently logged-in user
  ///
  /// @returns The current user object or null if no user is logged in
  Users? get loggedInUser => _loggedInUser;

  //---------------------- SIGN OUT METHODS ----------------------//

  /// Signs out the current user from standard authentication
  ///
  /// Clears the current user reference and ends the backend session
  Future<void> signOut() async {
    _loggedInUser = null;
    await _userRepo.signOut();
  }

  /// Signs out the current user from Google authentication
  ///
  /// Clears the current user reference and ends the Google session
  Future<void> goolgeSignOut() async {
    _loggedInUser = null;
    await UserRepo.googleSignOut();
  }
}

/// Provider for accessing the UserNotifier throughout the app
///
/// This auto-disposable provider manages the lifecycle of the UserNotifier
/// and makes it available to the widget tree
final userNotifierProvider =
    AsyncNotifierProvider.autoDispose<UserNotifier, List<Users>>(
        () => UserNotifier());
