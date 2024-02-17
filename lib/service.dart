import 'dart:math';

class PasswordGeneratorService {
  static const String _alphabets =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  static const String _numbers = '0987654321';
  static const String _symbols = '!@#%^&*+?<>"~';

  static String generate({
    int length = 8,
    bool symbols = true,
    bool numbers = true,
  }) {
    final String _chars =
        '$_alphabets${symbols ? _symbols : ''}${numbers ? _numbers : ''}';
    final Random r = Random();
    return List<String>.generate(
        length, (int index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
