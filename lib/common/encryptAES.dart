import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class MyEncryptDecrypt {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  String encryptAES(String text) {
    final enText = encrypter.encrypt(text, iv: iv);
    print(enText.base16);
    print(enText.base64);
    print(enText.bytes);
    print(enText);
    return enText.base16;
  }

  String decryptAES(text) {
    // final deText = encrypter.encrypt(text, iv: iv);
    // var encrypted = Encrypted(encrypter.encryptBytes(encryptAES(text)).bytes);
    // String ttt = encryptAES(text);
    final decrypted = encrypter.decrypt(Encrypted.fromBase16(text), iv: iv);
    return decrypted;
  }

//

  //
}
