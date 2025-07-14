import 'package:chat/pages/profile_page.dart';
import 'package:chat/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../services/zim_service.dart';
import 'package:zego_zim/zego_zim.dart';
import 'login_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await ZIMService().disconnect();
    await StorageHelper.clearUser();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'الملف الشخصي',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: ZIMKitConversationListView(
        onPressed: (context, conversation, user) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ZIMKitMessageListPage(
                conversationID: conversation.id,
                conversationType: conversation.type,
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addChat',
            onPressed: () async {
              String otherUserId = '';
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('إنشاء محادثة جديدة'),
                    content: TextField(
                      onChanged: (value) => otherUserId = value,
                      decoration: const InputDecoration(
                        labelText: 'معرف المستخدم الآخر',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (otherUserId.trim().isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ZIMKitMessageListPage(
                                  conversationID: otherUserId.trim(),
                                  conversationType: ZIMConversationType.peer,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('إنشاء'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
            tooltip: 'محادثة فردية',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'joinGroup',
            onPressed: () async {
              String groupID = '';
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('الانضمام إلى مجموعة'),
                    content: TextField(
                      onChanged: (value) => groupID = value,
                      decoration: const InputDecoration(
                        labelText: 'معرف المجموعة',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (groupID.trim().isNotEmpty) {
                            int errorCode = await ZIMKit().joinGroup(
                              groupID.trim(),
                            );
                            if (errorCode == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ZIMKitMessageListPage(
                                    conversationID: groupID.trim(),
                                    conversationType: ZIMConversationType.group,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('انضمام'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.group),
            tooltip: 'انضمام إلى مجموعة',
          ),
        ],
      ),
    );
  }
}
