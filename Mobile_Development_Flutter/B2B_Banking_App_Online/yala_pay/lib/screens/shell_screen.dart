// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ShellScreen extends StatefulWidget {
  final Widget _screen;
  int _selectedIndex;
  ShellScreen({super.key, required Widget screen, required int screenIndex})
      : _screen = screen,
        _selectedIndex = screenIndex;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  void _onItemSelected(int index) {
    setState(() {
      widget._selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('dashboard');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('customers');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('invoices');
        break;

      case 3:
        Navigator.of(context).pushReplacementNamed('chequeCache');
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed('reports');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(226, 149, 120, 1),
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(226, 149, 120, 1),
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(226, 149, 120, 1),
            icon: Icon(Icons.request_page_outlined),
            activeIcon: Icon(Icons.request_page),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(226, 149, 120, 1),
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Cheque Deposit',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(226, 149, 120, 1),
            icon: Icon(Icons.find_in_page_outlined),
            activeIcon: Icon(Icons.find_in_page),
            label: 'Reports',
          ),
        ],
        currentIndex: widget._selectedIndex,
        onTap: _onItemSelected,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
      body: widget._screen,
    );
  }
}
