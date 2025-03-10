import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String _title;
  final Widget _detail;
  const InfoCard({super.key, required title, required details})
      : _title = title,
        _detail = details;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      color: const Color.fromARGB(255, 243, 229, 248),
       
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                _title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Title color
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between title and details
          _detail,
          ],
        ),
      ),
    );
  }
}
