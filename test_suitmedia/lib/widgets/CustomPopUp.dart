import 'package:flutter/material.dart';

class CustomResultDialog extends StatelessWidget {
  final String nama;
  final String message;
  final bool isPalindromeResult;

  const CustomResultDialog(
      {super.key,
      required this.nama,
      required this.message,
      required this.isPalindromeResult});

  @override
  Widget build(BuildContext context) {
    final IconData icon =
        isPalindromeResult ? Icons.check_circle : Icons.cancel;
    final Color iconColor =
        isPalindromeResult ? Colors.green.shade600 : Colors.red.shade600;
    final String resultText =
        isPalindromeResult ? 'isPalindrome!' : 'Not Palindrome!';

    // AlertDialog untuk menampilkan hasil
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nama.isNotEmpty ? 'Hello, $nama!' : 'Hello!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          const Text(
            'Hasil Palindrom :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),

          Icon(
            icon,
            color: iconColor,
            size: 50,
          ),
          const SizedBox(
            height: 10,
          ),

          Text(
            resultText,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: iconColor),
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
