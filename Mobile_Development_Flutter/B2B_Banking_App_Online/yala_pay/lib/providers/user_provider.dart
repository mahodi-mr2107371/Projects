import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider() : super(null) {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        // Convert Firebase user to your custom User model
        final userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          state = User(
            email: firebaseUser.email ?? '',
            firstName: userDoc.data()?['firstName'] ?? '',
            lastName: userDoc.data()?['lastName'] ?? '',
            password: '', // Don't store password in state
          );
        }
      } else {
        state = null;
      }
    });
  }

  Future<void> addUser(
      String email, String password, String firstName, String lastName) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      });

      // Update state with new user
      state = User(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: '', // Don't store password in state
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logInCheck(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user details from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        state = User(
          email: email,
          firstName: userDoc.data()?['firstName'] ?? '',
          lastName: userDoc.data()?['lastName'] ?? '',
          password: '', // Don't store password in state
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = null;
  }
}

final authProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
