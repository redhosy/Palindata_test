import 'package:flutter/foundation.dart';

class FirstScreenProvider extends ChangeNotifier {
  String _nama = '';
  String _kalimat = '';

  String get nama => _nama;
  String get kalimat => _kalimat;

  void setNama(String value){
    _nama = value;
  }

  void setKalimat(String value){
    _kalimat = value;
  }

  // logika cek palindrome
  bool isPalindrome(String text){
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final reversedText = cleanText.split('').reversed.join('');
    return cleanText == reversedText;
  }

  String getPalindromeCheckMessage() {
    if (_kalimat.isEmpty) {
      return 'Tolong masukkan kalimat';
    }
    return isPalindrome(_kalimat) 
      ? 'isPalindrome' 
      : 'not palindrome';
  }

  void clearInputs(){
    _nama = '';
    _kalimat = '';
    notifyListeners();
  }
}