// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sdp/screens/home_page.dart';
// import 'package:sdp/providers/chat_provider.dart';
// import 'package:sdp/providers/user_provider.dart';
// // import 'package:sdp/modals/chat.dart';

// // Mock providers
// class MockChatNotifier extends Mock implements ChatProvider {}

// class MockUserNotifier extends Mock implements UserNotifier {}

// void main() {
//   late MockChatNotifier mockChatNotifier;
//   late MockUserNotifier mockUserNotifier;

//   setUp(() {
//     mockChatNotifier = MockChatNotifier();
//     mockUserNotifier = MockUserNotifier();

//     when(() => mockChatNotifier.controller).thenReturn(TextEditingController());
//     when(() => mockChatNotifier.removeAll()).thenReturn(null);
//     when(() => mockUserNotifier.signOut()).thenReturn(null);
//   });

//   testWidgets('HomePage UI renders correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           chatProviderNotifier.overrideWith((ref) => mockChatNotifier),
//           userNotifierProvider.overrideWith((ref) => mockUserNotifier),
//         ],
//         child: const MaterialApp(
//           home: HomePage(),
//         ),
//       ),
//     );

//     expect(find.text('Plant Health+'), findsOneWidget);
//     expect(find.byIcon(Icons.menu), findsOneWidget);
//     expect(find.byIcon(Icons.edit_document), findsOneWidget);
//     expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
//     expect(find.byType(TextField), findsOneWidget);
//   });

//   testWidgets('Chat input works and clears after submitting',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           chatProviderNotifier.overrideWith((ref) => mockChatNotifier),
//         ],
//         child: const MaterialApp(
//           home: HomePage(),
//         ),
//       ),
//     );

//     final textFieldFinder = find.byType(TextField);
//     await tester.enterText(textFieldFinder, "Hello, World!");
//     await tester.testTextInput.receiveAction(TextInputAction.done);

//     verify(() => mockChatNotifier.addChat(any())).called(1);
//   });

//   testWidgets('Logout button triggers sign out', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           userNotifierProvider.overrideWith((ref) => mockUserNotifier),
//         ],
//         child: const MaterialApp(
//           home: HomePage(),
//         ),
//       ),
//     );

//     await tester.tap(find.byIcon(Icons.logout_rounded));
//     await tester.pump();

//     verify(() => mockUserNotifier.signOut()).called(1);
//   });
// }
