import 'package:flutter/material.dart';
import '../models/email_message.dart';

class MainMailScreen extends StatefulWidget {
  const MainMailScreen({super.key});

  @override
  State<MainMailScreen> createState() => _MainMailScreenState();
}

class _MainMailScreenState extends State<MainMailScreen> {
  final List<EmailMessage> _emails = [
    EmailMessage(
      id: '1',
      sender: 'Martin Hrivnák',
      avatarText: 'MH',
      subject: 'Ponuka na pozemok Senica - Kunov',
      snippet: 'Ahoj, pozeral som tie výkresy k novému projektu...',
      time: '10:42',
      isUnread: true,
      chatHistory: [
        ChatMessage(text: 'Ahoj, pozeral som tie výkresy k novému projektu, vyzerá to super.', isMe: false, time: '10:40'),
        ChatMessage(text: 'Dnes o 15:00 to môžeme prebrať.', isMe: true, time: '10:42'),
      ],
    ),
    EmailMessage(
      id: '2',
      sender: 'Lucia Novotná',
      avatarText: 'LN',
      subject: 'Nové vzorky pre goodbad bielizeň',
      snippet: 'Zásielka z výroby dorazila, balenie má presne...',
      time: 'Včera',
      isUnread: false,
      chatHistory: [
        ChatMessage(text: 'Zásielka z výroby dorazila.', isMe: false, time: 'Včera 14:15'),
      ],
    ),
  ];

  String? _selectedEmailId = '1';
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      body: isWideScreen ? _buildSplitViewLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildSplitViewLayout() {
    final selectedEmail = _emails.firstWhere(
      (e) => e.id == _selectedEmailId,
      orElse: () => _emails.first,
    );

    return Row(
      children: [
        SizedBox(
          width: 340,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: ListView.separated(
                    itemCount: _emails.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final email = _emails[index];
                      return _buildEmailItemTile(email, email.id == _selectedEmailId);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: Container(
            child: _buildChatDetailView(selectedEmail),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _buildHeaderBar(),
          Expanded(
            child: ListView.separated(
              itemCount: _emails.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final email = _emails[index];
                return _buildEmailItemTile(email, false, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: Text(email.sender)),
                        body: _buildChatDetailView(email),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Doručená pošta",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.sync, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEmailItemTile(EmailMessage email, bool isSelected, {VoidCallback? onTap}) {
    return Material(
      color: isSelected ? const Color(0xFFE5F1FF) : Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => setState(() => _selectedEmailId = email.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(child: Text(email.avatarText)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(email.sender, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(email.subject, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatDetailView(EmailMessage email) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: email.chatHistory.length,
            itemBuilder: (context, index) {
              final chat = email.chatHistory[index];
              return Align(
                alignment: chat.isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: chat.isMe ? const Color(0xFF007AFF) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    chat.text,
                    style: TextStyle(color: chat.isMe ? Colors.white : Colors.black87),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _replyController,
                  decoration: const InputDecoration(hintText: 'Napíš správu...'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_replyController.text.isNotEmpty) {
                    setState(() {
                      email.chatHistory.add(ChatMessage(
                        text: _replyController.text,
                        isMe: true,
                        time: 'Práve teraz',
                      ));
                      _replyController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
