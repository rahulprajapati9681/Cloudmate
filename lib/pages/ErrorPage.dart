import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String city;

  const ErrorPage({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),   // Pure Black
              Color(0xFF1C1C1C),   // Dark Gray
              Color(0xFF383838),   // Medium Gray
              Color(0xFF4F4F4F),   // Light Grayish Black
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/notFound.png",    // Use the same logo for consistency
                width: 200,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),

              // Error Icon
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.yellow,    // Highlight the error in red
              ),
              const SizedBox(height: 20),

              // City Not Found Text
              Text(
                "Oops! '$city' not found.",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,      // White text for contrast
                ),
              ),
              const SizedBox(height: 10),

              // Suggestion Text
              const Text(
                "Please check the spelling or try another city.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,     // Slightly dimmed white
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Back Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,   // Button color
                  foregroundColor: Colors.white,        // Text color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
