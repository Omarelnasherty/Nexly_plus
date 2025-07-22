import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat/pages/auth/otp_page.dart';
import 'package:chat/pages/chat/chat_list_page.dart';

class LoginService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> startPhoneAuth(
    BuildContext context,
    String phoneNumber,
    String name, {
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await _saveUserData(name, phoneNumber);
        _goToChatList(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "Verification failed");
      },
      codeSent: (verificationId, resendToken) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(
              verificationId: verificationId,
              phone: phoneNumber,
              name: name,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  static Future<void> _saveUserData(String name, String phone) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'uid': uid,
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static void _goToChatList(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ChatListPage()),
    );
  }
}
