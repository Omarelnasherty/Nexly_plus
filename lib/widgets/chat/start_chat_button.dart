import 'package:flutter/material.dart';
import '../../services/chat_service.dart';

class StartChatButton extends StatelessWidget {
  final String currentUserID;
  const StartChatButton({super.key, required this.currentUserID});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: FloatingActionButton(
            onPressed: () => ChatService.startNewChat(context, currentUserID),
            backgroundColor: const Color(0xFF674FA3),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.chat, size: 28, color: Colors.white),
            tooltip: 'Start new chat',
          ),
        );
      },
    );
  }
}
