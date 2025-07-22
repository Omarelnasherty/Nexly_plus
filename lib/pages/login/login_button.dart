import 'package:flutter/material.dart';
import 'package:chat/services/login_service.dart';

class LoginButton extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const LoginButton({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _loading = false;
  String? _error;

  void _confirmAndLogin() {
    final rawPhone = widget.phoneController.text.trim();
    final name = widget.nameController.text.trim();
    final phone = rawPhone.replaceAll(RegExp(r'\D'), '');

    if (phone.isEmpty || name.isEmpty) {
      setState(() => _error = "Please enter your name and phone number.");
      return;
    }

    if (!RegExp(r'^\d{10,15}$').hasMatch(phone)) {
      setState(() => _error = "Phone number must be 10 to 15 digits.");
      return;
    }

    final fullPhone = "+20$phone";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Phone Number"),
        content: Text("Is this your phone number?\n\n$fullPhone"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _loading = true);
              LoginService.startPhoneAuth(
                context,
                fullPhone,
                name,
                onError: (err) {
                  setState(() {
                    _loading = false;
                    _error = err;
                  });
                },
              );
            },
            child: const Text("Yes, Continue"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _loading ? null : _confirmAndLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
