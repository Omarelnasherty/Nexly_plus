import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class AuthService {
  static Future<void> verifyOtpAndLogin({
    required String verificationId,
    required String smsCode,
    required String name,
    required String phone,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("No UID found");

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

    await ZIMKit().connectUser(id: uid, name: name);
  }
}
