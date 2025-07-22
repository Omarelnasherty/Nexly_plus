import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../services/auth_service.dart';
import '../../services/resend_otp_service.dart';
import '../../widgets/auth/otp_input.dart';
import '../../constants/colors.dart';

import '../chat/chat_list_page.dart';

class OtpPage extends StatefulWidget {
  String verificationId;
  final String phone;
  final String name;

  OtpPage({
    super.key,
    required this.verificationId,
    required this.phone,
    required this.name,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  String? _error;

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        _timer?.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _verifyCode() async {
    final smsCode = _codeController.text.trim();

    if (smsCode.isEmpty) {
      setState(() => _error = "Please enter the code");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await AuthService.verifyOtpAndLogin(
        verificationId: widget.verificationId,
        smsCode: smsCode,
        name: widget.name,
        phone: widget.phone,
      );

      _goToChatList();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Invalid SMS code or login failed. Please try again.";
      });
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _error = null;
      _canResend = false;
      _secondsRemaining = 60;
    });

    _startTimer();

    await ResendOtpService.resendCode(
      phone: widget.phone,
      onCodeSent: (verificationId) {
        setState(() => widget.verificationId = verificationId);
      },
      onFailed: () {
        setState(() => _error = "Failed to resend code. Please try again.");
      },
    );
  }

  void _goToChatList() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ChatListPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify Code"),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "We’ve sent a verification code to",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.phone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OtpInput(controller: _codeController),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Verify",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 32),
            Center(
              child: _canResend
                  ? TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        "Resend Code",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Text(
                      "You can resend the code in $_secondsRemaining seconds",
                      style: const TextStyle(color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
