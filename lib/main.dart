import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ZIMKit().init(
    appID: 713906771,
    appSign: "1012b1b3ab2af4815b46f314b90967fca85e666df9dd0e44272253229a943e62",
  );

  final prefs = await SharedPreferences.getInstance();
  final savedUserId = prefs.getString('userId');
  final savedUserName = prefs.getString('userName');

  bool loggedIn = false;

  if (savedUserId != null &&
      savedUserName != null &&
      savedUserId.trim().isNotEmpty &&
      savedUserName.trim().isNotEmpty) {
    try {
      await ZIMKit().connectUser(
        id: savedUserId.trim(),
        name: savedUserName.trim(),
      );
      loggedIn = true;
    } catch (e) {
      // فشل تسجيل الدخول، احذف البيانات التالفة
      await prefs.remove('userId');
      await prefs.remove('userName');
    }
  }

  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zego In-App Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: loggedIn ? const ChatListPage() : const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    final userId = _userIdController.text.trim();
    final userName = _userNameController.text.trim();

    if (userId.isEmpty || userName.isEmpty) {
      setState(() {
        _error = "من فضلك أدخل المعرف واسم المستخدم.";
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ZIMKit().connectUser(id: userId, name: userName);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ChatListPage()),
      );
    } catch (e) {
      setState(() {
        _error = "فشل تسجيل الدخول: ${e.toString()}";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'User Name'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await ZIMKit().disconnectUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');

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
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'تسجيل الخروج',
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
