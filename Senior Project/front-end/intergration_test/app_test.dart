import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sdp/main.dart' as app;
import 'package:sdp/screens/home_page.dart';

/// Integration tests for the application's authentication and chat functionality
void main() {
  // Initialize the integration test environment
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Welcome page and authentication tests',
    () {
      /// Test successful login with valid credentials
      ///
      /// Verifies that a user can login with correct email/password
      /// and is directed to the HomePage
      testWidgets(
        'Login with correct credentials',
        (tester) async {
          // Launch the application
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Enter valid login credentials
          await tester.enterText(
              find.byKey(const Key("email_field")), "basil@yala2.com");
          await tester.enterText(
              find.byKey(const Key("pass_field")), "pass1234");

          // Wait for UI to stabilize
          await Future.delayed(const Duration(seconds: 2));

          // Tap the login button
          await tester.tap(find.byKey(const Key("submit_button")));

          // Wait for navigation to complete
          await tester.pumpAndSettle(const Duration(seconds: 4));

          // Verify the user is redirected to HomePage
          expect(find.byType(HomePage), findsOneWidget);
        },
      );

      /// Test failed login with invalid credentials
      ///
      /// Verifies that incorrect login credentials show an error dialog
      testWidgets(
        'Login with incorrect credentials',
        (tester) async {
          // Launch the application
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Enter invalid login credentials
          await tester.enterText(
              find.byKey(const Key("email_field")), "mahodihasan7@gmail.com");
          await tester.enterText(
              find.byKey(const Key("pass_field")), "123456789");

          // Tap the login button
          await tester.tap(find.byKey(const Key("submit_button")));

          // Wait for UI to stabilize
          await tester.pumpAndSettle();

          // Verify error dialog is displayed
          expect(find.byType(AlertDialog), findsOneWidget);
        },
      );

      /// Test chat message functionality
      ///
      /// Verifies that users can send messages in the chat interface
      /// and messages appear in the conversation
      testWidgets(
        'Send and verify chat message',
        (tester) async {
          // Launch the application
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Log in with valid credentials
          await tester.enterText(
              find.byKey(const Key("email_field")), "basil@yala2.com");
          await tester.enterText(
              find.byKey(const Key("pass_field")), "pass1234");
          await tester.tap(find.byKey(const Key("submit_button")));

          // Wait for navigation to complete
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Enter test message in chat input
          await tester.enterText(find.byKey(const Key("chat_input")), "hi");

          // Submit message (trigger onSubmitted)
          await tester.testTextInput.receiveAction(TextInputAction.done);

          // Wait for message to be processed
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify message appears in the chat
          expect(find.text("hi"), findsOneWidget);
        },
      );
    },
  );
}
