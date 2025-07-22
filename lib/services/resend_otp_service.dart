import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

class ResendOtpService {
  static Future<void> resendCode({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required VoidCallback onFailed,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        onFailed();
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
