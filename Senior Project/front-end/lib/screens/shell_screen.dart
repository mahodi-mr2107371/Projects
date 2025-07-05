import 'package:flutter/material.dart';

/// A wrapper widget that provides a consistent shell/container around content screens.
///
/// This widget adds a minimal app bar to the provided screen widget, creating a
/// consistent UI structure throughout the application while allowing different content
/// to be displayed within the same shell.
class ShellScreen extends StatelessWidget {
  /// The content widget to be displayed in the shell.
  final Widget _screen;

  /// Creates a ShellScreen with the specified content.
  ///
  /// The [screen] parameter is required and represents the main content
  /// to be displayed within this shell container.
  const ShellScreen({super.key, required Widget screen}) : _screen = screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Sets the app bar height to 1% of the screen height for a minimal appearance
        toolbarHeight: MediaQuery.of(context).size.height * 0.01,
        backgroundColor: Colors.white,
      ),
      // Displays the provided screen widget as the main content
      body: _screen,
    );
  }
}
